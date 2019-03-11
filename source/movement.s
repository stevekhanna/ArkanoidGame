@ CPSC 359 L01 Assignment 4
@ Daniel Nwaroh & Issack John & Steve Khanna
@ Daniel Nwaroh: 30017476
@ Steve Khanna: 10153930
@ Issack John: 30031053

@BOARD VALID BOUNDS IS X = 22 -38
@BOARD VALID BOUNDS IS Y = 2 - 22

@ Code section
.section .text


@ moves paddle left, then returns when done
.global moveLeft
moveLeft:
		push	{r4-r7, lr}
		
		ldr		r4,	=gameState					@ loads address of global variables
		mov		r7,	#0							
		
		ldrb	r5,	[r4, r7]					@ getting the address of the left corner of the paddle
		cmp		r5,	#21							@ checks to see if the paddle is at the left most, if it is then it wont go left any more
		ble		dontMoveLeft

@ loop to check all three parts of the paddle (left, middle, right)
movePaddelLeftAgain:
		ldrb	r5,	[r4, r7]					
		add		r5,	#-1
		strb	r5,	[r4, r7]

		add		r7,	#1
		cmp		r7,	#3
		blt		movePaddelLeftAgain
		
@ also prevents ball from following the paddle during gameplay		
dontMoveLeft:
		ldrb	r6,	[r4, #17]
		cmp		r6,	#1
		bne		resetFalse
		ldrb	r8,	[r4, #3]
		cmp		r8,	#22
		ble		resetFalse
		add		r8,	#-1
		strb	r8,	[r4, #3]
resetFalse:	

		bl		ClearBallAndPaddel
		bl		DrawGameState
		
		pop		{r4-r7, pc}
		

@ moves paddle right, then returns when done
.global	moveRight
moveRight:
		push	{r4-r9, lr}
		
		ldr		r4,	=gameState
		mov		r7,	#0
		
		ldrb	r8,	[r4, #2]					@ getting the address of the right corner of the paddel
		cmp		r8,	#38							@ checks to see if the paddle is at the right most, if it is then it wont go right any more
		bge		dontMoveRight

@ loop to check all three parts of the paddle (left, middle, right)		
movePaddelRightAgain:		
		ldrb	r5,	[r4, r7]
		add		r5,	#1
		strb	r5,	[r4, r7]
		
		add		r7,	#1
		cmp		r7,	#3
		blt		movePaddelRightAgain
		
@ also prevents ball from following the paddle during gameplay
dontMoveRight:
		ldrb	r6,	[r4, #17]
		cmp		r6,	#1
		bne		resetFalse2
		ldrb	r8,	[r4, #3]
		cmp		r8,	#37
		bge		resetFalse2
		add		r8,	#1
		strb	r8,	[r4, #3]
resetFalse2:

		bl		ClearBallAndPaddel
		bl		DrawGameState
		pop		{r4-r9, pc}

@ checks to see if the ball hits the walls
.global checkCollision
checkCollision:
		push	{r4-r11, lr}

		ldr		r4,	=gameState
		ldr		r10, =imageArray
		
		ldrb	r5,	[r4, #4]			@ ball y
		ldr		r6,	[r4, #9]			@ ball velocity y

		add		r7,	r5,	r6				@the calculated next ball coordinate

		mov		r9, #2	
		cmp		r7,	r9					@ checks to see if ball hit the top(ceiling), top is 2
		ble		hitCeil
		
		mov		r0,	r7
		cmp		r7,	#20
		bleq	checkPaddelCollision
				
		bl		checkX
		

@loop to check if you hit any of the objects

checkX:

		ldrb	r5,	[r4, #3]			@ ball x
		ldr		r6,	[r4, #5]			@ ball velocity x
		add		r7,	r5,	r6
		
		@ is the ball hitting the right wall
		mov		r9,	#20					
		cmp		r7,	r9
		beq		hitLeftWall

		@ is the ball hitting the right wall
		mov		r9,	#39					
		cmp		r7,	r9
		beq		hitRightWall
		@increment score
		b		done

@ if the ball hits the ceiling the y velocity is gonna change so that the ball starts travelling downwards again
hitCeil:
		mov		r1,	#1
		str		r1,	[r4, #9]
		b		checkX

@ if the ball hits the left the x velocity is gonna change so that the ball changes direction
hitLeftWall:
		mov		r1,	#1
		str		r1,	[r4, #5]
		b		done

@ if the ball hits the left the x velocity is gonna change so that the ball changes direction
hitRightWall:
		mov		r1,	#-1
		str		r1,	[r4, #5]
		b		done
		
done:
		bl		checkHitBlock			@ check to see if a block was hit
		
		pop		{r4-r11, pc}



		
@ checks to see if ball hit one of the blocks
.global checkHitBlock
checkHitBlock:
		push	{r4-r11, lr}
		
		ldr		r4,	=gameState
		ldr		r5, =imageArray

		ldrb	r6,	[r4, #3]		@ x
		ldr		r7,	[r4, #5]		@ velocity x
		add		r8,	r6, r7			@ calculated coordinate
		sub		r8,	#20
		

		ldrb	r6,	[r4, #4]		@ y
		ldr		r7,	[r4, #9]		@ velocity y
		add		r9,	r6, r7			@ calculated coordinate
		sub		r9,	#2
		
		b		checkDiag	

checkTop:

		ldr		r4,	=gameState
		ldr		r5, =imageArray

		ldrb	r6,	[r4, #3]		@ x
		ldr		r7,	[r4, #5]		@ velocity x
		add		r8,	r6, r7			@ calculated coordinate
		sub		r8,	#21
		

		ldrb	r6,	[r4, #4]		@ y
		ldr		r7,	[r4, #9]		@ velocity y
		add		r9,	r6, r7			@ calculated coordinate
		sub		r9,	#2
		
		mov		r7, #20				@ bottom of the screen is 20
		mul	    r7,	r9
		add		r8, r7
		
		ldrb	r9,	[r5, r8]
		cmp		r9, #2				@ determining which type of block was hit
		beq		hitRed

		ldrb	r9,	[r5, r8]
		cmp		r9, #3				@ determining which type of block was hit
		beq		hitYellow

		ldrb	r9,	[r5, r8]
		cmp		r9, #4				@ determining which type of block was hit
		beq		hitPink	
		
		b		doneCheckHit

checkDiag:
		mov		r7, #20
		mul	    r7,	r9
		add		r8, r7
		
		ldrb	r9,	[r5, r8]
		cmp		r9, #2				@ determining which type of block was hit, frrm diagonal
		beq		hitRed

		ldrb	r9,	[r5, r8]
		cmp		r9, #3
		beq		hitYellow

		ldrb	r9,	[r5, r8]
		cmp		r9, #4
		beq		hitPink
		
		b		checkTop
		

@ replace red block with yellow block
hitRed:
		mov		r9,	#3
		strb	r9,	[r5, r8]
		
		mov		r10, #-1
		ldr		r9,	[r4, #9]
		
		mul		r9,	r10
		str		r9,	[r4, #9]

		b		doneCheckHit

@ replace yellow block with pink block
hitYellow:
		mov		r9,	#4
		strb	r9,	[r5, r8]

		mov		r10, #-1
		ldr		r9,	[r4, #9]
		mul		r9,	r10
		str		r9,	[r4, #9]

		b		doneCheckHit

@ replace pink block with black block
hitPink:
		mov		r9,	#0
		strb	r9,	[r5, r8]
		
		mov		r10, #-1
		ldr		r9,	[r4, #9]
		
		mul		r9,	r10
		str		r9,	[r4, #9]

		@mov		r9,	#-1
		@str		r9, [r4, #5]

doneCheckHit:			
		
		pop		{r4-r11, pc}
		
@ attempt to make movement smooth, with collision
@ 0 = slope decreasing
@ 1 = slope increasing		
calculateSlope:
		push	{r4-r11, lr}
		
		ldr		r4,	=gameState
		
		ldrb	r5,	[r4, #3]		@ x
		ldr		r6,	[r4, #5]		@ velocity x
		add		r6,	r5,	r6			@ next x

		ldrb	r6,	[r4, #4]		@ y
		ldr		r7,	[r4, #9]		@ velocity y
		add		r7,	r6,	r7			@ next y
		
		@ r6 - r5 / r7 - r6
		sub		r6,	r6,	r5			@ x slope
		sub		r7,	r7,	r6			@ y slope
		sdiv	r7, r7, r6
		
		cmp		r7,	#0
		movlt	r0,	#0
		
		cmp		r7,	#0
		movgt	r0,	#1
			
		pop		{r4-r11, pc}
		
		
checkPaddelCollision:
		push	{r4-r11, lr}
		ldr		r4,	=gameState
		
		ldrb	r8,	[r4, #3]
				
		ldrb	r5,	[r4, #0]	@ paddel left position
		ldrb	r6,	[r4, #1]	@ paddel middle position
		ldrb	r7,	[r4, #2]	@ paddel right position
		
		cmp		r8,	r5	
		beq		paddleLeft
		
		cmp		r8,	r6	
		beq		paddleMiddle
		
		cmp		r8,	r7	
		beq		paddleRight
		
		b		paddleDone

@ depending on where the ball hits the paddle, it will bounce off differently	
paddleLeft:
		mov		r9,	#-1
		str		r9,	[r4, #5]
		
		mov		r9,	#-1
		str		r9,	[r4, #9]
		b		paddleDone
		
paddleMiddle:
		mov		r9,	#1
		str		r9,	[r4, #5]
		
		mov		r9,	#-1
		str		r9,	[r4, #9]
		
		b		paddleDone
		
paddleRight:
		mov		r9,	#1
		str		r9,	[r4, #5]
		
		mov		r9,	#-1
		str		r9,	[r4, #9]
		
paddleDone:
		
		pop		{r4-r11, pc}

@ Data section
.section .data
