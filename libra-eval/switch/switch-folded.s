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
  #lo.bne t0, a1, 0x022 # 0:1:2
	tlo.bne	t0, a1, 0x092
	li	a0, 1
  addi a0, a0, 0
  #lo.beq a0,a0,0x000
  #lo.beq a0,a0,0x000

  li a1, 2
  #lo.bne t0, a1, 0x022 # 0:1:2
	tlo.bne	t0, a1, 0x092
	li	a0, 2
  addi a0, a0, 0
  #lo.beq a0,a0,0x000
  #lo.beq a0,a0,0x000

  li a1, 3
  #lo.bne t0, a1, 0x022 # 0:1:2
	tlo.bne	t0, a1, 0x092
	li	a0, 3
  addi a0, a0, 0
  #lo.beq a0,a0,0x000
  #lo.beq a0,a0,0x000

  li a1, 4
  #lo.bne t0, a1, 0x022 # 0:1:2
	tlo.bne	t0, a1, 0x092
	li	a0, 4
  addi a0, a0, 0
  #lo.beq a0,a0,0x000
  #lo.beq a0,a0,0x000

  li a1, 5
  #lo.bne t0, a1, 0x022 # 0:1:2
	tlo.bne	t0, a1, 0x092
	li	a0, 5
  addi a0, a0, 0
  #lo.beq a0,a0,0x000
  #lo.beq a0,a0,0x000

  li a1, 6
  #lo.bne t0, a1, 0x022 # 0:1:2
	tlo.bne	t0, a1, 0x092
	li	a0, 6
  addi a0, a0, 0
  #lo.beq a0,a0,0x000
  #lo.beq a0,a0,0x000

  li a1, 7
  #lo.bne t0, a1, 0x022 # 0:1:2
	tlo.bne	t0, a1, 0x092
	li	a0, 7
  addi a0, a0, 0
  #lo.beq a0,a0,0x000
  #lo.beq a0,a0,0x000

  li a1, 8
  #lo.bne t0, a1, 0x022 # 0:1:2
	tlo.bne	t0, a1, 0x092
	li	a0, 8
  addi a0, a0, 0
  #lo.beq a0,a0,0x000
  #lo.beq a0,a0,0x000

  li a1, 9
  #lo.bne t0, a1, 0x022 # 0:1:2
	tlo.bne	t0, a1, 0x092
	li	a0, 9
  addi a0, a0, 0
  #lo.beq a0,a0,0x000
  #lo.beq a0,a0,0x000

  li a1, 10
  #lo.bne t0, a1, 0x022 # 0:1:2
	tlo.bne	t0, a1, 0x092
	li	a0, 10
  addi a0, a0, 0
  #lo.beq a0,a0,0x000
  #lo.beq a0,a0,0x000

  li a1, 11
  #lo.bne t0, a1, 0x022 # 0:1:2
	tlo.bne	t0, a1, 0x092
	li	a0, 11
  addi a0, a0, 0
  #lo.beq a0,a0,0x000
  #lo.beq a0,a0,0x000

  li a1, 12
  #lo.bne t0, a1, 0x022 # 0:1:2
	tlo.bne	t0, a1, 0x092
	li	a0, 12
  addi a0, a0, 0
  #lo.beq a0,a0,0x000
  #lo.beq a0,a0,0x000

  li a1, 13
  #lo.bne t0, a1, 0x022 # 0:1:2
	tlo.bne	t0, a1, 0x092
	li	a0, 13
  addi a0, a0, 0
  #lo.beq a0,a0,0x000
  #lo.beq a0,a0,0x000

  li a1, 14
  #lo.bne t0, a1, 0x022 # 0:1:2
	tlo.bne	t0, a1, 0x092
	li	a0, 14
  addi a0, a0, 0
  #lo.beq a0,a0,0x000
  #lo.beq a0,a0,0x000

  li a1, 15
  #lo.bne t0, a1, 0x022 # 0:1:2
	tlo.bne	t0, a1, 0x092
	li	a0, 15
  addi a0, a0, 0
  #lo.beq a0,a0,0x000
  #lo.beq a0,a0,0x000

  li a1, 16
  #lo.bne t0, a1, 0x022 # 0:1:2
	tlo.bne	t0, a1, 0x092
	li	a0, 16
  addi a0, a0, 0
  #lo.beq a0,a0,0x000
  #lo.beq a0,a0,0x000

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
