	.text
	.attribute	4, 16
	.attribute	5, "rv32im"
	.file	"kruskal_s.c"
	.globl	kruskal
	.p2align	2
	.type	kruskal,@function
kruskal:
	li	a4, 0
	#APP
	mark	100
	#NO_APP
  blez a3, .LBB0_14
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
	blt	a3, a4, .LBB0_13
	li	a4, 0
	li	a5, 1
	j	.LBB0_7
.LBB0_6:
	#APP
	mark	2
	#NO_APP
	add	a6, a1, a6
	sw	a7, 0(a6)
	add	a6, a1, t0
	addi	a5, a5, 2
	sw	t1, 0(a6)
	bge	a5, a3, .LBB0_14
.LBB0_7:
	slli	a6, a5, 2
	add	a7, a0, a6
	lw	t0, 0(a7)
.LBB0_8:
	mv	a7, t0
	slli	t0, t0, 2
	add	t2, a2, t0
	lw	t0, 0(t2)
	bne	t0, a7, .LBB0_8
	addi	t0, a5, 1
	slli	t0, t0, 2
	add	t1, a0, t0
	lw	t3, 0(t1)
.LBB0_10:
	mv	t1, t3
	slli	t3, t3, 2
	add	t3, a2, t3
	lw	t3, 0(t3)
	bne	t3, t1, .LBB0_10
	#APP
	mark	1
	#NO_APP
	#lo.bne	a7, t1, 0x022 # 0:1:2
	tlo.bne	a7, t1, 0x098 # 0:1:2:4
  lw  t1, 0(t2)   #
  lw  x0, 0(t2)     # Dummy
	sw	t1, 0(t2)   # Dummy
	sw	t1, 0(t2)
	li	a7, -1
	addi	a4, a4, 1
	li	t1, -1
	addi	t1, t1, 0   # Dummy
  #lo.beq a0,a0,0x000
  #lo.beq a0,a0,0x000
	j	.LBB0_6
.LBB0_13:
	li	a4, 0
.LBB0_14:
	sw	a4, 0(a1)
	mv	a0, a4
	ret
.Lfunc_end0:
	.size	kruskal, .Lfunc_end0-kruskal

	.ident	"clang version 15.0.0 (git@gitlab:anon/llvm-project.git 269541593bc86ec4465969ec9950fc884c808ccf)"
	.section	".note.GNU-stack","",@progbits
	.addrsig
