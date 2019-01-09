

@ Code section
.section .text

.global	DrawMenu
DrawMenu:
		push 	{lr}
		
		mov		r0,	#160
		mov		r1,	#200
		ldr		r2,	=0xF0F0
		ldr		r3,	=MainMenu
		//bl		DrawSentence
		
		pop	{pc}


@ Data section
.section .data

.global MainMenu
MainMenu:
.asciz	"Main Menu"




