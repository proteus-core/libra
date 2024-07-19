	.text
	.attribute	4, 16
	.attribute	5, "rv32im"
	.file	"sharevalue.c"
	.globl	share_value
	.p2align	2
	.type	share_value,@function
share_value:
	addi	sp, sp, -32
	sw	ra, 28(sp)
	sw	s0, 24(sp)
	sw	s1, 20(sp)
	sw	s2, 16(sp)
	sw	s3, 12(sp)
	sw	s4, 8(sp)
	blez	a2, .LBB0_5
	mv	s0, a2
	mv	s1, a1
	mv	s2, a0
	li	s3, 0
	li	s4, 42
	j	.LBB0_3
.LBB0_2:
	#APP
	mark	2
	#NO_APP
	addi	s0, s0, -1
	addi	s1, s1, 4
	addi	s2, s2, 4
	beqz	s0, .LBB0_6
.LBB0_3:
	lw	a0, 0(s2)
	#APP
	mark	1
	#NO_APP
	bne	a0, s4, .LBB0_2
	li	a0, 42
	call	lookup_val
	lw	a1, 0(s1)
	mul	a0, a1, a0
	add	s3, a0, s3
	j	.LBB0_2
.LBB0_5:
	li	s3, 0
.LBB0_6:
	mv	a0, s3
	lw	ra, 28(sp)
	lw	s0, 24(sp)
	lw	s1, 20(sp)
	lw	s2, 16(sp)
	lw	s3, 12(sp)
	lw	s4, 8(sp)
	addi	sp, sp, 32
	ret
.Lfunc_end0:
	.size	share_value, .Lfunc_end0-share_value

	.ident	"clang version 15.0.0 (git@gitlab:anon/llvm-project.git 269541593bc86ec4465969ec9950fc884c808ccf)"
	.section	".note.GNU-stack","",@progbits
	.addrsig
