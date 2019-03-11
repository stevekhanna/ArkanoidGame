@ CPSC 359 L01 Assignment 4
@ Daniel Nwaroh & Issack John & Steve Khanna
@ Daniel Nwaroh: 30017476
@ Steve Khanna: 10153930
@ Issack John: 30031053

@ASSIGNMENT CHECK LIST[]

@Main Menu Screen	  		[done]5
@Draw game State 			[]29		@missing 11 marsk
@Draw game menu	  			[]4			
@interact with game	  		[]8
@interact with game menu	[]4


@ Code section
.section .text


.global main
main:
		@ ask for the frame buffer information
		ldr		r0, =frameBufferInfo		@frame buffer information structure
		bl		initFbInfo
		bl		initGPIO
		
		b		MainMenuStart
		
GameLoop$:	
		ldr		r4,	=gameState			@ loads address of global variables

		mov		r5, #-1
		str 	r5,	[r4, #9]			@ ball velocity y

		mov		r5, #1
		str 	r5,	[r4, #5]			@ ball velocity x
		
		mov		r5,	#0					@ reset flag
		strb	r5,	[r4, #17]


GameLoopTop:
		
		ldr		r4,	=gameState			@ loads address of global variables
		
		ldrb	r5,	[r4, #4]			@ ball y position
		
		bl		checkCollision			@ check if any collision has occured
		
		ldr 	r6,	[r4, #9]			@ ball velocity y
		
		add		r5,	r6					@ apply change
		strb	r5,	[r4, #4]			@ store ball y position
		
		ldrb	r5,	[r4, #3]			@ ball x position
		ldr 	r6,	[r4, #5]			@ ball velocity x
		
		add		r5,	r6					@ apply change
		strb	r5,	[r4, #3]			@ store ball x position
		
		bl		DrawGameState			@ Draws the ball and paddel	
		
		ldrb	r5,	[r4, #4]			@ ball y position
		
		ldrb	r6,	[r4, #13]			@ number of lives the user has, should be 3 to begin with
		cmp		r5,	#20					@ checks to see if the ball has fallen out of bounds (below the paddle)
		subeq	r6, #1					@ if the ball has fallen out of bounds, the player loses a life
		bleq	reset					@ resets ball and paddle to starting positions
		
		strb	r6,	[r4, #13]			@ stores the number of lives
		
		ldrb	r6,	[r4, #13]	
		cmp		r6,	#0					@ checks to see if the player is out of lives
		beq		youLost					@ if theyre out of lives, a message will be displayed
				
		bl		checkButtons			@ check input
		mov		r8, r0					@ moving the value of whatever button is pressed to r8, so it can be compared later

		@bl		ClearBallAndPaddel
		
		ldr		r1,	=0xFDFF				@ left pressed
		cmp		r8,	r1					@ if left is pressed, the paddle will move left
		bleq	moveLeft
		
		ldr		r1,	=0xFEFF				@ right pressed
		cmp		r8,	r1					@ if right is pressed, the paddle will move right
		bleq	moveRight
		
		ldr		r1,	=0xEFFF				@ start is pressed
		cmp		r8,	r1					@ if start is pressed, game will pause
		bleq	pauseMenu
		
		ldrb	r6,	[r4, #4]
		cmp		r6, #19
		blt		skipLaunch
		ldr		r1,	=0x7FFF				@ if b is pressed
		cmp		r8,	r1					@ b launches the ball, so if b is pressed then the ball will be launched to start the game
		beq		GameLoop$
skipLaunch:

		@mov		r0,	#20000
		@bl		delayMicroseconds
		@ implement pause	
		
		b		GameLoopTop				@ if any other button is pressed then nothing is going to happen, since we are only checking for left, right, start and b for now
		
MainMenuStart:
		bl		DrawMenuStartSelected	@ Draws the menu with start selected

MainMenuTop:
		bl		checkButtons			@ get input
		mov		r8,	r0					@ moving the value of whatever button is pressed to r8, so it can be compared later

		@ if they press down go to main menu quit selected state
		ldr		r1,	=0xFBFF	
		cmp		r8,	r1
		beq		MainMenuQuit
		
		@ if they press b go to start game state
		ldr		r1,	=0xFF7F
		cmp		r8,	r1
		beq		startGame
		
		b		MainMenuTop				@ if a button that isnt checked for is pressed nothing is going to happen and we will just loop back to the top of the branch
		
MainMenuQuit:
		bl		DrawMenuQuitSelected @ Draws the menu with Quit selected
		
MainMenuQuitTop:
		bl		checkButtons			@ check input
		mov		r8,	r0					@ moving the value of whatever button is pressed to r8, so it can be compared later

		@ if the press up go to main menu play selected
		ldr		r1,	=0xF7FF
		cmp		r8,	r1
		beq		MainMenuStart
		
		@ if they press a then go to the quit game state
		ldr		r1,	=0xFF7F
		cmp		r8,	r1
		beq		QuitState
		
		b		MainMenuQuitTop			@ if a button that isnt checked for is pressed nothing is going to happen and we will just loop back to the top of the branch
		
startGame:
		@bl		DrawGrid				@ Draws the grid on the screen
		bl		ClearBallAndPaddel		@
		
		bl		DrawGameState

startGameTop:

		bl		checkButtons			@ checks input

		@ if they press a then launch the ball and start the game
		mov		r8,	r0
		ldr		r1,	=0x7FFF
		cmp		r8,	r1
		beq		GameLoop$

		@ if they press left then the paddle should go left
		ldr		r1,	=0xFDFF				@left pressed
		cmp		r8,	r1
		bleq	moveLeft

		@ if they press left then the paddle should go right
		ldr		r1,	=0xFEFF				@right pressed
		cmp		r8,	r1					
		bleq	moveRight
		
		@ if start is pressed, game should be paused
		ldr		r1,	=0xEFFF
		cmp		r8,	r1
		bleq	pauseMenu

		b		startGameTop			@ if a button that isnt checked for is pressed nothing is going to happen and we will just loop back to the top of the branch

youLost:
		ldr		r4,	=gameState			@ loads address of global variables
		
		@ DRAW YOU LOST IMAGE
		bl		DrawBlackBackGround		
		bl		DrawYouLose				@ displays message telling the user they lost
		
		b		haltLoop$				@ quits the program
		
reset:
		push	{r4-r7, lr}
		
		ldr		r4,	=gameState			@ loads address of global variables
		
		mov		r5,	#1
		strb	r5,	[r4, #17]			@ reset flag
		
		mov		r5, #29
		strb	r5,	[r4, #3]			@ reset ball x position
		
		mov		r5, #0					@ reset ball x velocity
		str 	r5,	[r4, #5]
		
		mov		r5, #19
		strb	r5,	[r4, #4]			@ reset ball y position
		
		mov		r5, #0					
		str		r5,	[r4, #9]			@ reset ball y velocity
		
		mov		r5, #28
		strb	r5,	[r4, #0]			@ reset paddel
		
		mov		r5, #29
		strb	r5,	[r4, #1]			@ reset paddel
		
		mov		r5, #30
		strb	r5,	[r4, #2]			@ reset paddel
		
		mov		r5,	#1	
		strb	r5,	[r4, #17]			@ reset flag
		
		pop		{r4-r7, pc}

pauseMenu:

		push	{r4-r7, lr}
		
pauseMenuTop:
		mov	r0,	#672					@ x position of pause menu
		mov	r1,	#200					@ y position
		ldr	r8, =imageWidth	
		mov	r7, #576					@ stting width of image
		str	r7, [r8]					@ store width
		ldr	r8, =imageHeight
		mov	r6, #324					@ setting height of image
		str	r6, [r8]					@ store height
		ldr	r2, =restart				@ gets the image (where restart is highlighted)
		bl	drawImage					@ draws image (of course)
		
		bl	checkButtons				@ checks input
		mov		r8,	r0					@ moving ibput value to a different register, so we can use it later
		
		@ if down is pressed, then the quit option will be highlighted
		ldr		r1, =0xFBFF			
		cmp		r8, r1
		beq		restartQuitSelected
		
		@ if start is pressed, we resume the game, continuing where we left off
		ldr		r1, =0xEFFF				@start
		cmp		r8, r1
		beq		resumeGame
		
		@ if a is pressed, we restart the game
		ldr		r1, =0xFF7F				@ a is pressed
		cmp		r8, r1
		beq		haltLoop$				@ has to be implemented
		
		b		pauseMenuTop			@ if anything else is pressed we are just going to go back to the top of this branch
		
restartQuitSelected:
		mov	r0,	#672					@ x position of pause menu
		mov	r1,	#200					@ y position
		ldr	r8, =imageWidth
		mov	r7, #576					@ setting width of image
		str	r7, [r8]					@ store width
		ldr	r8, =imageHeight
		mov	r6, #324					@ setting height of image
		str	r6, [r8]					@ store height
		ldr	r2, =restartQuit			@ gets the image (where quit is highlighted)
		bl	drawImage
							
		bl	checkButtons
		mov		r8,	r0					@ moving input value to a different register, so we can use it later
		
		@ if up is pressed, then the restart option will be highlighted
		ldr		r1,	=0xF7FF     		@ up is pressed 
		cmp		r8,	r1
		beq		pauseMenuTop
		
		@ if start is pressed, we resume the game, continuing where we left off
		ldr		r1, =0xEFFF				@ start is pressed
		cmp		r8, r1
		beq		resumeGame
		
		@ if a is pressed, here(while quit is selected), we will quit the game and go back to the original menu
		ldr		r1, =0xFF7F				@ a is pressed
		cmp		r8, r1
		beq		MainMenuStart
		
		b		restartQuitSelected		@ if anything else is pressed we are just going to go back to the top of this branch

resumeGame:

		pop		{r4-r7, pc}

@ prints a game over message
QuitState:
		bl		DrawBlackBackGround		
		mov		r0,	#900				
		mov		r1,	#350
		ldr		r2, =0xFFFF2416			// colour
		ldr		r3,	=gameOver
		bl		Draw_String
	
	haltLoop$:

		b	haltLoop$
			

@ Data section
.section .data

@ offsets
@ 0 = paddel left corner
@ 1 = paddel middle
@ 2 = paddel right corner
@ 3 = ball x
@ 4 = ball y
@ 5 = velocity x
@ 9 = velocity y
@ 13 = Lives
@ 14 = Score
@ 15 = Level
@ 16 = Win / Lose Flag
@ 17 = reset flag

.global gameState
gameState:
.byte		28,29,30		@ paddel x coord
.byte		29, 19			@ Ball x Coord, y coord,
.int		0 				@ Velocity x
.int		0				@ Velocity y
.byte		3				@ Lives
.byte		0				@ score
.byte		0				@ Level
.byte		0				@ Win / Lose
.byte		1				@ reset condition flag


.align
.global frameBufferInfo
frameBufferInfo:
.int	0
.int	0
.int	0

@For drawing ASCII TEXT
.global font
.align 4
font:	.incbin "font.bin"

.global imageWidth
imageWidth:
.int	0

.global imageHeight
imageHeight:
.int	0

.global imageArray
imageArray:
.byte		1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
.byte		1,0,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,0,1
.byte		1,0,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,0,1
.byte		1,0,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,0,1
.byte		1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1
.byte		1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1
.byte		1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1
.byte		1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1
.byte		1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1
.byte		1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1
.byte		1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1
.byte		1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1
.byte		1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1
.byte		1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1
.byte		1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1
.byte		1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1
.byte		1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1
.byte		1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1
.byte		1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1
.byte		1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1

endArray:
.align






