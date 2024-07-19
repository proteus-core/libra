def verify_correctness(benchmark, f, vcd):
  m = vcd.get_mark(101)
  assert len(m.WB) == 1, "Multiple executions, only one expected"
  t = m.WB[0]
  assert(vcd.a0(t) == 4), vcd.a0(t)

  m = vcd.get_mark(101)
  assert len(m.WB) == 1, "Multiple executions, only one expected"
  t = m.WB[0]
  assert(vcd.a0(t) == 4), vcd.a0(t)

  m = vcd.get_mark(102)
  assert len(m.WB) == 1, "Multiple executions, only one expected"
  t = m.WB[0]
  assert(vcd.a0(t) == 3), vcd.a0(t)

  m = vcd.get_mark(103)
  assert len(m.WB) == 1, "Multiple executions, only one expected"
  t = m.WB[0]
  assert(vcd.a0(t) == 3), vcd.a0(t)

  m = vcd.get_mark(104)
  assert len(m.WB) == 1, "Multiple executions, only one expected"
  t = m.WB[0]
  assert(vcd.a0(t) == 3), vcd.a0(t)

  m = vcd.get_mark(105)
  assert len(m.WB) == 1, "Multiple executions, only one expected"
  t = m.WB[0]
  assert(vcd.a0(t) == 2), vcd.a0(t)

  m = vcd.get_mark(106)
  assert len(m.WB) == 1, "Multiple executions, only one expected"
  t = m.WB[0]
  assert(vcd.a0(t) == 2), vcd.a0(t)

  m = vcd.get_mark(107)
  assert len(m.WB) == 1, "Multiple executions, only one expected"
  t = m.WB[0]
  assert(vcd.a0(t) == 1), vcd.a0(t)

  m = vcd.get_mark(108)
  assert len(m.WB) == 1, "Multiple executions, only one expected"
  t = m.WB[0]
  assert(vcd.a0(t) == 1), vcd.a0(t)
  
  m = vcd.get_mark(109)
  assert len(m.WB) == 1, "Multiple executions, only one expected"
  t = m.WB[0]
  assert(vcd.a0(t) == 0), vcd.a0(t)

  m = vcd.get_mark(110)
  assert len(m.WB) == 1, "Multiple executions, only one expected"
  t = m.WB[0]
  assert(vcd.a0(t) == 0), vcd.a0(t)
