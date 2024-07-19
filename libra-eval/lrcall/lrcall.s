  .attribute unaligned_access, 0
  .attribute stack_align, 16
  .text
  .align  2
  .globl  func
  .type func, @function
func:
   lo.beq a0,a1,0x24
   lo.beq a0,a1,0x2a
   add t0, a0, a1
   add t1, a0, a1
   add t2, a0, a1
   lo.beq a0,a0,0x00
   lo.beq a0,a0,0x00
   lo.beq a0,a0,0x00
   ret
  .size func, .-func

  .globl  lrcall
  .type lrcall, @function
lrcall:
  addi sp, sp, -16
  sw ra, 12(sp)
  lo.beq a0,a1,0x14
  l.jal ra, func
  r.jal ra, func
  lo.beq a0,a0,0x00
  lo.beq a0,a0,0x00
  lw ra, 12(sp)
  addi sp, sp, 16
  ret
  .size lrcall, .-lrcall
