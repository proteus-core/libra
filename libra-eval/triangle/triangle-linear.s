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
	# Eliminate "blt	a2, a1, .LBB0_2" (Molnar's method)
  slt a1, a2, a1
  andi a1, a1, 0xff
  neg a1, a1     # true mask
  not a2, a1     # false mask

	andi	a1, a1, 7
	li	  a0, 3
  and   a0, a0, a2
  or    a0, a0, a1
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
