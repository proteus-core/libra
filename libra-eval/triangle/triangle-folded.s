	.text
	.attribute	4, 16
	.attribute	5, "rv32im"
	.file	"triangle.c"
	.globl	triangle
	.p2align	2
	.type	triangle,@function
triangle:
	mv	a2, a0
	#APP
	mark	1
	#NO_APP
	#lo.blt	a2, a1, 0x022
	tlo.blt	a2, a1, 0x092
	li	a0, 3
	li	a0, 7
  #lo.beq a0,a0,0x000
  #lo.beq a0,a0,0x000
	#APP
	mark	2
	#NO_APP
	ret
.Lfunc_end0:
	.size	triangle, .Lfunc_end0-triangle

	.ident	"clang version 15.0.0 (git@gitlab:anon/llvm-project.git a3b1800863ff654d43bcfc8fc905822f341d9f92)"
	.section	".note.GNU-stack","",@progbits
	.addrsig
