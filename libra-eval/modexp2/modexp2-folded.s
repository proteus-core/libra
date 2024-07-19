	.text
	.attribute	4, 16
	.attribute	5, "rv32im"
	.file	"modexp2.c"
	.globl	modexp2
	.p2align	2
	.type	modexp2,@function
modexp2:
	li	a2, 1
	li	a3, 32
	lui	a4, 524288
	addi	a4, a4, 1
	lui	a5, 599186
	addi	a5, a5, 1171
	lui	a6, 149797
	addi	a7, a6, -1755
	li	a6, 1
	j	.LBB0_2
.LBB0_1:
	#APP
	mark	2
	#NO_APP
	mul	a0, a0, a0
	mulhu	t0, a0, a7
	sub	t1, a0, t0
	srli	t1, t1, 1
	add	t0, t1, t0
	srli	t0, t0, 2
	slli	t1, t0, 3
	sub	t0, t0, t1
	add	a0, a0, t0
	addi	a3, a3, -1
	srai	a1, a1, 1
	beqz	a3, .LBB0_4
.LBB0_2:
	and	t2, a1, a4
	#APP
	mark	1
	#NO_APP
  # Hoist the writes that are not live after the sensitive region
	mul	t3, a6, a0
	mulh	t0, t3, a5
	add	t0, t0, t3
	srli	t1, t0, 31
	srai	t0, t0, 2
	add	t0, t0, t1
	slli	t1, t0, 3
	sub	t0, t0, t1
  # Start of balanced region
	#lo.bne	t2, a2, 0x022 # 0:1:2
	tlo.bne	t2, a2, 0x092 # 0:1:2:1
	add	a6, t3, t0
	addi	a6, a6, 0
  #lo.beq a0,a0,0x000
  #lo.beq a0,a0,0x000
	j	.LBB0_1
.LBB0_4:
	lui	a0, 599186
	addi	a0, a0, 1171
	mulh	a0, a6, a0
	add	a0, a0, a6
	srli	a1, a0, 31
	srai	a0, a0, 2
	add	a0, a0, a1
	slli	a1, a0, 3
	sub	a0, a0, a1
	add	a0, a6, a0
	ret
.Lfunc_end0:
	.size	modexp2, .Lfunc_end0-modexp2

	.ident	"clang version 15.0.0 (git@gitlab:anon/llvm-project.git a3b1800863ff654d43bcfc8fc905822f341d9f92)"
	.section	".note.GNU-stack","",@progbits
	.addrsig
