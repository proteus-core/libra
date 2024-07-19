	.text
	.attribute	4, 16
	.attribute	5, "rv32i2p1_m2p0"
	.file	"diamond.c"
	.globl	diamond                         # -- Begin function diamond
	.p2align	2
	.type	diamond,@function
diamond:                                # @diamond
# %bb.0:
	#APP
	mark	1
	#NO_APP
	xor	a2, a0, a1
	seqz	a2, a2
	li	a3, 3
	blt	a0, a1, .LBB0_2
# %bb.1:
	li	a3, 7
.LBB0_2:
	addi	a2, a2, -1
	and	a2, a2, a3
	addi	a1, a1, -10
	seqz	a0, a1
	slli	a0, a0, 1
	sll	a0, a2, a0
	#APP
	mark	2
	#NO_APP
	ret
.Lfunc_end0:
	.size	diamond, .Lfunc_end0-diamond
                                        # -- End function
	.ident	"clang version 18.0.0 (git@gitlab:anon/llvm-project.git 5be293738c57613ae9efde5e8a1878c37fb695d0)"
	.section	".note.GNU-stack","",@progbits
	.addrsig
