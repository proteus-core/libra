def verify_correctness(benchmark, f, vcd):
  # CHECK: First call returns 0
  m = vcd.get_mark(101)
  assert len(m.WB) == 1, "Multiple executions, only one expected"
  t = m.WB[0]
  assert(vcd.a0(t) == 0), vcd.a0(t)

  # CHECK: Second call returns 868
  m = vcd.get_mark(102)
  assert len(m.WB) == 1, "Multiple executions, only one expected"
  t = m.WB[0]
  assert(vcd.a0(t) == 868), vcd.a0(t)

  # CHECK: Third call returns 1078
  m = vcd.get_mark(103)
  assert len(m.WB) == 1, "Multiple executions, only one expected"
  t = m.WB[0]
  assert(vcd.a0(t) == 1078), vcd.a0(t)
