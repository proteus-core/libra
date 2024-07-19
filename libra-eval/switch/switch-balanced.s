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

	mv	t0, a0

	#APP
	mark	1
	#NO_APP

  li a1, 1
  bne t0, a1, .LBB0_4
	li	a0, 1
  j .LBB0_4A
.LBB0_4:
  addi a0, a0, 0
  j .LBB0_4A
.LBB0_4A:

  li a1, 2
  bne t0, a1, .LBB0_5
	li	a0, 2
  j .LBB0_5A
.LBB0_5:
  addi a0, a0, 0
  j .LBB0_5A
.LBB0_5A:
  li a1, 3
  bne t0, a1, .LBB0_6
	li	a0, 3
  j .LBB0_6A
.LBB0_6:
  addi a0, a0, 0
  j .LBB0_6A
.LBB0_6A:
  li a1, 4
  bne t0, a1, .LBB0_7
	li	a0, 4
  j .LBB0_7A
.LBB0_7:
  addi a0, a0, 0
  j .LBB0_7A
.LBB0_7A:
  li a1, 5
  bne t0, a1, .LBB0_8
	li	a0, 5
  j .LBB0_8A
.LBB0_8:
  addi a0, a0, 0
  j .LBB0_8A
.LBB0_8A:
  li a1, 6
  bne t0, a1, .LBB0_9
	li	a0, 6
  j .LBB0_9A
.LBB0_9:
  addi a0, a0, 0
  j .LBB0_9A
.LBB0_9A:
  li a1, 7
  bne t0, a1, .LBB0_10
	li	a0, 7
  j .LBB0_10A
.LBB0_10:
  addi a0, a0, 0
  j .LBB0_10A
.LBB0_10A:
  li a1, 8
  bne t0, a1, .LBB0_11
	li	a0, 8
  j .LBB0_11A
.LBB0_11:
  addi a0, a0, 0
  j .LBB0_11A
.LBB0_11A:
  li a1, 9
  bne t0, a1, .LBB0_12
	li	a0, 9
  j .LBB0_12A
.LBB0_12:
  addi a0, a0, 0
  j .LBB0_12A
.LBB0_12A:
  li a1, 10
  bne t0, a1, .LBB0_13
	li	a0, 10
  j .LBB0_13A
.LBB0_13:
  addi a0, a0, 0
  j .LBB0_13A
.LBB0_13A:
  li a1, 11
  bne t0, a1, .LBB0_14
	li	a0, 11
  j .LBB0_14A
.LBB0_14:
  addi a0, a0, 0
  j .LBB0_14A
.LBB0_14A:
  li a1, 12
  bne t0, a1, .LBB0_15
	li	a0, 12
  j .LBB0_15A
.LBB0_15:
  addi a0, a0, 0
  j .LBB0_15A
.LBB0_15A:
  li a1, 13
  bne t0, a1, .LBB0_16
	li	a0, 13
  j .LBB0_16A
.LBB0_16:
  addi a0, a0, 0
  j .LBB0_16A
.LBB0_16A:
  li a1, 14
  bne t0, a1, .LBB0_17
	li	a0, 14
  j .LBB0_17A
.LBB0_17:
  addi a0, a0, 0
  j .LBB0_17A
.LBB0_17A:
  li a1, 15
  bne t0, a1, .LBB0_18
	li	a0, 15
  j .LBB0_18A
.LBB0_18:
  addi a0, a0, 0
  j .LBB0_18A
.LBB0_18A:
  li a1, 16
  bne t0, a1, .LBB0_19
	li	a0, 16
  j .LBB0_19A
.LBB0_19:
  addi a0, a0, 0
  j .LBB0_19A
.LBB0_19A:
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
