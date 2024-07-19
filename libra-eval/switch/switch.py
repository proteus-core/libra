def verify_correctness(benchmark, f, vcd):
  m = vcd.get_mark(101)
  assert len(m.WB) == 1, "Multiple executions, only one expected"
  t = m.WB[0]
  assert(vcd.a0(t) == 1), vcd.a0(t)

  m = vcd.get_mark(102)
  assert len(m.WB) == 1, "Multiple executions, only one expected"
  t = m.WB[0]
  assert(vcd.a0(t) == 2), vcd.a0(t)
  
  m = vcd.get_mark(103)
  assert len(m.WB) == 1, "Multiple executions, only one expected"
  t = m.WB[0]
  assert(vcd.a0(t) == 3), vcd.a0(t)

  m = vcd.get_mark(104)
  assert len(m.WB) == 1, "Multiple executions, only one expected"
  t = m.WB[0]
  assert(vcd.a0(t) == 4), vcd.a0(t)

  m = vcd.get_mark(105)
  assert len(m.WB) == 1, "Multiple executions, only one expected"
  t = m.WB[0]
  assert(vcd.a0(t) == 5), vcd.a0(t)

  m = vcd.get_mark(106)
  assert len(m.WB) == 1, "Multiple executions, only one expected"
  t = m.WB[0]
  assert(vcd.a0(t) == 6), vcd.a0(t)

  m = vcd.get_mark(107)
  assert len(m.WB) == 1, "Multiple executions, only one expected"
  t = m.WB[0]
  assert(vcd.a0(t) == 7), vcd.a0(t)

  m = vcd.get_mark(108)
  assert len(m.WB) == 1, "Multiple executions, only one expected"
  t = m.WB[0]
  assert(vcd.a0(t) == 8), vcd.a0(t)

  m = vcd.get_mark(109)
  assert len(m.WB) == 1, "Multiple executions, only one expected"
  t = m.WB[0]
  assert(vcd.a0(t) == 9), vcd.a0(t)

  m = vcd.get_mark(110)
  assert len(m.WB) == 1, "Multiple executions, only one expected"
  t = m.WB[0]
  assert(vcd.a0(t) == 10), vcd.a0(t)

  m = vcd.get_mark(111)
  assert len(m.WB) == 1, "Multiple executions, only one expected"
  t = m.WB[0]
  assert(vcd.a0(t) == 11), vcd.a0(t)

  m = vcd.get_mark(112)
  assert len(m.WB) == 1, "Multiple executions, only one expected"
  t = m.WB[0]
  assert(vcd.a0(t) == 12), vcd.a0(t)

  m = vcd.get_mark(113)
  assert len(m.WB) == 1, "Multiple executions, only one expected"
  t = m.WB[0]
  assert(vcd.a0(t) == 13), vcd.a0(t)

  m = vcd.get_mark(114)
  assert len(m.WB) == 1, "Multiple executions, only one expected"
  t = m.WB[0]
  assert(vcd.a0(t) == 14), vcd.a0(t)

  m = vcd.get_mark(115)
  assert len(m.WB) == 1, "Multiple executions, only one expected"
  t = m.WB[0]
  assert(vcd.a0(t) == 15), vcd.a0(t)

  m = vcd.get_mark(116)
  assert len(m.WB) == 1, "Multiple executions, only one expected"
  t = m.WB[0]
  assert(vcd.a0(t) == 16), vcd.a0(t)

  m = vcd.get_mark(117)
  assert len(m.WB) == 1, "Multiple executions, only one expected"
  t = m.WB[0]
#assert(vcd.a0(t) == 0xffffffff), vcd.a0(t)
