		AREA	MAIN_CODE, CODE, READONLY
		GET		LPC213x.s
		
		ENTRY
__main
__use_two_region_memory
		EXPORT			__main
		EXPORT			__use_two_region_memory


PORT0_DISPLAY_DIR      	EQU     0xF0000 ;piny 16-19 portu 0
PORT1_SEGMENTS_DIR		EQU 	0xFF0000 ;piny 16-23 portu 1
PIN0_SET_DISPLAY 		EQU 	0x20000;IOPIN0 ;ustawienie pinu 17 portu 0 na jedynke 
DISPLAY_SEGMENTS 		EQU		0x6F0000; liczba 9, ustawiona jedynkami w porcie 1


main_loop
		BL SETUP_DISPLAY_AND_SEGMENTS
		BL DISPLAY_NUMBER
		LDR r0, =4; 1 krok
		
		
Loop
		BL delay_in_ms  
		b				Loop

	
delay_in_ms  
		LDR     r8,=12000000 
		MUL r8, r0, r8
DelayLoop
		SUBS    r8, r8, #1
		CMP r8, #0
        BNE DelayLoop
		BX      lr                
		
		
		
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
		LDR 	R1,=PIN0_SET_DISPLAY 
		STR     R1, [R0] 
		LDR		R0,=IOSET1 
		LDR 	R1,=DISPLAY_SEGMENTS
		STR     R1, [R0]
		BX lr
		END
		