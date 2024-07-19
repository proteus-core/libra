	.text
	.attribute	4, 16
	.attribute	5, "rv32im"
	.file	"kruskal.c"
	.globl	kruskal
	.p2align	2
	.type	kruskal,@function
kruskal:
	li	a4, 0
	#APP
	mark	100
	#NO_APP
	blez	a3, .LBB0_13
	li	a5, -1
	mv	a6, a1
	mv	a7, a2
.LBB0_2:
	sw	a5, 0(a6)
	sw	a4, 0(a7)
	addi	a4, a4, 1
	addi	a7, a7, 4
	addi	a6, a6, 4
	bne	a3, a4, .LBB0_2
	li	a4, 2
	blt	a3, a4, .LBB0_12
	li	a4, 0
	li	a5, 1
	j	.LBB0_6
.LBB0_5:
	addi	a5, a5, 2
	#APP
	mark	2
	#NO_APP
	bge	a5, a3, .LBB0_13
.LBB0_6:
	slli	a6, a5, 2
	add	t0, a0, a6
	lw	t1, 0(t0)
.LBB0_7:
	mv	a7, t1
	slli	a6, t1, 2
	add	a6, a2, a6
	lw	t1, 0(a6)
	bne	t1, a7, .LBB0_7
	lw	t1, 4(t0)
.LBB0_9:
	mv	t0, t1
	slli	t1, t1, 2
	add	t1, a2, t1
	lw	t1, 0(t1)
	bne	t1, t0, .LBB0_9
	#APP
	mark	1
	#NO_APP
	beq	a7, t0, .LBB0_5
	slli	t1, a4, 2
	add	t1, t1, a1
	sw	a7, 4(t1)
	addi	a4, a4, 2
	slli	a7, a4, 2
	add	a7, a1, a7
	sw	t0, 0(a7)
	sw	t0, 0(a6)
	j	.LBB0_5
.LBB0_12:
	li	a4, 0
.LBB0_13:
	srli	a0, a4, 31
	add	a0, a4, a0
	srai	a0, a0, 1
	sw	a0, 0(a1)
	ret
.Lfunc_end0:
	.size	kruskal, .Lfunc_end0-kruskal

	.ident	"clang version 15.0.0 (git@gitlab:anon/llvm-project.git 269541593bc86ec4465969ec9950fc884c808ccf)"
	.section	".note.GNU-stack","",@progbits
	.addrsig
