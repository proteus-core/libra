def verify_correctness(benchmark, f, vcd):
  # CHECK: First call
  m = vcd.get_mark(101)
  assert len(m.WB) == 1, "Multiple executions, only one expected"
  t = m.WB[0]
  assert(vcd.a0(t) == 56423), vcd.a0(t)

  # CHECK: Second call
  m = vcd.get_mark(102)
  assert len(m.WB) == 1, "Multiple executions, only one expected"
  t = m.WB[0]
  assert(vcd.a0(t) == 57631), vcd.a0(t)

  # CHECK: Third call
  m = vcd.get_mark(103)
  assert len(m.WB) == 1, "Multiple executions, only one expected"
  t = m.WB[0]
  assert(vcd.a0(t) == 56), vcd.a0(t)
  
  # CHECK: Fourth call
  m = vcd.get_mark(104)
  assert len(m.WB) == 1, "Multiple executions, only one expected"
  t = m.WB[0]
  assert(vcd.a0(t) == 28679), vcd.a0(t)

  # CHECK: Fifth call
  m = vcd.get_mark(105)
  assert len(m.WB) == 1, "Multiple executions, only one expected"
  t = m.WB[0]
  assert(vcd.a0(t) == 28679), vcd.a0(t)
