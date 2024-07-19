def verify_correctness(benchmark, f, vcd):
  # CHECK: First call
  m = vcd.get_mark(101)
  assert len(m.WB) == 1, "Multiple executions, only one expected"
  t = m.WB[0]
  assert(vcd.a0(t) == 7), vcd.a0(t)

  # CHECK: Second call
  m = vcd.get_mark(102)
  assert len(m.WB) == 1, "Multiple executions, only one expected"
  t = m.WB[0]
  assert(vcd.a0(t) == 3), vcd.a0(t)
