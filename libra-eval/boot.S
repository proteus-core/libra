  .section .boot
  .globl _boot
_boot:
  .option push
  .option norelax
  .extern _end
  la sp,_end
  .option pop

  # stack size: 10KB
  li t0, 10240
  add sp, sp, t0
  # align sp to 8 bytes
  li t0, 0xfffffff8
  and sp, sp, t0

  jal main

_halt:
  li x1, 0x10000000  # CHARDEV_ADDR
  li x2, 4           # CHARDEV_EOT
  sb x2, 0(x1)

1: 
  j 1b
