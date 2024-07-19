	.text
	.attribute	4, 16
	.attribute	5, "rv32im"
	.file	"mulmod16.c"
	.globl	mulmod16
	.p2align	2
	.type	mulmod16,@function
mulmod16:
	lui	a2, 16
	addi	a2, a2, -1
	and	a0, a0, a2
	and	a1, a1, a2
	#APP
	mark	1
	#NO_APP
	beqz	a0, .LBB0_3
	beqz	a1, .LBB0_4
	mul	a0, a1, a0
	and	a1, a0, a2
	srli	a0, a0, 16
	sub	a3, a1, a0
	sltu	a0, a1, a0
	add	a0, a3, a0
	and	a0, a0, a2
	#APP
	mark	2
	#NO_APP
	ret
.LBB0_3:
	sub	a0, a2, a1
	addi	a0, a0, 2
	and	a0, a0, a2
	#APP
	mark	2
	#NO_APP
	ret
.LBB0_4:
	sub	a0, a2, a0
	addi	a0, a0, 2
	and	a0, a0, a2
	#APP
	mark	2
	#NO_APP
	ret
.Lfunc_end0:
	.size	mulmod16, .Lfunc_end0-mulmod16

	.ident	"clang version 15.0.0 (git@gitlab:anon/llvm-project.git a3b1800863ff654d43bcfc8fc905822f341d9f92)"
	.section	".note.GNU-stack","",@progbits
	.addrsig
