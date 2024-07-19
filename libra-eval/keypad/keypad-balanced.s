	.file	"keypad.c"
	.option nopic
	.attribute arch, "rv32im"
	.attribute unaligned_access, 0
	.attribute stack_align, 16
	.text
	.align	2
	.globl	keypad_init
	.type	keypad_init, @function
keypad_init:
	lui	a5,%hi(key_state)
	sh	zero,%lo(key_state)(a5)
	lui	a5,%hi(pin_idx)
	sw	zero,%lo(pin_idx)(a5)
	ret
	.size	keypad_init, .-keypad_init
	.align	2
	.globl	keypad_poll
	.type	keypad_poll, @function
keypad_poll:
	lui	a2,%hi(.LANCHOR0)
	addi	a2,a2,%lo(.LANCHOR0)
	lui	t1,%hi(pin)
	addi	a6,a2,64
	li	a5,1
	lui	a1,%hi(key_state)
	lui	a7,%hi(pin_idx)
	li	t4,3
	addi	t1,t1,%lo(pin)
.L5:
	lhu	a3,%lo(key_state)(a1)
 #APP
# 36 "keypad.c" 1
	mark 1
# 0 "" 2
 #NO_APP
	and	a4,a0,a5
	and	a3,a3,a5

  # Hoist temporaries (with reallocated registers)
	lw	t0,%lo(pin_idx)(a7)
	add	t2,t0,t1

  lbu	t5,0(a2)
  lbu	t6,0(t2)

	beq	a4,zero,.LA
	bne	a3,zero,.LB
	bgt	t0,t4,.LC
	addi	t3,t0,1
  addi  a4,t5,0
  j .L4

.LA:
	beq	a4,a4,.LB
.LB:
	beq	a3,a3,.LC
.LC:
	addi	t3,t3,0
  addi  a4,t6,0
  j .L4

.L4:
	sw	t3,%lo(pin_idx)(a7)
	sb	a4,0(t2)

 #APP
# 45 "keypad.c" 1
	mark 2
# 0 "" 2
 #NO_APP
	addi	a2,a2,4
	slli	a5,a5,1
	bne	a6,a2,.L5
	lw	a5,%lo(pin_idx)(a7)
	sh	a0,%lo(key_state)(a1)
	li	a0,4
	sub	a0,a0,a5
	ret
	.size	keypad_poll, .-keypad_poll
	.section	.rodata
	.align	2
	.set	.LANCHOR0,. + 0
	.type	keymap, @object
	.size	keymap, 64
keymap:
	.word	49
	.word	52
	.word	55
	.word	48
	.word	50
	.word	53
	.word	56
	.word	70
	.word	51
	.word	54
	.word	57
	.word	69
	.word	65
	.word	66
	.word	67
	.word	68
	.section	.sbss,"aw",@nobits
	.align	2
	.type	pin, @object
	.size	pin, 4
pin:
	.zero	4
	.type	pin_idx, @object
	.size	pin_idx, 4
pin_idx:
	.zero	4
	.type	key_state, @object
	.size	key_state, 2
key_state:
	.zero	2
	.ident	"GCC: (GNU) 10.2.0"
