	.file	"diamond.c"
	.option nopic
	.attribute arch, "rv32im"
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
	beq	a0,a1,.L4
	blt	a0,a1,.L5
	li	a4,28
	li	a0,7
  j .L2
.L2:
 #APP
# 24 "diamond.c" 1
	mark 2
# 0 "" 2
 #NO_APP
	li	a5,10
	beq	a1,a5,.L7
	ret
.L7:
	mv	a0,a4
	ret
.L5:
	li	a4,12
	li	a0,3
	j	.L2
.L4:
  beq x0, x0, .LA
.LA:
	li	a4,0
	li	a0,0
	j	.L2
	.size	diamond, .-diamond
	.ident	"GCC: (GNU) 11.1.0"
