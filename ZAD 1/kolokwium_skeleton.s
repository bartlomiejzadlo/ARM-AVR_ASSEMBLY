		AREA	MAIN_CODE, CODE, READONLY
		GET		LPC213x.s
		
		ENTRY
__main
__use_two_region_memory
		EXPORT			__main
		EXPORT			__use_two_region_memory


main_loop
		BL Delay
		b				main_loop

	
Delay   
		LDR     r8,=1000
DelayLoop
		SUBS    r8, r8, #1
		CMP r8, #0
        BNE DelayLoop
		BX      lr                ; Return from subroutine
		
		END