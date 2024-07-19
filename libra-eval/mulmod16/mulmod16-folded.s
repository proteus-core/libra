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

  # Hoist temporaries
	mul	t0, a1, a0
	and	t1, t0, a2
	srli	t0, t0, 16
	sltu	t6, t1, t0

	lo.beqz	a0, 0x022 # 0:1:2
	#lo.beqz	a1, 0x024 # 0:1:3
  #lo.beqz x0, 0x044 # 2:2:3
	tlo.beqz	a1, 0x0a6 # 0:1:3:3
  tlo.beqz x0, 0x926 # 2:2:3:3
	sub	a3, t1, t0
	sub	a0, a2, a0
	sub	a0, a2, a1
	add	a0, a3, t6
	addi	a0, a0, 2
	addi	a0, a0, 2
	and	a0, a0, a2
	and	a0, a0, a2
	and	a0, a0, a2
  #lo.beq a0,a0,0x000
  #lo.beq a0,a0,0x000
  #lo.beq a0,a0,0x000

	#APP
	mark	2
	#NO_APP
	ret
.Lfunc_end0:
	.size	mulmod16, .Lfunc_end0-mulmod16

	.ident	"clang version 15.0.0 (git@gitlab:anon/llvm-project.git a3b1800863ff654d43bcfc8fc905822f341d9f92)"
	.section	".note.GNU-stack","",@progbits
	.addrsig
