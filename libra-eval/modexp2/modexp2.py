def verify_correctness(benchmark, f, vcd):
  # CHECK: First call
  m = vcd.get_mark(101)
  assert len(m.WB) == 1, "Multiple executions, only one expected"
  t = m.WB[0]
  assert(vcd.a0(t) == 3), vcd.a0(t)

  # CHECK: First call
  m = vcd.get_mark(102)
  assert len(m.WB) == 1, "Multiple executions, only one expected"
  t = m.WB[0]
  assert(vcd.a0(t) == 6), vcd.a0(t)

  # CHECK: First call
  m = vcd.get_mark(103)
  assert len(m.WB) == 1, "Multiple executions, only one expected"
  t = m.WB[0]
  assert(vcd.a0(t) == 1), vcd.a0(t)

  # CHECK: First call
  m = vcd.get_mark(104)
  assert len(m.WB) == 1, "Multiple executions, only one expected"
  t = m.WB[0]
  assert(vcd.a0(t) == 4), vcd.a0(t)
