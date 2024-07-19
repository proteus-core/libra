package riscv.plugins

import riscv._
import spinal.core._
import spinal.lib._

class Libra extends Plugin[Pipeline] with LibraService {

  override def getImplementedExtensions = Seq('X') // SBE

  // The Libra state is stored in the CSR with following identifier
  val CSR_LIBRA_STATE = 0x7ff
  val SBE_ACTIVE_BIT = 1
  val SBE_MEMBCNT_BITSIZE = 4
  val SBE_CUROFF_BITSIZE = 4
  val SBE_TERMINATING_ACTIVE = 1
  val SBE_TERMINATING_SUBPC = 6
  val SBE_LIBRA_CONTEXT_SIZE =
    SBE_ACTIVE_BIT + SBE_MEMBCNT_BITSIZE + SBE_CUROFF_BITSIZE + SBE_TERMINATING_ACTIVE + SBE_TERMINATING_SUBPC

  assert(SBE_LIBRA_CONTEXT_SIZE <= 16)

  object Data {
    object SBE_IS_RETURN extends PipelineData(Bool())
    object SBE_IS_LOBRANCH extends PipelineData(Bool())
    object SBE_IS_TLOBRANCH extends PipelineData(Bool())
    object SBE_IS_LEFTJAL extends PipelineData(Bool())
    object SBE_IS_RIGHTJAL extends PipelineData(Bool())
    object SBE_IS_LIBRA_INST extends PipelineData(Bool())
    object SBE_LIBRA_STATE extends PipelineData(UInt(config.xlen bits))
  }

  override def isActive(state: UInt): Bool = {
    state(0)
  }

  override def savedContextActive(state: UInt): Bool = {
    state(SBE_LIBRA_CONTEXT_SIZE)
  }

  override def membCnt(state: UInt): UInt = {
    state(SBE_ACTIVE_BIT until SBE_ACTIVE_BIT + SBE_MEMBCNT_BITSIZE)
  }

  override def curOff(state: UInt): UInt = {
    state(
      SBE_ACTIVE_BIT + SBE_MEMBCNT_BITSIZE until SBE_ACTIVE_BIT + SBE_MEMBCNT_BITSIZE + SBE_CUROFF_BITSIZE
    )
  }

  override def terminatingActive(state: UInt): Bool = {
    state(SBE_ACTIVE_BIT + SBE_MEMBCNT_BITSIZE + SBE_CUROFF_BITSIZE)
  }

  override def terminatingSubPc(state: UInt): UInt = {
    state(
      SBE_ACTIVE_BIT + SBE_MEMBCNT_BITSIZE + SBE_CUROFF_BITSIZE + SBE_TERMINATING_ACTIVE until SBE_ACTIVE_BIT + SBE_MEMBCNT_BITSIZE + SBE_CUROFF_BITSIZE + SBE_TERMINATING_ACTIVE + SBE_TERMINATING_SUBPC
    )
  }

  override def getSliceBaseAddress(current: UInt, offset: UInt): UInt = {
    current - (offset << 2)
  }

  // Libra state
  private class LibraCSR() extends Csr {
    assert(config.xlen == 32, "libra only supported for 32-bit")

    val libra = Reg(UInt(config.xlen bits)).init(0)

    override def read(): UInt = libra

    override def write(v: UInt): Unit = {
      libra := v
    }
  }

  private def isConditional(ir: UInt): Bool = {
    (ir === Opcodes.BEQ) ||
    (ir === Opcodes.BNE) ||
    (ir === Opcodes.BLT) ||
    (ir === Opcodes.BGE) ||
    (ir === Opcodes.BLTU) ||
    (ir === Opcodes.BGEU)
  }

  private def isReturn(ir: UInt): Bool = {
    (ir === Opcodes.JALR) && (ir(11 downto 7) === 0) && (ir(19 downto 15) === 1)
  }

