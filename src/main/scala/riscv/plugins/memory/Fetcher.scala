package riscv.plugins.memory

import riscv._
import spinal.core._

class Fetcher(fetchStage: Stage) extends Plugin[Pipeline] with FetchService {
  private var addressTranslator = new FetchAddressTranslator {
    override def translate(stage: Stage, address: UInt): UInt = {
      address
    }
  }

  private var addressTranslatorChanged = false

  override def build(): Unit = {
    val fetchArea = fetchStage plug new Area {
      import fetchStage._

      val ibus = pipeline.service[MemoryService].createInternalIBus(fetchStage)
      val ibusCtrl = new MemBusControl(ibus)

      arbitration.isReady := False
      pipeline.service[BranchTargetPredictorService].updatePrevented(fetchStage) := False

      val pc = input(pipeline.data.PC)

      private val libraFetchActive = RegInit(False)
      private val correctIRbuffer = RegInit(UInt(config.xlen bits).getZero)
      private val currentFetchBuffer = RegInit(UInt(config.xlen bits).getZero)

      when(arbitration.isRunning) {
        val libra = pipeline.service[LibraService]
        val correctAddress = addressTranslator.translate(fetchStage, pc)

        val libraState = libra.getLibraState(fetchStage)
        val currentOffset = libra.curOff(libraState)
        val memberCount = libra.membCnt(libraState)

        val ibusBitMask = log2Up(ibus.config.dataWidth / 8)
        val ibusIncrement = 1 << ibusBitMask

        val sliceBase = libra.getSliceBaseAddress(correctAddress, currentOffset)
        val sliceEnd = sliceBase + ((memberCount - 1) << 2)

        val currentSubPc = sliceBase(0 until libra.SBE_TERMINATING_SUBPC)

        val maskedEnd = sliceEnd >> ibusBitMask
        val maskedCorrect = correctAddress >> ibusBitMask

        val currentStep = UInt(config.xlen bits)
        currentStep := currentFetchBuffer

        val updatedState = UInt(config.xlen bits)
        updatedState := libraState

        val terminating = libra.terminatingActive(libraState)
        val terminatingPc = libra.terminatingSubPc(libraState)

        val currentFallsIntoLastLine = True
        val correctFallsIntoCurrentLine = True
        val fetchAddress = UInt(config.xlen bits)
        fetchAddress := correctAddress

        val incr: UInt = 4

        output(pipeline.data.PC) := correctAddress
        output(pipeline.data.NEXT_PC) := correctAddress + incr

        when(libra.isActive(libraState)) {
          when(terminating & currentSubPc === terminatingPc) {
            libra.isActive(updatedState) := False
            libra.terminatingActive(updatedState) := False
            fetchAddress := sliceBase
            output(pipeline.data.PC) := sliceBase
            output(pipeline.data.NEXT_PC) := sliceBase + 4
          } otherwise {
            // disable the branch predictor for folded regions
            pipeline.service[BranchTargetPredictorService].updatePrevented(fetchStage) := True

            when(!libraFetchActive) {
              // first fetch iteration
              libraFetchActive := True
              currentStep := sliceBase
              currentFetchBuffer := currentStep
            }

            correctFallsIntoCurrentLine := (currentStep >> ibusBitMask) === maskedCorrect
            currentFallsIntoLastLine := (currentStep >> ibusBitMask) === maskedEnd

            when(!correctFallsIntoCurrentLine) {
              fetchAddress := currentStep
            }

            incr := memberCount << 2
          }
        }

        val (valid, rdata) = ibusCtrl.read(fetchAddress)

        output(pipeline.data.IR) := correctIRbuffer

        when(valid) {
          currentFetchBuffer := fetchAddress + ibusIncrement
          correctIRbuffer := rdata

          when(correctFallsIntoCurrentLine) {
            output(pipeline.data.IR) := rdata
          }

          // check whether the whole slice fit into a cache line
          arbitration.isReady := currentFallsIntoLastLine
          libraFetchActive := !currentFallsIntoLastLine
        }
        libra.setLibraState(fetchStage) := updatedState
      } otherwise {
        libraFetchActive := False
      }
    }
  }

  override def setAddressTranslator(translator: FetchAddressTranslator): Unit = {
    assert(!addressTranslatorChanged, "FetchAddressTranslator can only be set once")

    addressTranslator = translator
    addressTranslatorChanged = true
  }
}
