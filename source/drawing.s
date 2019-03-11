@ CPSC 359 L01 Assignment 4
@ Daniel Nwaroh & Issack John & Steve Khanna
@ Daniel Nwaroh: 30017476
@ Steve Khanna: 10153930
@ Issack John: 30031053

@ Code section
.section .text


.global DrawScore
DrawScore:
	push	{r4, lr}
	
	ldr		r4, =gameState
	
	mov		r0,	#23
	mov		r1, #1
	ldr		r3, =backGround
	bl		DrawSquare
	
	mov		r0,	#24
	mov		r1, #1
	ldr		r3, =backGround
	bl		DrawSquare
	
	mov		r0,	#25
	mov		r1, #1
	ldr		r3, =backGround
	bl		DrawSquare
	
	mov		r0,	#26
	mov		r1, #1
	ldr		r3, =backGround
	bl		DrawSquare
	
	
	mov		r0,	#28
	mov		r1, #1
	ldr		r3, =backGround
	bl		DrawSquare
	
	mov		r0,	#29
	mov		r1, #1
	ldr		r3, =backGround
	bl		DrawSquare
	
	mov		r0,	#30
	mov		r1, #1
	ldr		r3, =backGround
	bl		DrawSquare
	
	mov		r0,	#31
	mov		r1, #1
	ldr		r3, =backGround
	bl		DrawSquare
	
	ldrb	r5,	[r4, #13]
	cmp		r5,	#3
	beq		plvies3
	
	cmp		r5,	#2
	beq		plvies3
	
	cmp		r5,	#1
	beq		plvies3
	
plvies3:
	mov		r0,	#900
	mov		r1, #50
	ldr		r2,	=0xFFFF0F13
	ldr		r3, =lives
	bl		Draw_String
	b		plivesdone
	
plvies2:
	mov		r0,	#900
	mov		r1, #50
	ldr		r2,	=0xFFFF0F13
	ldr		r3, =lives2
	bl		Draw_String
	b		plivesdone
plvies1:
	mov		r0,	#900
	mov		r1, #50
	ldr		r2,	=0xFFFF0F13
	ldr		r3, =lives1
	bl		Draw_String
	
plivesdone:
	mov		r0,	#750
	mov		r1, #50
	ldr		r2,	=0xFFFF0F13
	ldr		r3, =score
	bl		Draw_String
	
	pop		{r4, pc}

@ Draws the ball and paddel0
.global DrawGameState
DrawGameState:

		push	{lr}

		@mov		r0,	#5000
		@bl		delayMicroseconds
		
		bl		DrawGrid
		
		ldr		r0,	=padel
		bl		DrawPaddel
		
		ldr		r0,	=ball
		bl		DrawBall
		
		bl		DrawScore
		
		pop		{pc}

.global ClearBallAndPaddel
ClearBallAndPaddel:
		push	{lr}
		ldr		r0,	=backGround
		bl		DrawPaddel
		
		ldr		r0,	=backGround
		bl		DrawBall
		pop		{pc}


@ Draws the paddle on the screen
@ 3 similar blocks to portray a longer paddel
.global DrawPaddel
DrawPaddel:
		push	{r4-r11, lr}
		
		mov		r8,	r0
		ldr		r4,	=gameState			@get the game state array

		mov		r7,	#0
		
drawPaddelAgain:		
		ldrb	r5,	[r4], #1
		
		mov		r0,	r5
		mov		r1,	#20
		mov		r3,	r8
		bl		DrawSquare
		
		add		r7,	#1
		cmp		r7,	#3
		blt		drawPaddelAgain
		
		pop	{r4-r11, pc}

@ Draws the ball on the screen
.global DrawBall
DrawBall:
		push	{r4, lr}
		ldr		r4,	=gameState
		
		mov		r3,	r0
		ldrb	r0,	[r4, #3]
		ldrb	r1,	[r4, #4]
		bl		DrawSquare
		
		pop	{r4, pc}

@ Draws the black background on the screen, floor tiles
.global	DrawBlackBackGround
DrawBlackBackGround:
		push	{r4-r5, lr}
		mov		r4,	#20
		mov		r5,	#2
		b		loopblackrow
nextb:
		mov		r4,	#20	
		
loopblackrow:
		mov		r0,	r4
		mov		r1,	r5		
		
		ldr		r3,	=backGround
		bl		DrawSquare
		
		add		r4,	#1
		cmp		r4,	#40
		blt		loopblackrow
		add		r5,	#1
		cmp		r5,	#22
		blt		nextb
		pop		{r4-r5, pc}

@Draws the grid on the screen, blocks and wall
.global DrawGrid
DrawGrid:
		push 	{r4-r7, lr}
		mov		r4,	#20
		mov		r5,	#2
		ldr		r6,	=imageArray
		b		loopdrow
next:
		mov		r4,	#20	
		
loopdrow:
		mov		r0,	r4
		mov		r1,	r5		
		
		ldrb	r7,	[r6], #1
		
		cmp		r7,	#0
		ldreq	r3,	=backGround
		
		cmp		r7,	#1
		ldreq	r3,	=wall
		
		cmp		r7,	#2
		ldreq	r3,	=red
		
		cmp		r7, #3
		ldreq	r3,	=yellow
		
		cmp		r7,	#4
		ldreq	r3,	=pink
		
		bl		DrawSquare
		
		add		r4,	#1
		cmp		r4,	#40
		blt		loopdrow
		add		r5,	#1
		cmp		r5,	#22
		blt		next
		
		pop	{r4-r7, pc}

@ Draw a sqaure on the screen
@ Takes in the address of the picture in r3
.globl DrawSquare
DrawSquare:
		push		{r4-r11,lr}
		
		mov	 	r9,	#32             //32 is the offset
			
		lsl		r10,r0, #5                              
		lsl 	r11,r1, #5 

		mov		r4,	r10				@ starting x position of the picture
		mov		r5,	r11				@ starting y position of the picture

		mov		r6,	r3				@ address of the picture
		mov		r7,	r4				@ start x

		add     r7, #32				@ add 32 to x
		mov		r8, r5				
		add     r8, #32				@ add 32 to y

drawPictureLoop:
		mov		r0,	r4
		mov		r1,	r5
		
		ldr		r2,	[r6], #4 		@ setting pixel color
		push	{r3}				@ to make sure r3 does not get messed up
		bl		DrawPixel			
		pop		{r3}				
		add		r4,	#1				@ increment x position

		cmp		r4,	r7				@compare with image width
		blt		drawPictureLoop

		mov		r4,	r10				@ reset x
		add		r5,	#1				@ increment Y

		cmp		r5,	r8				@ compare y with image height
		blt		drawPictureLoop
		
		pop    {r4-r11,lr}
		mov		pc,	lr				@ return


@ Draws a string at the given x and y
@ r0 = x
@ r1 = y
@ r2 = color
@ r3 = adress for the string
.globl Draw_String
Draw_String:
	push 	{r4-r10, lr}	

	senAdr	.req	r4
	px		.req	r5
	py		.req	r6
	colour	.req	r7


	mov		px, r0
	mov		py, r1
	mov		colour, r2
	mov		senAdr, r3

	mov		r8, #0	//index = 0

	ldrb	r9, [senAdr]

Draw_String_Loop:
	mov		r0, px
	mov		r1, py
	mov		r2, colour
	mov		r3, r9
	bl		Draw_Char

	add		r8, #1					@increment index
	add		px, #10					@*******increment spacing for letters*******CHANGE SPACING HERE

	ldrb	r9, [senAdr, r8] 		@load next letter in string
	
	cmp		r9, #0					@compare to /0
	bne		Draw_String_Loop
	
Draw_String_Loop_Done:
	.unreq	senAdr
	.unreq	px
	.unreq	py
	.unreq	colour	

	pop 	{r4-r10, lr}
	mov	pc, lr

@ Draw the character to (x,y)
.globl Draw_Char
Draw_Char:
	push	{r4-r10, lr}

	chAdr	.req	r4
	px		.req	r5
	py		.req	r6
	row		.req	r7
	mask	.req	r8
	colour	.req	r9
	pxINIT	.req	r10

	ldr		chAdr, 	=font			@ load the address of the font map
	add		chAdr, 	r3, lsl #4		@ char address = font base + (char * 16)

	mov		colour, r2
	mov		py, 	r1				@ init the Y coordinate (pixel coordinate)
	mov		pxINIT,	r0

charLoop$:
	mov		px,		pxINIT			@ init the X coordinate

	mov		mask, #0x01				@ set the bitmask to 1 in the LSB
	
	ldrb	row, [chAdr], #1		@ load the row byte, post increment chAdr

rowLoop$:
	tst		row, mask				@ test row byte against the bitmask
	beq		noPixel$

	mov		r0, px
	mov		r1, py
	mov		r2, colour
	bl		DrawPixel				@ draw r2 coloured pixel at (px, py)

noPixel$:
	add		px, #1					@ increment x coordinate by 1
	lsl		mask, #1				@ shift bitmask left by 1

	tst		mask, #0x100			@ test if the bitmask has shifted 8 times (test 9th bit)
	beq		rowLoop$

	add		py, #1					@ increment y coordinate by 1

	tst		chAdr, #0xF
	bne		charLoop$				@ loop back to charLoop$, unless address evenly divisibly by 16 (ie: at the next char)


	.unreq	chAdr
	.unreq	px
	.unreq	py
	.unreq	row
	.unreq	mask
	.unreq	colour
	.unreq	pxINIT

	pop		{r4-r10, lr}
	mov		pc, lr



	
@ Draw Pixel
@ r0 - x
@ r1 - y
@ r2 - color		
.global DrawPixel		
DrawPixel:
		push	{r4,r5}
		offset	.req	r4

		ldr		r5, =frameBufferInfo
	
		@offset = (y * width) + x
	
		ldr		r3, [r5, #4]		@ r3 = width
		mul		r1, r3
		add		offset, r0, r1
		
		@ offset *= 4 (32 bits per pixel/8 = 4 bytes per pixel)
		lsl		offset, #2
		
		@ store the color (word) at frame buffer pointer + offset
		ldr		r0, [r5]			@ r0 = frame buffer pointer
		str		r2, [r0, offset]
		
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

		mov	r5, #0					@ reset pixels drawn x
		mov	r0, r10					@ Re-initialize x -coordinate
		add	r1, r1,	#1				@ Add one to y coordinate
		add	r6, r6,	#1				@ Add one to pixels drawn y

		cmp	r6, r8					@ Pixels drawn y < y bound?
		bge	done1		
	
drawLoop1:
		cmp	r5, r7					@ Pixels drawn < Length?
		bge	outerLoop				@ If yes, branch to done

		ldr	r2, [r9], #4		

		push	{r0, r1, r2}
		bl	DrawPixel
		pop	{r0, r1, r2}			
		
		add	r5,	r5, #1				@ Add one to pixels drawn	
		add	r0,	r0, #1				@ Add one to the x-coordinat

		b	drawLoop1
		

done1:		
		pop	{r5-r10, lr}
		mov	pc, lr
@ Data section
.section .data

.global gameName
gameName:
.asciz	"Arkanoid\n"				@ size = 8

.global names
names:
.asciz	"Created by: Daniel Nwaroh, Issack John and Steve Khanna\n"	 @size = 56

.global mainMenu
mainMenu:
.asciz	"Main Menu"

.global playGame
playGame:
.asciz "Play Game\n"				@ size = 9

.global quit
quit:
.asciz "Quit Game\n"				@ size = 4

.global playGameSelect
playGameSelect:
.asciz	"> Play Game"				@ size = 11

.global quitSelect
quitSelect:
.asciz	"> Quit Game"				@ size = 6

.global gameOver
gameOver:
.asciz "CYA NERD"

.global score
score:
.asciz "Score: 0\n"

.global lives
lives:
.asciz "Lives: 3\n"

.global lives
lives2:
.asciz "Lives: 2\n"

.global lives
lives1:
.asciz "Lives: 1\n"
