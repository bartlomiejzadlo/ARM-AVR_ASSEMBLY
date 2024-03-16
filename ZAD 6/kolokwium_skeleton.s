		AREA	MAIN_CODE, CODE, READONLY
		GET		LPC213x.s
		
		ENTRY
__main
__use_two_region_memory
		EXPORT			__main
		EXPORT			__use_two_region_memory


PORT0_DISPLAY_DIR      	EQU     0xF0000
PORT1_SEGMENTS_DIR		EQU 	0xFF00000
PIN0_DISPLAY_1 		EQU 	0x80000
DISPLAY_SEGMENTS 		EQU		0x6F0000
CURRENT_DIGIT        RN  r12  

main_loop
		BL SETUP_DISPLAY_AND_SEGMENTS
		LDR CURRENT_DIGIT,=0
		
		
Loop
		BL CLEAR_DISPLAY
		
		BL DISPLAY_NUMBER
		
		ADD CURRENT_DIGIT, #1 
		
		CMP CURRENT_DIGIT, #4
		EOREQ CURRENT_DIGIT, #4 
		
		LDR R4,=PIN0_DISPLAY_1
		MOV   R4, R4 , ASR CURRENT_DIGIT
		


		
		LDR r0, =500
		BL delay_in_ms  
		b				Loop

	
delay_in_ms  
		LDR     r8,=12000
		MUL r8, r0, r8
DelayLoop
		SUBS    r8, r8, #1
		CMP r8, #0
        BNE DelayLoop
		BX      lr  
		
CLEAR_DISPLAY 
		ldr r6, =IO0CLR
		ldr r5, =0xF0000
		str r5, [r6]
		BX lr
		
SETUP_DISPLAY_AND_SEGMENTS
		LDR     R0, =IODIR0
		LDR 	R1,=PORT0_DISPLAY_DIR
		STR     R1, [R0]
		LDR		R0,=IO1DIR
		LDR		R1,=PORT1_SEGMENTS_DIR
		STR     R1, [R0]
		BX lr

DISPLAY_NUMBER

		LDR     R0, =IOSET0
		STR     R4, [R0]
		
		LDR		R0,=IOSET1
		LDR 	R1,=DISPLAY_SEGMENTS
		STR     R1, [R0]
		
		BX lr
		END
		