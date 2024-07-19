package riscv.plugins

import riscv._

import spinal.core._
import spinal.lib.slave

class BranchUnit(branchStages: Set[Stage]) extends Plugin[Pipeline] with BranchService {

  object BranchCondition extends SpinalEnum {
    val NONE, EQ, NE, LT, GE, LTU, GEU = newElement()
  }

  object Data {
    object BU_IS_BRANCH extends PipelineData(Bool())
    object BU_WRITE_RET_ADDR_TO_RD extends PipelineData(Bool())
    object BU_IGNORE_TARGET_LSB extends PipelineData(Bool())
    object BU_CONDITION extends PipelineData(BranchCondition())
  }

  override def setup(): Unit = {
    val alu = pipeline.service[IntAluService]
    val issuer = pipeline.service[IssueService]

    pipeline.service[DecoderService].configure { config =>
      config.addDefault(
        Map(
          Data.BU_IS_BRANCH -> False,
          Data.BU_WRITE_RET_ADDR_TO_RD -> False,
          Data.BU_IGNORE_TARGET_LSB -> False,
          Data.BU_CONDITION -> BranchCondition.NONE
        )
      )

      config.addDecoding(
        Opcodes.JAL,
        InstructionType.J,
        Map(
          Data.BU_IS_BRANCH -> True,
          Data.BU_WRITE_RET_ADDR_TO_RD -> True
        )
      )

      issuer.setDestinations(Opcodes.JAL, branchStages)

      alu.addOperation(Opcodes.JAL, alu.AluOp.ADD, alu.Src1Select.PC, alu.Src2Select.IMM)

      config.addDecoding(
        Opcodes.JALR,
        InstructionType.I,
        Map(
          Data.BU_IS_BRANCH -> True,
          Data.BU_WRITE_RET_ADDR_TO_RD -> True,
          Data.BU_IGNORE_TARGET_LSB -> True
        )
      )

      issuer.setDestinations(Opcodes.JALR, branchStages)

      alu.addOperation(Opcodes.JALR, alu.AluOp.ADD, alu.Src1Select.RS1, alu.Src2Select.IMM)

      val branchConditions = Map(
        Opcodes.BEQ -> BranchCondition.EQ,
        Opcodes.BNE -> BranchCondition.NE,
        Opcodes.BLT -> BranchCondition.LT,
        Opcodes.BGE -> BranchCondition.GE,
        Opcodes.BLTU -> BranchCondition.LTU,
        Opcodes.BGEU -> BranchCondition.GEU
      )

      for ((opcode, condition) <- branchConditions) {
        config.addDecoding(
          opcode,
          InstructionType.B,
          Map(
            Data.BU_IS_BRANCH -> True,
            Data.BU_CONDITION -> condition
          )
        )

        issuer.setDestinations(opcode, branchStages)

        alu.addOperation(opcode, alu.AluOp.ADD, alu.Src1Select.PC, alu.Src2Select.IMM)
      }
    }
  }

