@ CPSC 359 L01 Assignment 4
@ Daniel Nwaroh & Issack John & Steve Khanna

@ Code section
.section .text

.global drawPaddle
drawPaddle:
	push {lr}
	mov	r0,	r11
	mov	r1,	r10
	ldr	r8, =imageWidth
	mov	r7, #128
	str	r7, [r8]
	ldr	r8, =imageHeight
	mov	r6, #16
	str	r6, [r8]
	ldr	r2, =yellow
	bl	drawImage
	pop {lr}
	mov	pc, lr
	

.global draw
draw:
	push {lr}
	mov	r0,	r11
	mov	r1,	r10
	ldr	r8, =imageWidth
	mov	r7, #64
	str	r7, [r8]
	ldr	r8, =imageHeight
	mov	r6, #32
	str	r6, [r8]
	bl	drawImage
	pop {lr}
	mov	pc, lr
	
	
@ Draw Pixel
@ r0 - x
@ r1 - y
@ r2 - color		

.global DrawPixel
DrawPixel:
	push	{r4, r5}
	offset	.req	r4
	ldr	r5,	=frameBufferInfo
	ldr	r3,	[r5, #4]
	mul	r1,	r3
	add	offset,	r0,	r1
	lsl		offset, #2
	ldr	r0,	[r5]
	str	r2,	[r0, offset]
	pop		{r4, r5}
	bx		lr

.global	drawImage
drawImage:
		push	{r5-r10, lr}
		
		mov	r10, r0
		mov	r5,	#0
		mov	r6,	#0
		ldr	r7, =imageWidth
		ldr	r7, [r7]
		ldr	r8, =imageHeight
		ldr	r8, [r8]
		
		mov	r9,	r2
		
outerLoop:

		mov	r5, #0			//reset pixels drawn x
		mov	r0, r10		//Re-initialize x -coordinate
		add	r1, r1,	#1		//Add one to y coordinate
		add	r6, r6,	#1		//Add one to pixels drawn y

		cmp	r6, r8			//Pixels drawn y < y bound?
		bge	done1		
	
drawLoop1:
		cmp	r5, r7			//Pixels drawn < Length?
		bge	outerLoop		//If yes, branch to done

		ldr	r2, [r9], #4		

		push	{r0, r1, r2}
		bl	DrawPixel
		pop	{r0, r1, r2}			
		
		add	r5,	r5, #1		//Add one to pixels drawn	
		add	r0,	r0, #1		//Add one to the x-coordinat

		b	drawLoop1
		

done1:		
		pop	{r5-r10, lr}
		mov	pc, lr

		


