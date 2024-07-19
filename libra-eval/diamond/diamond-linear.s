	.file	"diamond.c"
	.option nopic
	.attribute	5, "rv32im"
	.attribute unaligned_access, 0
	.attribute stack_align, 16
	.text
	.align	2
	.globl	diamond
	.type	diamond, @function
diamond:
 #APP
# 8 "diamond.c" 1
	mark 1
# 0 "" 2
 #NO_APP

  # a0 == a1
	li	a6,0

  # a1 < a0
  slt t0, a1, a0
  andi t0, t0, 0xff
  neg  t0, t0        # true mask
  not  t1, t0        # false mask
  #li	a6,7
  and t2, a6, t1
  li	a6, 7
  and a6, a6, t0
  or  a6, a6, t2

  # a0 < a1
  slt t0, a0, a1
  andi t0, t0, 0xff
  neg  t0, t0        # true mask
  not  t1, t0        # false mask
  #li	a6,3
  and t2, a6, t1
  li	a6, 3
  and a6, a6, t0
  or  a6, a6, t2

 #APP
# 24 "diamond.c" 1
	mark 2
# 0 "" 2
 #NO_APP
	li	a5,10
	beq	a1,a5,.L7
	mv	a0,a6
	ret
.L7:
	sll a0,a6,2
	ret
.L5:
	.size	diamond, .-diamond
	.ident	"GCC: (GNU) 11.1.0"
