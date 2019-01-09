@ CPSC 359 L01 Assignment 4
@ Daniel Nwaroh & Issack John & Steve Khanna

@ASSIGNMENT CHECK LIST[]

@Display creator names & messages	  []







@ Code section
.section    .text

.global initController


initController:
		ldr		r0,	=names
		bl		printf
		mov		r10,	#0xffff
		
		bl		getGpioPtr
		ldr		r1,	=label				@Base address
		str		r0,	[r1]
		
		mov		r0,	#9
		mov		r1,	#1
		bl		InitGPIO

		mov		r0,	#10
		mov		r1,	#0
		bl		InitGPIO

		mov		r0,	#11
		mov		r1,	#1
		bl		InitGPIO
		
		b		request
		
reLoop:	b		request
		
looop:	
		bl		Read_SNES
		mov		r7,	r0

		mov		r0,	#60000
		bl		delayMicroseconds
		
		bl		Read_SNES
		cmp		r7, r0
		beq		looop
		cmp		r0, r10
		beq		looop
				
		//mov		r7,	r0
		
		//ldr		r0,	=test1
		//mov		r1,	r7
		//bl		printf
		
		//ldr		r1,	=0xFFFF
		//cmp		r7,	r1
		//beq		looop
		
		//ldr		r0,	=test1
		//mov		r1,	r7
		//bl		printf
		
		//ldr		r1,	=0xFFFF
		//teq		r0,	r1
		//beq		looop
		
		bl		checkMsg
		
		b		request
		
checkMsg:
		push	{r6, lr}
		mov		r6,	r0
		
		ldr		r1,	=0x7FFF
		teq		r6,	r1
		beq		printB
		
		ldr		r1,	=0XBFFF
		teq		r6,	r1
		beq		printY
		
		ldr		r1,	=0xDFFF
		teq		r6,	r1
		beq		printSelect
		
		ldr		r1,	=0xEFFF
		teq		r6,	r1
		beq		printEnd
		
		ldr		r1,	=0xF7FF
		teq		r6,	r1
		beq		printUp
		
		ldr		r1,	=0xFBFF
		teq		r6,	r1
		beq		printDown
		
		ldr		r1,	=0xFDFF
		teq		r6,	r1
		beq		printLeft
		
		ldr		r1,	=0xFEFF
		teq		r6,	r1
		beq		printRight
		
		ldr		r1,	=0xFF7F
		teq		r6,	r1
		beq		printA
		
		ldr		r1,	=0xFFBF
		teq		r6,	r1
		beq		printX
		
		ldr		r1,	=0xFFDF
		teq		r6,	r1
		beq		printLb
		
		ldr		r1,	=0xFFEF
		teq		r6,	r1
		beq		printRb
		
		//b		reLoop
		@bl		reLoop	
		
		pop		{r8, pc}	
		

stop:	b		stop

request:
//		push 	{ fp, lr}
//		mov		fp,	sp

//		bl		getGpioPtr
//		ldr		r1,	=label				@Base address
//		str		r0,	[r1]

//		mov		r0,	#9
//		mov		r1,	#1
//		bl		InitGPIO

//		mov		r0,	#10
//		mov		r1,	#0
//		bl		InitGPIO

//		mov		r0,	#11
//		mov		r1,	#1
//		bl		InitGPIO
		
		ldr		r0,	=pressButton
		bl		printf
		
		b		looop
		
//		pop		{fp, pc}
//		mov		pc, lr

@the subroutine initializes a GPIO line,
@the line number and function code must be passed
@as parameters. The subroutine needs to be general
InitGPIO:
		push 	{r4, r5, r7, r8}
		@mov		fp,	sp
		
		mov		r4,	r0								@r4: 1st arg
		mov		r5,	r1								@r5: 2nd arg, function code 1 or 0
		
		ldr		r0,	=label
		ldr		r0,[r0]
		
		//mov		r4,	r0
		
		//ldr		r0,	=test2
		//mov		r1,	r4
		//bl		printf

		cmp		r4,	#9
		bne		sel1
		//beq		lineNine

		//cmp		r4,	#10
		//beq		lineTen

		//b		lineElvn

sel0:
		mov		r8,	#9
		b		next
		
sel1:	
		add		r0,	r0,	#4
		sub		r8,	r4,	#10
		
next:
		ldr	r1, [r0]			
	
		mov	r2, #7				
		
		mov	r7, #3				
		mul	r4, r8, r7			
		lsl	r2, r4				
		bic	r1, r2				
		
		lsl	r5, r4				
		orr	r1, r5				
		str	r1, [r0]			

		pop	{r4, r5, r7, r8}	
		mov	pc, lr				

@LATCH - output
lineNine:
		ldr		r0,	=label
		ldr		r0, [r0]
		
		ldr		r1,	[r0]

		mov		r2,	#7
		lsl		r2,	#27

		bic		r1,	r2
		mov		r3,	#1

		lsl		r3,	#27
		orr		r1,	r3

		str		r1,	[r0]
		
		b		ExitInitGPIO

