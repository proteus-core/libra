	.text
	.attribute	4, 16
	.attribute	5, "rv32im"
	.file	"lookup.c"
	.globl	lookup_val
	.p2align	2
	.type	lookup_val,@function
lookup_val:
	li	a1, 10
	#lo.blt	a0, a1, 0x022 # 0:1:2
	tlo.blt	a0, a1, 0x094 # 0:1:2:2
	li	a0, 7
	slli	a0, a0, 1
  addi a0, a0, 0
	addi	a0, a0, 2
  #lo.beq a0,a0,0x000
  #lo.beq a0,a0,0x000
	ret
.Lfunc_end0:
	.size	lookup_val, .Lfunc_end0-lookup_val

	.ident	"clang version 15.0.0 (git@gitlab:anon/llvm-project.git 027f723573d6d8eb34829cc71de6347a1ed4d502)"
	.section	".note.GNU-stack","",@progbits
	.addrsig