  override def build(): Unit = {
    val libraService = pipeline.service[LibraService]

    for (stage <- branchStages) {
      val branchArea = stage plug new Area {
        import stage._

        val aluResultData = pipeline.service[IntAluService].resultData
        val target = aluResultData.dataType()

        // add offset for right jumps
        target := value(aluResultData) + (U(libraService.isRightJal(stage)) << 2)

        when(value(Data.BU_IGNORE_TARGET_LSB)) {
          target(0) := False
        }

        // val misaligned = target(1 downto 0).orR

        val src1, src2 = UInt(config.xlen bits)
        src1 := value(pipeline.data.RS1_DATA)
        src2 := value(pipeline.data.RS2_DATA)

        val eq = src1 === src2
        val ne = !eq
        val lt = src1.asSInt < src2.asSInt
        val ltu = src1 < src2
        val ge = !lt
        val geu = !ltu
        val pc = value(pipeline.data.PC)

        val condition = value(Data.BU_CONDITION)

        val branchTaken = condition.mux(
          BranchCondition.NONE -> True,
          BranchCondition.EQ -> eq,
          BranchCondition.NE -> ne,
          BranchCondition.LT -> lt,
          BranchCondition.GE -> ge,
          BranchCondition.LTU -> ltu,
          BranchCondition.GEU -> geu
        )

        val jumpService = pipeline.service[JumpService]

        // Read current Libra state
        val libraCur = libraService.getLibraState(stage)

        when(arbitration.isValid && value(Data.BU_IS_BRANCH)) {
          when(condition =/= BranchCondition.NONE) {
            arbitration.rs1Needed := True
            arbitration.rs2Needed := True
          }

          val libraNew = UInt(config.xlen bits)
          libraNew := libraCur

          when(!arbitration.isStalled) {
            when(libraService.isLob(stage)) {
              val isTerminatingLob = libraService.isTerminatingLob(stage)
              pipeline.service[BranchTargetPredictorService].updatePrevented(stage) := True

              val membCnt = UInt(4 bits)
              val offT = UInt(4 bits)
              val offF = UInt(4 bits)
              val distance = UInt(3 bits)
              val nextSlice = UInt(config.xlen bits)

              when(isTerminatingLob) {
                // terminating LOB
                distance := value(pipeline.data.IMM)(3 downto 1)
                membCnt := U(False ## value(pipeline.data.IMM)(6 downto 4))
                offT := U(False ## value(pipeline.data.IMM)(9 downto 7))
                offF := U(False ## value(pipeline.data.IMM)(12 downto 10))
              } otherwise {
                // ordinary LOB
                distance := 0
                membCnt := value(pipeline.data.IMM)(4 downto 1)
                offT := value(pipeline.data.IMM)(8 downto 5)
                offF := value(pipeline.data.IMM)(12 downto 9)
              }

              when(libraService.isActive(libraCur)) {
                nextSlice := pc + ((libraService.membCnt(libraCur) - libraService.curOff(
                  libraCur
                )) << 2)
              } otherwise {
                nextSlice := pc + 4
              }

              when(isTerminatingLob) {
                libraService.terminatingActive(libraNew) := True
                val firstNonFoldedPc = nextSlice + ((distance * (membCnt + 1)) << 2)
                libraService.terminatingSubPc(libraNew) := firstNonFoldedPc(
                  0 until libraService.SBE_TERMINATING_SUBPC
                )
              }

              val off = branchTaken ? offT | offF

              // Update Libra state
              libraService.membCnt(libraNew) := membCnt.resize(4) + 1
              libraService.curOff(libraNew) := off.resize(4)

              libraService.isActive(libraNew) := membCnt =/= 0

              target := (nextSlice + (off << 2)).resized
              jumpService.jump(stage, target)
              //  The following makes the level-offset branch a constant-time
              //  operation by undoing the jump-cancellation hack by the BPU
              jumpService.jumpRequested(stage) := True
            } elsewhen (branchTaken) {
              jumpService.jump(stage, target)

              when(value(Data.BU_WRITE_RET_ADDR_TO_RD)) {
                output(pipeline.data.RD_DATA) := input(pipeline.data.NEXT_PC)
                output(pipeline.data.RD_DATA_VALID) := True

                val isLeftJal = libraService.isLeftJal(stage)
                val isRightJal = libraService.isRightJal(stage)

                when(isLeftJal | isRightJal) {
                  pipeline.service[BranchTargetPredictorService].updatePrevented(stage) := True
                  // Push new libra context
                  //  (i.e., shift current into previous libra context)
                  libraNew := (libraCur << libraService.SBE_LIBRA_CONTEXT_SIZE).resized
                  libraService.membCnt(libraNew) := 2
                  libraService.isActive(libraNew) := True

                  // set offset to 1 for right jumps
                  libraService.curOff(libraNew) := U(isRightJal).resize(4)
                }

                when(libraService.isReturn(stage) & libraService.savedContextActive(libraCur)) {
                  pipeline.service[BranchTargetPredictorService].updatePrevented(stage) := True
                  // There is a previous libra context, restore it
                  libraNew := (libraCur >> libraService.SBE_LIBRA_CONTEXT_SIZE).resized
                }
              }
            }
            libraService.setLibraState(stage) := libraNew
          }
        }
      }
    }
  }

  override def isBranch(stage: Stage): Bool = {
    stage.output(Data.BU_IS_BRANCH)
  }
}