  override def setup(): Unit = {
    val csrService = pipeline.service[CsrService]

    csrService.registerCsr(CSR_LIBRA_STATE, new LibraCSR)

    pipeline.service[DecoderService].configure { decoderConfig =>
      decoderConfig.addDefault(
        Map(
          Data.SBE_IS_RETURN -> False,
          Data.SBE_IS_LOBRANCH -> False,
          Data.SBE_IS_TLOBRANCH -> False,
          Data.SBE_IS_LEFTJAL -> False,
          Data.SBE_IS_RIGHTJAL -> False,
          Data.SBE_IS_LIBRA_INST -> False
        )
      )

      decoderConfig.setIrMapper((stage, ir) => {
        val withHighLsbs = ir | 3
        val output = UInt(config.xlen bits)
        output := ir

        when(isConditional(withHighLsbs)) {
          switch(ir(1 downto 0)) {
            is(0) {
              stage.output(Data.SBE_IS_LOBRANCH) := True
              stage.output(Data.SBE_IS_LIBRA_INST) := True
              output := withHighLsbs
            }
            is(1) {
              stage.output(Data.SBE_IS_TLOBRANCH) := True
              stage.output(Data.SBE_IS_LIBRA_INST) := True
              output := withHighLsbs
            }
          }
        }

        when(withHighLsbs === Opcodes.JAL) {
          switch(ir(1 downto 0)) {
            is(0) {
              stage.output(Data.SBE_IS_LEFTJAL) := True
              stage.output(Data.SBE_IS_LIBRA_INST) := True
              output := withHighLsbs
            }
            is(1) {
              stage.output(Data.SBE_IS_RIGHTJAL) := True
              stage.output(Data.SBE_IS_LIBRA_INST) := True
              output := withHighLsbs
            }
          }
        }

        stage.output(Data.SBE_IS_RETURN) := isReturn(withHighLsbs)

        output
      })

    }
  }

  override def build(): Unit = {
    val stage = pipeline.retirementStage
    val csrArea = stage plug new Area {

      val libra = slave(new CsrIo)
      when(stage.arbitration.isValid) {
        libra.write(stage.output(Data.SBE_LIBRA_STATE))
      }
    }

    pipeline plug new Area {
      val csrService = pipeline.service[CsrService]
      csrArea.libra <> csrService.getCsr(CSR_LIBRA_STATE)
    }
  }

  override def finish(): Unit = {
    // TODO: always get it from decode, does it make a difference?
    pipeline.serviceOption[DataHazardService] match {
      case None =>
        // out-of-order pipeline
        pipeline plug new Area {
          val csr = pipeline.service[CsrService].getCsr(CSR_LIBRA_STATE)
          csr.write := False
          csr.wdata.assignDontCare()

          val decodeStage = pipeline.service[DecoderService].stage

          val libraState = UInt(config.xlen bits)
          libraState := csr.read()

          val retirementStage = pipeline.retirementStage
          when(retirementStage.arbitration.isValid) {
            libraState := retirementStage.output(Data.SBE_LIBRA_STATE)
          }

          when(pipeline.asInstanceOf[DynamicPipeline].rob.lastLibraState.valid) {
            libraState := pipeline.asInstanceOf[DynamicPipeline].rob.lastLibraState.payload
          }

          // make sure TLOB updates are fed back
          when(decodeStage.arbitration.isValid) {
            libraState := decodeStage.output(Data.SBE_LIBRA_STATE)
          }

          pipeline.fetchStage.input(Data.SBE_LIBRA_STATE) := libraState

        }
      case Some(hazardService) =>
        // in-order pipeline
        hazardService.resolveHazard((stage, nextStages) => {
          if (stage == pipeline.fetchStage) {
            val csr = pipeline.service[CsrService].getCsr(CSR_LIBRA_STATE)
            csr.write := False
            csr.wdata.assignDontCare()

            val libraState = UInt(config.xlen bits)
            libraState := csr.read()

            for (laterStage <- nextStages.reverse) {
              when(laterStage.arbitration.isValid) {
                libraState := laterStage.output(Data.SBE_LIBRA_STATE)
              }
            }

            stage.input(Data.SBE_LIBRA_STATE) := libraState
          }
          // We never need to stall.
          False
        })
    }
  }

  override def isLibraInst(stage: Stage): Bool = {
    stage.output(Data.SBE_IS_LIBRA_INST)
  }

  override def isReturn(stage: Stage): Bool = {
    stage.output(Data.SBE_IS_RETURN)
  }

  override def isOrdinaryLob(stage: Stage): Bool = {
    stage.output(Data.SBE_IS_LOBRANCH)
  }

  override def isTerminatingLob(stage: Stage): Bool = {
    stage.output(Data.SBE_IS_TLOBRANCH)
  }

  override def isLob(stage: Stage): Bool = {
    isOrdinaryLob(stage) || isTerminatingLob(stage)
  }

  override def isLeftJal(stage: Stage): Bool = {
    stage.output(Data.SBE_IS_LEFTJAL)
  }

  override def isRightJal(stage: Stage): Bool = {
    stage.output(Data.SBE_IS_RIGHTJAL)
  }

  override def getLibraState(stage: Stage): UInt = {
    stage.input(Data.SBE_LIBRA_STATE)
  }

  override def setLibraState(stage: Stage): UInt = {
    stage.output(Data.SBE_LIBRA_STATE)
  }
}
