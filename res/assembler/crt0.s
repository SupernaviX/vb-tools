	.section .text
	.align	1

/*************************************************
  startup code
 *************************************************/
	.global	_start

_start:

	/* initiallize .data section */
	movhi	hi(__data_lma), r0, r1
	movea	lo(__data_lma), r1, r1
	movhi	hi(__data_end), r0, r2
	movea	lo(__data_end), r2, r2
	movhi	hi(__data_vma), r0, r3
	movea	lo(__data_vma), r3, r3
initdata:
	ld.b	0[r1], r4
	st.b	r4, 0[r3]
	add	1, r1
	add	1, r3
	cmp	r2, r3
	ble	initdata


	/* initiallize .bss section */
	movhi	0x501, r0, r3
	mov	r2, r4
	jr	loop_start1
loop_top1:
	st.h	r0, 0[r4]
	add	2, r4
loop_start1:
	cmp	r3, r4
	blt	loop_top1



	movea	0x1F, r0, r4
	shl	5, r4
	movhi	4, r0, r3
	movea	0xD800, r3, r5
	add	r4, r5
	movea	0x40, r0, r4
	st.h	r4, 0[r5]

	movhi	2, r0, r3
	movea	0xFFFF, r3, r3
	mov	r0, r4
	jr	loop_start2
loop_top2:
	st.h	r0, 0[r4]
	add	2, r4
loop_start2:
	cmp	r3, r4
	blt	loop_top2

	movhi	6, r0, r3
	movea	0xf800, r3, r3

	ld.h	0x0020[r3], r4
	andi	0xffff, r4, r4
	ori	0x0101, r4, r4
	st.h	r4, 0x0022[r3]

	st.h	r0, 0x0002[r3]
	movea	0xE01F, r0, r4
	st.h	r4, 0x0004[r3]
	movea	0x0001, r0, r4
	st.h	r4, 0x0042[r3]
	st.h	r4, 0x002E[r3]

	st.h	r0, 0x002A[r3]

	movea	0x20, r0, r4
	st.h	r4, 0x0024[r3]
	movea	0x40, r0, r4
	st.h	r4, 0x0026[r3]
	movea	0x20, r0, r4
	st.h	r4, 0x0028[r3]

	movea	0xE4, r0, r4
	st.h	r4, 0x0060[r3]
	st.h	r4, 0x0062[r3]
	st.h	r4, 0x0064[r3]
	st.h	r4, 0x0066[r3]
	st.h	r4, 0x0068[r3]
	st.h	r4, 0x006A[r3]
	st.h	r4, 0x006C[r3]
	st.h	r4, 0x006E[r3]

	st.h	r0, 0x0070[r3]

	st.h	r0, 0x004E[r3]
	st.h	r0, 0x004C[r3]
	st.h	r0, 0x004A[r3]
	st.h	r0, 0x0048[r3]

	movea	0x1F, r0, r4
	shl	5, r4
	movhi	4, r0, r3
	movea	0xD800, r3, r5
	add	r4, r5
	movea	0x40, r0, r4
	st.h	r4, 0[r5]

	movhi	2, r0, r3
	movea	0xFFFF, r3, r3
	mov	r0, r4
	jr	loop_start3
loop_top3:
	st.h	r0, 0[r4]
	add	2, r4
loop_start3:
	cmp	r3, r4
	blt	loop_top3
	
	movhi	0x0501,r0,sp
	mov	r31, r28
	jal	_vbSetColTable
	mov	r28, r31

	movhi	6, r0, r3
	movea	0xf800, r3, r3
loop_top4:
	ld.h	0x0020[r3], r4
	andi	0xffff, r4, r4
	andi	0x40, r4, r4
	be	loop_top4

	mov	r0, r5
	ldsr	r5, sr5
	mov	2, r5
	ldsr	r5, sr24

	movhi	0x200, r0, r3
	movea	0xff80, r0, r4
	st.b	r4, 0x0008[r3]
	movea	0x14, r0, r4
	st.b	r4, 0x0000[r3]
	mov	-1, r4
	st.b	r4, 0x0004[r3]

	st.b	r0, 0x0020[r3]

	movea	0x0080, r0, r4	
	st.b	r4, 0x0028[r3]

	movhi	0x100, r0, r5
	mov	1, r3
	st.b	r3, 0x0580[r5]

	mov	r0, r3
	jr	loop_start5
loop_top5:
	mov	r3, r4

	shl	6, r4
	movhi	0x100, r4, r5
	st.b	r0, 0x404[r5]
	st.b	r0, 0x400[r5]
	add	1, r3
loop_start5:
	cmp	6, r3
	blt	loop_top5

	mov	r0, r3
	movea	0x2000, r0, r5
	jr	loop_start6
loop_top6:
	add	1, r3
loop_start6:
	cmp	r5, r3
	blt	loop_top6

	movhi	0x100, r0, r5
	st.b	r0, 0x0580[r5]

	movhi	6, r0, r3
	movea	0xf800, r3, r3

	movea	0x0001, r0, r4
	st.h	r4, 0x0042[r3]
	movea	0x0101, r0, r4
	st.h	r4, 0x0022[r3]
	
	movea	0x20, r0, r4
	st.h	r4, 0x0024[r3]
	movea	0x40, r0, r4
	st.h	r4, 0x0026[r3]
	movea	0x20, r0, r4
	st.h	r4, 0x0028[r3]


	
	/* setup stack */
	movhi	0x0501,r0,sp
	/* movea	0xFFFC,sp,sp */

	/* call main function */
	jal	main

	/* Reset when main returns */
	/* movhi	0x0800,r0,r31 */
	movea	0xFFF0,r0,r31
	jmp	[r31]

	.section .vbheader
	.align 1
	/* TODO: this should be the entire ROM header, not just the reset vector */

	/* reset vector */
	movhi hi(_start), r0, r31
	movea lo(_start), r31, r31
	jmp [r31]
	/* TODO: improve padding */
	mov r0, r0
