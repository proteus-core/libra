	.text
	.attribute	4, 16
	.attribute	5, "rv32im"
	.file	"lookup.c"
	.globl	lookup_val
	.p2align	2
	.type	lookup_val,@function
lookup_val:
	li	a1, 10
	blt	a0, a1, .LBB0_2
	li	a0, 7
	ret
.LBB0_2:
	slli	a0, a0, 1
	addi	a0, a0, 2
	ret
.Lfunc_end0:
	.size	lookup_val, .Lfunc_end0-lookup_val

	.ident	"clang version 15.0.0 (git@gitlab:anon/llvm-project.git 269541593bc86ec4465969ec9950fc884c808ccf)"
	.section	".note.GNU-stack","",@progbits
	.addrsig
