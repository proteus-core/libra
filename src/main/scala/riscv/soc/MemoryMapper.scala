package riscv.soc

import riscv._

import spinal.core._
import spinal.lib._
import spinal.lib.misc.HexTools

sealed trait MemorySegment {
  def start: Int
  def length: Int
  def dbus: MemBus
  def ibus: MemBus = null
  def end: Int = start + length
}

case class MemBusSegment(start: Int, length: Int, dbus: MemBus,
                         override val ibus: MemBus = null) extends MemorySegment

case class MemSegment(start: Int, length: Int)(implicit config: Config) extends MemorySegment {
  val mem = Mem(UInt(config.xlen bits), length / (config.xlen / 8))

  val dbus = new MemBus(config.dbusConfig)
  dbus.cmd.ready := True
  dbus.rsp.valid := True
  dbus.rsp.rdata := mem(dbus.cmd.address.resized)
  mem.write(dbus.cmd.address.resized, dbus.cmd.wdata, dbus.cmd.write, dbus.cmd.wmask)

  override val ibus = new MemBus(config.ibusConfig)
  ibus.cmd.ready := True
  ibus.rsp.valid := True
  ibus.rsp.rdata := mem(ibus.cmd.address.resized)

  def init(memHexPath: String): this.type = {
    HexTools.initRam(mem, memHexPath, start)
    this
  }
}

case class MmioSegment(start: Int, device: MmioDevice) extends MemorySegment {
  val length = device.size
  val dbus = device.dbus
}

class MemoryMapper(segments: Seq[MemorySegment])(implicit config: Config) extends Component {
  val dbus = master(new MemBus(config.dbusConfig))
  dbus.cmd.ready := False
  dbus.rsp.valid := False
  dbus.rsp.rdata.assignDontCare()
  val ibus = master(new MemBus(config.ibusConfig))
  ibus.cmd.ready := False
  ibus.rsp.valid := False
  ibus.rsp.rdata.assignDontCare()

  val slaves = segments.map {segment =>
    def createSlaveBus(segmentBus: MemBus) = {
      val bus = slave(new MemBus(segmentBus.config))
      bus.cmd.valid := False
      bus.rsp.ready := False

      bus.cmd.address.assignDontCare()
      if (bus.config.readWrite) {
        bus.cmd.write := False
        bus.cmd.wdata.assignDontCare()
        bus.cmd.wmask.assignDontCare()
      }

      parent.rework {
        segmentBus <> bus
      }

      bus
    }

    val dslave = createSlaveBus(segment.dbus).setName("dslave")

    val islave = if (segment.ibus == null) {
      null
    } else {
      createSlaveBus(segment.ibus).setName("islave")
    }

    (dslave, islave)
  }

  for ((segment, (dslave, islave)) <- segments.zip(slaves)) {
    def connectSlave(master: MemBus, slave: MemBus): Unit = {
      // Verilator errs when checking if a signal is >= 0 because this
      // comparison is always true.
      val lowerBoundCheck = if (segment.start == 0) {
        True
      } else {
        master.byteAddress >= segment.start
      }

      when (lowerBoundCheck && master.byteAddress < segment.end) {
        master <> slave
        slave.cmd.address.allowOverride
        slave.cmd.address := master.cmd.address - master.byte2WordAddress(segment.start)
      }
    }

    connectSlave(dbus, dslave)

    if (islave != null) {
      connectSlave(ibus, islave)
    }
  }
}
