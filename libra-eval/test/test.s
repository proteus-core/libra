  .attribute unaligned_access, 0
  .attribute stack_align, 16
  .text
  .align  2
  .globl  test
  .type test, @function
test:
  lo.beq a0,a1,0x14
  add t0, a0, a1
  add t1, a0, a1
  sub t0, a0, a1
  sub t1, a0, a1
  add t0, a0, a1
  add t1, a0, a1
  lo.beq a2,a3, 0x34
  lo.beq a2,a3, 0x3e
  add t0, a0, a1
  add t1, a0, a1
  add t2, a0, a1
  add t3, a0, a1
  sub t0, a0, a1
  sub t1, a0, a1
  sub t2, a0, a1
  sub t3, a0, a1
  lo.beq a0,a0,0x00
  lo.beq a0,a0,0x00
  lo.beq a0,a0,0x00
  lo.beq a0,a0,0x00

  ret

  .size test, .-test
