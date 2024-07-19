	.text
	.attribute	4, 16
	.attribute	5, "rv32im"
	.file	"ifthenloop.c"
	.globl	ifthenloop
	.p2align	2
	.type	ifthenloop,@function
ifthenloop:
	addi	sp, sp, -16
	sw	ra, 12(sp)
	sw	s0, 8(sp)
	sw	s1, 4(sp)
	lui	s0, %hi(v)
	sw	zero, %lo(v)(s0)
	#APP
	mark	1
	#NO_APP
	li	s1, 3
	#lo.bge	a0, a1, 0x022 # 0:1:2
	tlo.bge	a0, a1, 0x096 # 0:1:2:3
.LBB0_2:
  l.jal ra, folded_foo
.LBB0_3:
  r.jal ra, folded_foo
	addi	s1, s1, -1
	addi	s1, s1, -1
	bnez	s1, .LBB0_2
	bnez	s1, .LBB0_3
  #lo.beq a0,a0,0x00
  #lo.beq a0,a0,0x00
	#APP
	mark	2
	#NO_APP
	lw	a0, %lo(v)(s0)
	lw	ra, 12(sp)
	lw	s0, 8(sp)
	lw	s1, 4(sp)
	addi	sp, sp, 16
	ret
.Lfunc_end0:
	.size	ifthenloop, .Lfunc_end0-ifthenloop

	.p2align	2
	.type	folded_foo,@function
folded_foo:
	lui	a0, %hi(v)
	lui	a0, %hi(v)
	lw	a1, %lo(v)(a0)
	lw	a1, %lo(v)(a0)
	addi	a1, a1, 1
	addi	a1, a1, 0
  lo.beq a0,a0,0x000
  lo.beq a0,a0,0x000
	sw	a1, %lo(v)(a0)
	ret
.Lfunc_end1:
	.size	folded_foo, .Lfunc_end1-folded_foo

	.type	v,@object
	.section	.sbss,"aw",@nobits
	.p2align	2
v:
	.word	0
	.size	v, 4

	.ident	"clang version 15.0.0 (git@gitlab:anon/llvm-project.git 6b27cb740eaf01c8fc33e8e95956eaa2595f406e)"
	.section	".note.GNU-stack","",@progbits
	.addrsig
