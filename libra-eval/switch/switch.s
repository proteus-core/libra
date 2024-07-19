	.text
	.attribute	4, 16
	.attribute	5, "rv32im"
	.file	"switch.c"
	.globl	switch_case                     # -- Begin function switch_case
	.p2align	2
	.type	switch_case,@function
switch_case:                            # @switch_case
# %bb.0:
	addi	sp, sp, -16
	sw	ra, 12(sp)                      # 4-byte Folded Spill
	sw	s0, 8(sp)                       # 4-byte Folded Spill
	addi	s0, sp, 16
	li	a2, 8
	mv	a1, a0
	#APP
	mark	1
	#NO_APP
	blt	a2, a0, .LBB0_5
# %bb.1:
	li	a0, 4
	blt	a0, a1, .LBB0_9
# %bb.2:
	li	a0, 2
	blt	a0, a1, .LBB0_15
# %bb.3:
	li	a0, 1
	beq	a1, a0, .LBB0_23
# %bb.4:
	li	a0, 2
	j	.LBB0_23
.LBB0_5:
	li	a0, 12
	blt	a0, a1, .LBB0_12
# %bb.6:
	li	a0, 10
	blt	a0, a1, .LBB0_17
# %bb.7:
	li	a0, 9
	beq	a1, a0, .LBB0_23
# %bb.8:
	li	a0, 10
	j	.LBB0_23
.LBB0_9:
	li	a0, 6
	blt	a0, a1, .LBB0_19
# %bb.10:
	li	a0, 5
	beq	a1, a0, .LBB0_23
# %bb.11:
	li	a0, 6
	j	.LBB0_23
.LBB0_12:
	li	a0, 14
	blt	a0, a1, .LBB0_21
# %bb.13:
	li	a0, 13
	beq	a1, a0, .LBB0_23
# %bb.14:
	li	a0, 14
	j	.LBB0_23
.LBB0_15:
	li	a0, 3
	beq	a1, a0, .LBB0_23
# %bb.16:
	li	a0, 4
	j	.LBB0_23
.LBB0_17:
	li	a0, 11
	beq	a1, a0, .LBB0_23
# %bb.18:
	li	a0, 12
	j	.LBB0_23
.LBB0_19:
	li	a0, 7
	beq	a1, a0, .LBB0_23
# %bb.20:
	li	a0, 8
	j	.LBB0_23
.LBB0_21:
	li	a0, 15
	beq	a1, a0, .LBB0_23
# %bb.22:
	li	a0, 16
.LBB0_23:
	#APP
	mark	2
	#NO_APP
	lw	ra, 12(sp)                      # 4-byte Folded Reload
	lw	s0, 8(sp)                       # 4-byte Folded Reload
	addi	sp, sp, 16
	ret
.Lfunc_end0:
	.size	switch_case, .Lfunc_end0-switch_case
                                        # -- End function
	.ident	"clang version 15.0.0 (git@gitlab:anon/llvm-project.git a3b1800863ff654d43bcfc8fc905822f341d9f92)"
	.section	".note.GNU-stack","",@progbits
