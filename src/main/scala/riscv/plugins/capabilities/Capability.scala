package riscv.plugins.capabilities

import spinal.core._

case class Permissions() extends Bundle {
  val execute = Bool()
  val load = Bool()
  val store = Bool()
  val loadCapability = Bool()
  val storeCapability = Bool()
  val accessSystemRegisters = Bool()

  def allowAll() = setAll(True)
  def allowNone() = setAll(False)

  private def setAll(value: Bool) = {
    for ((_, element) <- elements) {
      element := value
    }
  }

  def asIsaBits: Bits = {
    B"0" ## accessSystemRegisters ## B"0000" ## storeCapability ##
      loadCapability ## store ## load ## execute ## B"0" resized
  }

  def assignFromIsaBits(bits: Bits): Unit = {
    execute := bits(1)
    load := bits(2)
    store := bits(3)
    loadCapability := bits(4)
    storeCapability := bits(5)
    accessSystemRegisters := bits(10)
  }
}

class BaseCapability(implicit context: Context) extends Bundle {
  val tag = Bool

  private val xlen = context.config.xlen
  val base = UInt(xlen bits)
  val length = UInt(xlen bits)

  val perms = Permissions()

  def top = base + length

  def :=(other: Capability): Unit = {
    assignAllByName(other)
  }
}

case class NonPointerCapability(implicit context: Context) extends BaseCapability

case class Capability(implicit context: Context) extends BaseCapability {
  val offset = UInt(context.config.xlen bits)

  def address = base + offset

  def assignFrom(base: BaseCapability, offset: UInt) = {
    assignSomeByName(base)
    this.offset := offset
  }
}

object Capability {
  def Null(implicit context: Context): Capability = {
    val cap = Capability()
    cap.tag := False
    cap.base := 0
    cap.offset := 0
    cap.length := 0
    cap.perms.allowNone()
    cap
  }

  def Root(implicit context: Context): Capability = {
    val cap = Capability()
    cap.tag := True
    cap.base := 0
    cap.offset := 0
    cap.length := U"32'hffffffff"
    cap.perms.allowAll()
    cap
  }
}