@DATA - input
lineTen:
		//mov		r4,	r0
		
		ldr		r0,	=label
		@ldr		r0,	[r0]
		ldr		r0, [r0]
		add		r0,	r0,	#4
		@sub		r4,	#10
		@ldr		r1,	[r0, #0x4]
		
		ldr		r1,	[r0]

		mov		r2,	#7
		lsl		r2,	#3

		bic		r1,	r2
		mov		r3,	#0
		
		lsl		r5,	r4

		orr 	r1,	r5

		str 	r1,	[r0]
		
		b		ExitInitGPIO

@CLOCK - output
lineElvn:
		ldr		r0,	=label
		@ldr		r0,	[r0]
		ldr		r0, [r0]
		add		r0,	r0,#4
		@ldr		r1,	[r0, #4]

		ldr		r1,	[r0]

		mov		r2,	#7
		lsl		r2,	#3

		bic		r1,	r2
		mov		r3,	#1
		
		lsl		r5,	r4
		orr		r1,	r5

		str		r1,	[r0]		
		

ExitInitGPIO:
		pop		{r4, r5}
		@mov		pc, lr
		

@Write a bit to the SNES latch line
Write_Latch:
		mov		r1,	r0
		mov		r0,	#9
		
		ldr		r2,	=label
		ldr		r2, [r2]
		mov		r3,	#1
		lsl		r3,	r0												@ align bit for pin#9
		teq		r1,	#0
		streq	r3,	[r2, #40]									@ GPCLR0
		strne	r3,	[r2, #28]									@ GPSET0
		
		mov		pc, lr

@writes a bit to the SNES clock line
Write_Clock:
		//push 	{fp, lr}
		//mov		fp,	sp
		
		mov		r1,	r0
		mov		r0, #11

		ldr		r2,	=label
		ldr		r2, [r2]
		mov 	r3,	#1
		lsl		r3,	r0											@ align bit for pin#11
		teq 	r1,	#0
		streq	r3, [r2, #40]									@ GPCLR0
		strne	r3,	[r2, #28]									@ GPSET0
	
		mov		pc, lr

@reads a bit from the SNES data line
Read_Data:
		push 	{fp, lr}
		mov		fp,	sp
		
		mov		r0,	#10
		
		ldr		r1,	=label
		ldr		r1, [r1]
		ldr		r2,	[r1, #52]									@ GPLEV 0
		mov		r3,	#1
		lsl		r3,	r0												@ align bit for pin#10
		and		r2,	r3												@ mask everything else
		teq		r2,	#0
		moveq	r0,	#0												@ return 0
		movne	r0,	#1												@ return 1
		
		pop		{fp, pc}
		mov		pc, lr

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

@main SNES subroutine that reads input(buttons pressed) from a SNES controller. Returns the code of a pressed button in a register
Read_SNES:
		push 	{r5, r6, lr}
		@mov		fp,	sp
		@sub		sp, #12

		mov		r6,	#0										@r6 is button
		mov		r0,	#1
		bl		Write_Clock
		mov		r0,	#1
		bl		Write_Latch
		mov		r0,	#12
		bl		delayMicroseconds
		mov		r0,	#0
		bl		Write_Latch
		mov		r5,	#0										@r5 = i
		//mov		r6,	#0x0000

pulseLoop:	
		mov		r0,	#6
		bl		delayMicroseconds
		mov		r0,	#0
		bl		Write_Clock
		mov		r0,	#6
		bl		delayMicroseconds
		bl		Read_Data
		
		//cmp		r0,	#1												@ Checks to see if bit is 1 or 0
		//bne		checkBit											
		//mov		r2,	#1												@ This occurs if no button has been pressed
		//lsl		r2,	r5												@ Shift to the correct index, (r5 is i)
		//orr		r6,	r2												@ Add 1 one to index to show that is hasnt been pressed yet
		lsl		r6, #1
		orr		r6, r0
		
		mov		r0,	#1
		bl		Write_Clock
		
		add		r5,	r5,	#1
		
		//ldr		r0, =test1
		//mov		r1, r5
		//bl		printf
		
		cmp		r5,	#16
		blt		pulseLoop
		
		mov		r0,	r6
		
		@add		sp, #12
		pop		{r5, r6, pc}
		@mov		pc, lr
		@bx		lr
			
printB:
		ldr		r0,	=butB
		bl		printf

		b		request

printY:
		ldr		r0,	=butY
		bl		printf

		b		request

printSelect:
		ldr		r0,	=butSelect
		bl		printf

		b		request

printUp:
		ldr		r0,	=butUp
		bl		printf

		b		request

printDown:
		ldr		r0,	=butDown
		bl		printf

		b		request

printLeft:
		ldr		r0,	=butLeft
		bl		printf

		b		request

printRight:
		ldr		r0,	=butRight
		bl		printf

		b		request

printA:
		ldr		r0,	=butA
		bl		printf

		b		request

printX:
		ldr		r0,	=butX
		bl		printf

		b		request

printLb:
		ldr		r0,	=butLb
		bl		printf

		b		request

printRb:
		ldr		r0,	=butRb
		bl		printf

		b		request

printEnd:
		ldr		r0,	=end
		bl		printf

		b		stop

@ Data section
.section    .data

label:
.int		0
names:
.asciz	"Created by: Daniel Nwaroh, Issack John and Steve Khanna\n"

hello:
.asciz	"Hello World!\n"

pressButton:
.asciz	"Please press a button ...\n"

butB:
.asciz	"You have pressed B\n"
butY:
.asciz	"You have pressed Y\n"
butSelect:
.asciz	"You have pressed select\n"
butUp:
.asciz	"You have pressed Joy-pad UP\n"
butDown:
.asciz	"You have pressed Joy-pad DOWN\n"
butLeft:
.asciz	"You have pressed Joy-pad LEFT\n"
butRight:
.asciz	"You have pressed Joy-pad RIGHT\n"
butA:
.asciz	"You have pressed A\n"
butX:
.asciz	"You have pressed X\n"
butLb:
.asciz	"You have pressed LEFT trigger\n"
butRb:
.asciz	"You have pressed RIGHT trigger\n"

end:
.asciz 	"Program is terminating...\n"



