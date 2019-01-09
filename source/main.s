@ CPSC 359 L01 Assignment 4
@ Daniel Nwaroh & Issack John & Steve Khanna

@ASSIGNMENT CHECK LIST[]

@Main Menu Screen	  	[]5
@Draw game State 		[]29
@Draw game menu	  		[]4
@interact with game	  	[]8
@interact with game menu	[]4



@ Code section
.section .text


.global main
main:
	@ ask for the frame buffer information
	ldr		r0, =frameBufferInfo		@frame buffer information structure
	bl		initFbInfo
	bl	SNESmain
one:
	mov	r8, r0
.global next
next:	
	mov	r5, #1
	mov	r11,	#300	//init x 
	mov	r10,	#100	//init y
	mov	r9,	#1		//elem num
	mov	r4,	#21	
	ldr	r1,	=imageArray
	ldrb	r2,	[r1]

check:
	cmp	r2,	#0
	beq	setBackground
	cmp	r2, #1
	beq	setBrick
	cmp	r2, #2
	beq	setGrey
	cmp	r2, #3
	beq	setGreen
	cmp	r2, #4
	beq	setRed
	
checkBranch:
	cmp	r5, #1
	beq	initPaddle
	bne	haltLoop$
	
initPaddle:
	add	r5, #1
	mov	r11, #876
	mov	r10, #658
	bl	drawPaddle
	b	haltLoop$
	
setBackground:
	ldr	r2, =background
	bl	draw
	b	adder

setBrick:
	ldr	r2, =wall
	bl	draw
	b	adder

setGreen:
	ldr	r2, =green
	bl	draw
	b	adder

setGrey:
	ldr	r2, =grey
	bl	draw
	b	adder

setRed:
	ldr	r2, =red
	bl	draw
	b	adder

adder:
	add	r9, r9, #1
	b	newCheck
	
newCheck:
	ldr	r0,	=endArray
	ldr	r1,	=imageArray
	sub	r8, r9, #1
	ldrb	r2,	[r1, r8]!
	cmp	r1,	r0
	beq	checkBranch
	cmp	r9,	r4
	beq	changeBoth
	bne	onlyX
onlyX:
	add		r11, r11, #64
	b		check

changeBoth:
	add		r4, #20
	add		r10, r10, #31
	mov		r11, #236
	b		onlyX	
	
haltLoop$:
		b	haltLoop$

@ Data section
.section .data

.align
.global frameBufferInfo
frameBufferInfo:
.int	0
.int	0
.int	0

.global	FrameBuffer
FrameBuffer:
.int	0
.int	0
.int	0

@For drawing ASCII TEXT
.align 4
font:	.incbin "font.bin"

.global imageWidth
imageWidth:
.int	0
.global	imageHeight
imageHeight:
.int	0


imageArray:
.byte		1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
.byte		1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,1
.byte		1,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,1
.byte		1,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,1
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





