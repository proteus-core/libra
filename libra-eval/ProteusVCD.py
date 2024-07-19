from types import SimpleNamespace
import re
import vcdvcd
import os

CYCLE_TIME = 10

#############################################################################
class NoSuchMark(Exception):
  pass

#############################################################################
class NestedNamespace(SimpleNamespace):

  def __init__(self, dictionary, **kwargs):

    super().__init__(**kwargs)

    for key, value in dictionary.items():
      if isinstance(value, dict):
        self.__setattr__(key, NestedNamespace(value))
      else:
        self.__setattr__(key, value)

#############################################################################
class Mark:

  ###########################################################################
  def __init__(self, n, addr):
    self.n    = n
    self.addr = addr

    self.IF  = []
    self.ID  = []
    self.EX  = []
    self.MEM = []
    self.WB  = []

#############################################################################
class ProteusVCD:

  ###########################################################################
  def __init__(self, vcdname, signals=[]):
    # Build the signal namespace
    self.vcd = vcdvcd.VCDVCD(vcdname, only_sigs=True)
    self.TOP = self.build_signal_namespace()
    self.PL  = self.TOP.Core.pipeline
    self.ID  = self.TOP.Core.pipeline.decode
    self.RF  = self.TOP.Core.pipeline.RegisterFileAccessor
    self.CSR = self.TOP.Core.pipeline.CsrFile

    try:
      self.WB = self.TOP.Core.pipeline.writeback
      self.is_static = True
    except:
      self.WB = self.TOP.Core.pipeline.retirementStage
      self.is_static = False

    # Load the data for the signals we are interested in.
    # The empty list selects all signals.
    self.vcd = vcdvcd.VCDVCD(vcdname, signals)
    if len(signals) > 0:
      assert set(signals) == set(self.vcd.signals), "Missing signals"

    self.init_marks()

  ###########################################################################
  def build_signal_namespace(self):
    signal_dict = {}
    d = signal_dict
    for l in [x.split(".") for x in self.vcd.signals]:
      d = signal_dict
      for component in l[1:-1]:
        if not component in d:
          d[component] = {}
        d = d[component]
      n = re.sub(r'\[.*\]', '', l[-1])
      d[n] = '.'.join(l)
    return NestedNamespace(signal_dict)

  ###########################################################################
  def init_marks(self):

    self.marks = {}

    signal = self.PL.clk
    for t, v in [(t, int(v, 2)) for (t, v) in self.vcd[signal].tv]:
      if v == 1:
        is_done = self.as_int(self.PL.decode_arbitration_isDone, t) == 1
        is_mark = self.as_int(self.PL.decode_out_MARK, t) == 1
        if is_done and is_mark:
          n = self.as_int(self.PL.decode_out_IMM, t)
          addr = self.as_int(self.PL.fetch_out_PC, t)
          if not n in self.marks:
            self.marks[n] = Mark(n, [addr])
          # A mark can be duplicated by the compiler
          #    (see mulmod16.c / mulmod16.s for example)
          if not addr in self.marks[n].addr:
            self.marks[n].addr.append(addr)

    # IF
    # signal = self.signal(self.TOP.Core.pipeline.fetch_out_PC)
    # for t, pc in [(t, int(v, 2)) for (t, v) in signal.tv]:
    #   for (n, mark) in self.marks.items():
    #     if pc in mark.addr:
    #       mark.IF.append(t)

    # WB
    # TODO: Clean this up (unify WB and WB2)
    # TODO: unify this loop with the top one?
    if self.is_static:
      out_pc = self.TOP.Core.pipeline.writeback_out_PC
    else:
      out_pc = self.TOP.Core.pipeline.retirementStage_out_PC
    self.WB2 = {}

    signal = self.PL.clk
    for t, v in [(t, int(v, 2)) for (t, v) in self.vcd[signal].tv]:
      if v == 1:
        if self.as_int(self.WB.arbitration_isDone, t) == 1:
          pc = self.as_int(out_pc, t)
          if not pc in self.WB2:
            self.WB2[pc] = []
          self.WB2[pc].append(t)
          for (n, mark) in self.marks.items():
            if pc in mark.addr:
              mark.WB.append(t)

  ###########################################################################
  def total_cycles(self):
    return int(self.vcd[self.TOP.clk].tv[-1][0]) / CYCLE_TIME

  ###########################################################################
  def get_mark(self, n=0):
    if not (n in self.marks):
      raise NoSuchMark
    return self.marks[n]

  ###########################################################################
  def signal(self, name):
    return self.vcd[name]

  ###########################################################################
  def as_int(self, signal, time):
    return int(self.vcd[signal][time], 2)

  ###########################################################################
  def as_bytes(self, signal, time):
    ident = self.vcd.references_to_ids[signal]
    assert ident != None, "Invalid signal: '%s'" % signal
    size = int(self.vcd.data[ident].size)
    return int(self.vcd[signal][time], 2).to_bytes((size+7)//8, 'little')

  ###########################################################################
  """
  Returns time t, n clock cycles later
  """
  def nextt(self, t, n=1):
    return t + (n * CYCLE_TIME)

  #########################################################################
  def x5(self, t):
    return self.as_int(self.RF.x5_t0, t)

  #########################################################################
  def x6(self, t):
    return self.as_int(self.RF.x6_t1, t)

  #########################################################################
  def x7(self, t):
    return self.as_int(self.RF.x7_t2, t)

  #########################################################################
  def x10(self, t):
    return self.as_int(self.RF.x10_a0, t)

  #########################################################################
  def x11(self, t):
    return self.as_int(self.RF.x11_a1, t)

  #########################################################################
  def t0(self, t):
    return self.x5(t)

  #########################################################################
  def t1(self, t):
    return self.x6(t)

  #########################################################################
  def a0(self, t):
    return self.x10(t)

  #########################################################################
  def a1(self, t):
    return self.x11(t)
