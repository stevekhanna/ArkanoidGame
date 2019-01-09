

@ Code section
.section .text

.global	namesLabel
namesLabel:
		push 	{lr}
		
		ldr	r0,	=endNames
		ldr	r4,	=names
		mov	r9,	#120
		mov	r10,	#400
		
loopNames:
		ldrb	r11,	[r4],	#1
		
		bl	DrawChar
		add	r10,	r10,	#10
		cmp	r0,	r4
		bne	loopNames
		
		popeq	{lr}
		moveq	pc, lr
		
.global	DrawChar
DrawChar:
		push	{r0-r8, lr}
		chAdr		.req	r4
		px		.req	r5
		py		.req	r6
		row		.req	r7
		mask		.req	r8

		ldr		chAdr, =font		@ load the address of the font map
		mov		r0, #'B'		@ load the character into r0
		add		chAdr,	r0, lsl #4	@ char address = font base + (char * 16)

		mov		py, #767		@ init the Y coordinate (pixel coordinate)

charLoop$:
		mov		px, #1023		@ init the X coordinate

		mov		mask, #0x01		@ set the bitmask to 1 in the LSB
		
		ldrb		row, [chAdr], #1	@ load the row byte, post increment chAdr

rowLoop$:
		tst		row,	mask		@ test row byte against the bitmask
		beq		noPixel$

		mov		r0, px
		mov		r1, py
		mov		r2, #0x00FF0000		@ red
		bl		DrawPixel		@ draw red pixel at (px, py)

noPixel$:
		add		px, #1			@ increment x coordinate by 1
		lsl		mask, #1		@ shift bitmask left by 1

		tst		mask,	#0x100		@ test if the bitmask has shifted 8 times (test 9th bit)
		beq		rowLoop$

		add		py, #1			@ increment y coordinate by 1

		tst		chAdr, #0xF
		bne		charLoop$		@ loop back to charLoop$, unless address evenly divisibly by 16 (ie: at the next char)

		.unreq	chAdr
		.unreq	px
		.unreq	py
		.unreq	row
		.unreq	mask

		pop		{r4-r8, pc}


@ Data section
.section .data

names:	.byte	'M', 'A', 'D', 'E', ' ', 'B', 'Y', ':', ' ', 'L', 'A', 'M', 'E', 'S', 'S', ' ', 'A', 'N', 'D', ' ', 'S', 'H', 'A', 'N', 'N', 'O', 'N'
endNames:

.align	4
font:	.incbin	"font.bin"




