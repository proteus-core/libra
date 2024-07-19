	.text
	.attribute	4, 16
	.attribute	5, "rv32im"
	.file	"fork.c"
	.globl	fork
	.p2align	2
	.type	fork,@function
fork:
	#APP
	mark	1
	#NO_APP
	blt	a0, a1, .LBB0_2
	li	a0, 3
	#APP
	mark	2
	#NO_APP
	ret
.LBB0_2:
	addi	a0, a0, 2
	#APP
	mark	2
	#NO_APP
	ret
.Lfunc_end0:
	.size	fork, .Lfunc_end0-fork

	.ident	"clang version 15.0.0 (git@gitlab:anon/llvm-project.git 30c16046da33e1c74f4fcfd533c854f05403cb83)"
	.section	".note.GNU-stack","",@progbits
	.addrsig
