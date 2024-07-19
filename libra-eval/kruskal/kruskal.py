def verify_correctness(benchmark, f, vcd):
  # Read memory dump
  f = open("%s.mem" % benchmark, "rb")
  memory = f.read()
  f.close()

  # Get addresses of mst1 and mst2 arrays
  m = vcd.get_mark(100)
  assert len(m.WB) == 2, "Two calls expected: %s" % len(m.WB)
  t1 = m.WB[0]
  t2 = m.WB[1]
  mst1 = vcd.a1(t1) & 0x0FFFFFFF
  mst2 = vcd.a1(t2) & 0x0FFFFFFF

  # CHECK: First call
  m = vcd.get_mark(101)
  assert len(m.WB) == 1, "Multiple executions, only one expected"
  t = m.WB[0]
  # CHECK: mst1 = {4, 1, 2, 2, 3, 4, 3, 3, 5}
  assert vcd.a0(t) == 4, vcd.a0(t)
  assert memory[mst1+ 0] == 4, memory[mst1+ 0]
  assert memory[mst1+ 4] == 1, memory[mst1+ 4]
  assert memory[mst1+ 8] == 2, memory[mst1+ 8]
  assert memory[mst1+12] == 2, memory[mst1+12]
  assert memory[mst1+16] == 3, memory[mst1+16]
  assert memory[mst1+20] == 4, memory[mst1+20]
  assert memory[mst1+24] == 3, memory[mst1+24]
  assert memory[mst1+28] == 3, memory[mst1+28]
  assert memory[mst1+32] == 5, memory[mst1+32]

  # CHECK: Second call
  m = vcd.get_mark(102)
  assert len(m.WB) == 1, "Multiple executions, only one expected"
  t = m.WB[0]
  assert(vcd.a0(t) == 6), vcd.a0(t)
  # CHECK: mst2 = {6, 1, 2, 4, 3, 3, 5, 7, 5, 5, 2, 6, 2}
  assert memory[mst2+ 0] == 6, memory[mst2+ 0]
  assert memory[mst2+ 4] == 1, memory[mst2+ 4]
  assert memory[mst2+ 8] == 2, memory[mst2+ 8]
  assert memory[mst2+12] == 4, memory[mst2+12]
  assert memory[mst2+16] == 3, memory[mst2+16]
  assert memory[mst2+20] == 3, memory[mst2+20]
  assert memory[mst2+24] == 5, memory[mst2+24]
  assert memory[mst2+28] == 7, memory[mst2+28]
  assert memory[mst2+32] == 5, memory[mst2+32]
  assert memory[mst2+36] == 5, memory[mst2+36]
  assert memory[mst2+44] == 6, memory[mst2+44]
  assert memory[mst2+48] == 2, memory[mst2+48]
  assert memory[mst2+40] == 2, memory[mst2+40]
