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
  lo.beq a0, a1, 0x022 # 0:1:2
  #lo.blt a0, a1, 0x024 # 0:1:3
  #lo.beq a0, a1, 0x444 # 2:2:3
  tlo.blt a0, a1, 0x0a4 # 0:1:3:2
  tlo.beq a0, a1, 0x924 # 2:2:3:2
  li a4,28
  li a4,12
  li a4,0
  li a0,7
  li a0,3
  li a0,0
  #lo.beq a0,a0,0x000
  #lo.beq a0,a0,0x000
  #lo.beq a0,a0,0x000
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
	.size	diamond, .-diamond
	.ident	"GCC: (GNU) 11.1.0"
