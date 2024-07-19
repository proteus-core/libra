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
	blt	a2, a1, .LBB0_A
	li	a0, 3
  j .LBB0_2
.LBB0_A:
	li	a0, 7
  j .LBB0_2
.LBB0_2:
	#APP
	mark	2
	#NO_APP
	ret
.Lfunc_end0:
	.size	triangle, .Lfunc_end0-triangle

	.ident	"clang version 15.0.0 (git@gitlab:anon/llvm-project.git a3b1800863ff654d43bcfc8fc905822f341d9f92)"
	.section	".note.GNU-stack","",@progbits
	.addrsig
