		AREA	MAIN_CODE, CODE, READONLY
		GET		LPC213x.s
		
		ENTRY
__main
__use_two_region_memory
		EXPORT			__main
		EXPORT			__use_two_region_memory


PORT0_PINS      EQU     0xF0

        
      


main_loop
		BL SETUP_PORT0_PINS
		LDR r0, =4
		
		
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
		
		
		
SETUP_PORT0_PINS
		LDR     R0, =IODIR0 
		LDR 	R1,=PORT0_PINS 
		STR     R1, [R0]
		BX lr 
		END
		