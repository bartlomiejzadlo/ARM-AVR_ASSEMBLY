 ;### MACROS & defs (.equ)###

; Macro LOAD_CONST loads given registers with immediate value, example: LOAD_CONST  R16,R17 1234 
.MACRO LOAD_CONST  
 ldi @0, high(@2)
 ldi @1, low(@2); TBD
.ENDMACRO 

/*** Display ***/
.equ DigitsPort = PORTB             ; TBD
.equ SegmentsPort = PORTD           ; TBD
.equ DisplayRefreshPeriod = 5   ; TBD

; SET_DIGIT diplay digit of a number given in macro argument, example: SET_DIGIT 2
.MACRO SET_DIGIT  
    push R16
    ldi R16, $2 << @0
    OUT DDRB, R16
    OUT DigitsPort, R16
    mov R16, Dig_@0
    rcall DigitTo7segCode
    OUT DDRD, R16
    OUT SegmentsPort, R16
    pop R16
    rcall DelayInMs  ; TBD
.ENDMACRO 

; ### GLOBAL VARIABLES ###

.def PulseEdgeCtrL=R0
.def PulseEdgeCtrH=R1

.def Dig_0=R2
.def Dig_1=R3
.def Dig_2=R4
.def Dig_3=R5

; ### INTERRUPT VECTORS ###
.cseg		     ; segment pamiêci kodu programu 

.org	 0      rjmp	_main	 ; skok do programu g³ównego
.org OC1Aaddr	rjmp _Timer_ISR  ; TBD
.org PCIaddr   rjmp _ExtInt_ISR  ; TBD ; skok do procedury obs³ugi przerwania zenetrznego 

; ### INTERRUPT SEERVICE ROUTINES ###

_ExtInt_ISR: 	 ; procedura obs³ugi przerwania zewnetrznego

    push R12
    push R11
    push R16
    IN R12, SREG
    ldi R16, 1
    mov R10, R16
    clr R11
    add PulseEdgeCtrL, R10
    adc PulseEdgeCtrH, R11
    OUT SREG, R12
    pop R16
    pop R11
    pop R12; TBD

reti   ; powrót z procedury obs³ugi przerwania (reti zamiast ret)      

_Timer_ISR:
    push R16
    push R17
    push R18
    push R19

    push R12
    IN R12, SREG
    movw R17:R16, PulseEdgeCtrH:PulseEdgeCtrL
    ldi R18, low(10000)
    ldi R19, high(10000)
    rcall _Divide
    rcall _NumberToDigits
    mov Dig_0, R16
    mov Dig_1, R17
    mov Dig_2, R18
    mov Dig_3, R19
    clr PulseEdgeCtrL
    clr PulseEdgeCtrH
    OUT SREG, R12
    pop R12 ; TBD

	pop R19
    pop R18
    pop R17
    pop R16

  reti

; ### MAIN PROGAM ###

_main: 
    ; *** Initialisations ***

    ;--- Ext. ints --- PB0
    push R17
    ldi R17, $20
    OUT GIMSK, R17
    ldi R17, $01
    OUT PCMSK, R17; TBD

	;--- Timer1 --- CTC with 256 prescaller
    ldi R17, $0C
    OUT TCCR1B, R17
    ldi R17, $1E
    OUT OCR1AH, R17
    ldi R17, $84
    OUT OCR1AL, R17
    ldi R17, $40
    OUT TIMSK, R17; TBD
			
	;---  Display  --- 
    ;NIC
	; --- enable gloabl interrupts
    SEI; TBD

MainLoop:   ; presents Digit0-3 variables on a Display
			SET_DIGIT 0
			SET_DIGIT 1
			SET_DIGIT 2
			SET_DIGIT 3

			RJMP MainLoop

; ### SUBROUTINES ###

;*** NumberToDigits ***
;converts number to coresponding digits
;input/otput: R16-17/R16-19
;internals: X_R,Y_R,Q_R,R_R - see _Divider

; internals
.def Dig0=R22 ; Digits temps
.def Dig1=R23 ; 
.def Dig2=R24 ; 
.def Dig3=R25 ; 

_NumberToDigits:

	push Dig0
	push Dig1
	push Dig2
	push Dig3

	; thousands 
    ldi R18, 0xE8
    ldi R19, 0x03
    rcall _Divide
    mov Dig0, R18 ; TBD

	; hundreads 
    ldi R18, 0x64
    ldi R19, 0x00
    rcall _Divide
    mov Dig1, R18; TBD     

	; tens 
    ldi R18, 0x0A
    ldi R19, 0x00
    rcall _Divide
    mov Dig2, R18; TBD    

	; ones 
    mov Dig3, R16; TBD

	; otput result
	mov R16,Dig0
	mov R17,Dig1
	mov R18,Dig2
	mov R19,Dig3

	pop Dig3
	pop Dig2
	pop Dig1
	pop Dig0

	ret

;*** Divide ***
; divide 16-bit nr by 16-bit nr; X/Y -> Qotient,Reminder
; Input/Output: R16-19, Internal R24-25

; inputs
.def XL=R16 ; divident  
.def XH=R17 

.def YL=R18 ; divider
.def YH=R19 

; outputs

.def RL=R16 ; reminder 
.def RH=R17 

.def QL=R18 ; quotient
.def QH=R19 

; internal
.def QCtrL=R24
.def QCtrH=R25

_Divide:push R24 ;save internal variables on stack
        push R25
		
        ldi QCtrL, 0x00 ; TBD
        ldi QCtrH, 0x00

        rjmp comparing
        subtration:
        sub XL, YL
        sbc XH, YH
        adiw QCtrH:QCtrL, 1
        comparing:
        cp XL, YL
        cpc XH, YH
        brsh subtration
        mov QL, QCtrL
        mov QH, QCtrH
		pop R25 ; pop internal variables from stack
		pop R24

		ret

; *** DigitTo7segCode ***
; In/Out - R16

Table: .db 0x3f,0x06,0x5B,0x4F,0x66,0x6d,0x7D,0x07,0xff,0x6f

DigitTo7segCode:

push R30
push R31

    ldi R30, low(Table << 1)
    ldi R31, high(Table << 1)
    add R30, R16
    lpm R16, Z
    ; TBD

pop R31
pop R30

ret

; *** DelayInMs ***
; In: R16,R17
DelayInMs:  
            push R24
			push R25
            
            LOAD_CONST R25,R24, DisplayRefreshPeriod
        Start:
            sbiw R25:R24, 1
            breq end_01
            rcall OneMsLoop
            rjmp Start
            ; TBD
        end_01:
			pop R25
			pop R24

			ret

; *** OneMsLoop ***
OneMsLoop:	
			push R24
			push R25 
			
			LOAD_CONST R25,R24,2000                    

L1:			SBIW R24:R25,1 
			BRNE L1

			pop R25
			pop R24

			ret



