		AREA	MAIN_CODE, CODE, READONLY
		GET		LPC213x.s
		
		ENTRY
__main
__use_two_region_memory
		EXPORT			__main
		EXPORT			__use_two_region_memory


PORT0_DISPLAY_DIR      	EQU     0xF0000
PORT1_SEGMENTS_DIR		EQU 	0xFF0000
PIN0_DISPLAY_1 			EQU 	0x80000
DISPLAY_SEGMENTS 		EQU		0x6F0000
SEGMENT_CODE			RN 	R6	
DIGIT_0					RN	R8
DIGIT_1					RN	R9
DIGIT_2					RN	R10
DIGIT_3					RN	R11
CURRENT_DIGIT        	RN  r12 

main_loop
		BL SETUP_DISPLAY_AND_SEGMENTS 
		LDR CURRENT_DIGIT,=0 
		
		LDR DIGIT_0,=0
		LDR DIGIT_1,=1
		LDR DIGIT_2,=2
		LDR DIGIT_3,=3
		
Loop
		BL CLEAR_DISPLAY
		
		
		

		

		LDR R4,=PIN0_DISPLAY_1
		MOV   R4, R4 , LSR CURRENT_DIGIT 
		
		
		CMP CURRENT_DIGIT, #0
		MOVEQ SEGMENT_CODE, DIGIT_0
		
		CMP CURRENT_DIGIT, #1
		MOVEQ SEGMENT_CODE, DIGIT_1
		
		CMP CURRENT_DIGIT, #2
		MOVEQ SEGMENT_CODE, DIGIT_2
		
		CMP CURRENT_DIGIT, #3
		MOVEQ SEGMENT_CODE, DIGIT_3
		
		BL DIGIT_TO_7_SEG_CODE
		

		BL DISPLAY_NUMBER
		

		ADD CURRENT_DIGIT, #1 
		CMP CURRENT_DIGIT, #4
		EOREQ CURRENT_DIGIT, #4 
		

		LDR r0, =5;
		BL delay_in_ms  
		
		b				Loop

	
delay_in_ms 
		LDR     r5,=12000 
		MUL r5, r0, r5
DelayLoop
		SUBS    r5, r5, #1
		CMP r5, #0
        BNE DelayLoop
		BX      lr          

DIGIT_TO_7_SEG_CODE

		ADR R7, SegmentTable
		ADD R7, SEGMENT_CODE
		LDRB SEGMENT_CODE, [R7]
		BX 		lr

CLEAR_DISPLAY 
		ldr r0, =IO0CLR
		ldr r1, =0xF0000
		str r1, [r0]
		
		BX lr
		
SETUP_DISPLAY_AND_SEGMENTS
		LDR     R0, =IODIR0
		LDR 	R1,=PORT0_DISPLAY_DIR
		STR     R1, [R0]
		LDR		R0,=IODIR1
		LDR		R1,=PORT1_SEGMENTS_DIR
		STR     R1, [R0]
		BX lr

DISPLAY_NUMBER

		ldr r0, = IO1CLR
		ldr r1, =0xFF0000
		str r1, [r0]
		
		LDR     R0, =IOSET0
		STR     R4, [R0]
		
		LDR		R0,=IOSET1
		
		MOV 	R1, SEGMENT_CODE, LSL #16
		STR     R1, [R0]
		BX lr
		
SegmentTable	DCB		0x3f,0x06,0x5B,0x4F,0x66,0x6d,0x7D,0x07,0xff,0x6f 
		NOP
		END