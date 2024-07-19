	.text
	.attribute	4, 16
	.attribute	5, "rv32im"
	.file	"bsl.c"
	.globl	BSL430_unlock_BSL
	.p2align	2
	.type	BSL430_unlock_BSL,@function
BSL430_unlock_BSL:
	li	a1, 0
	li	a2, 0
	lui	a3, %hi(.L.str)
	addi	a3, a3, %lo(.L.str)
	li	a4, 17
.LBB0_1:
	add	a5, a2, a3
	lbu	a5, 0(a5)
	add	a6, a0, a2
	lbu	a6, 0(a6)
	#APP
	mark	1
	#NO_APP
	#lo.beq	a5, a6, 0x022 # 0:1:2
	tlo.beq	a5, a6, 0x092
	ori	a1, a1, 64
	ori	a1, a1, 0
  #lo.beq a0,a0,0x000
  #lo.beq a0,a0,0x000
	#APP
	mark	2
	#NO_APP
	addi	a2, a2, 1
	bne	a2, a4, .LBB0_1
	li	a0, 0
	beqz	a1, .LBB0_6
	li	a0, 5
.LBB0_6:
	ret
.Lfunc_end0:
	.size	BSL430_unlock_BSL, .Lfunc_end0-BSL430_unlock_BSL

	.type	.L.str,@object
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.asciz	"0123456789ABCDEF"
	.size	.L.str, 17

	.ident	"clang version 15.0.0 (git@gitlab:anon/llvm-project.git a3b1800863ff654d43bcfc8fc905822f341d9f92)"
	.section	".note.GNU-stack","",@progbits
	.addrsig
