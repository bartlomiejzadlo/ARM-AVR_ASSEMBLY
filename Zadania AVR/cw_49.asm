;DEFINITIONS
.equ Digits_P = PORTB
.equ Segments_P = PORTD

.def PulseEdgeCtrL=R0
.def PulseEdgeCtrH=R1
.def Digit_0 = r16
.def Digit_1 = r17
.def Digit_2 = r18
.def Digit_3 = r19


;*** Divide ***
; X/Y -> Quotient,Remainder
; Input/Output: R16-19, Internal R24-25
; inputs
.def XL=R16 ; divident 
.def XH=R17 
.def YL=R18 ; divisor
.def YH=R19 
; outputs
.def RL=R16 ; remainder 
.def RH=R17 
.def QL=R18 ; quotient
.def QH=R19 
; internal
.def QCtrL=R24
.def QCtrH=R25

	;*** NumberToDigits ***
;input : Number: R16-17
;output: Digits: R16-19
;internals: X_R,Y_R,Q_R,R_R - see _Divide
; internals

.def Dig0=R22 ; Digits temps
.def Dig1=R23 ; 
.def Dig2=R24 ; 
.def Dig3=R25 ;

;MACROS

.macro LOAD_CONST

	ldi @0, high(@2)
	ldi @1, low(@2)
.endmacro

.macro SET_DIGIT
    push r23
    push r16
    push r17
    
    mov r16, Digit_@0


    ldi r23, (2<<@0)
    out Digits_P, r23


    rcall DigitTo7segCode
    out Segments_P, r16

    pop r17
    pop r16
    pop r23
    rcall DelayInMs
.endmacro


;END OF DEFINITIONS AND MACROS

.cseg ; code segment

.org 0 rjmp _main ; reset
.org OC1Aaddr rjmp _timer_isr ; timer1
.org PCIaddr rjmp _pcint_isr


_timer_isr: ; procedura obs³ugi przerwania timera
    
    push R12
    in R12, SREG

    mov XH, PulseEdgeCtrH
	mov XL, PulseEdgeCtrL
	clr PulseEdgeCtrL
	clr PulseEdgeCtrH

    out SREG,r12
    pop r12

    

    rcall NumberToDigits
reti 

_pcint_isr:
    push r19
    push r18

    push R12
    in R12, SREG ;

	;ldi r20, 0b100000
	;out GIFR, r20

	rcall Increment
	;rcall modulo10000
    
    out SREG,r12
    pop r12

    pop r18
    pop r19
reti
	;SUBROUTINES

Increment:
	
	push r27
	push r28

	ldi r27, 1
	clr r28
	add r0, r27
	adc r1, r28

	pop r28
	pop r27

ret

DelayInMs:
            push R24
			push R25
            LOAD_CONST R25, R24, 5
    Start:
        sbiw R25:R24, 1 
            breq End_1 
            rcall DelayOneMs 
            rjmp Start
    End_1:

			pop R25
			pop R24

			ret

DelayOneMs:
    push R27
    push R26
    LOAD_CONST R27,R26, 1996

    Loop_01:
        sbiw X,1 // X (r26:r27)
        brbc 1, Loop_01

    pop R26
    pop R27
 ret

DigitTo7segCode:
    push r30
    push r31

    ldi R30, low(DigitTable<<1)
    ldi R31, high(DigitTable<<1)

    add R30, r16
    lpm r16, Z

    pop r31
    pop r30
ret

Divide:
    ;*** Divide ***
    ; X/Y -> Quotient,Remainder
    ; Input/Output: R16-19, Internal R24-25
    ; inputs
    .def XL=R16 ; divident
    .def XH=R17

    .def YL=R18 ; divisor
    .def YH=R19

    ; outputs

    .def RL=R16 ; remainder
    .def RH=R17

    .def QL=R18 ; quotient
    .def QH=R19
    .def QCtrL=R24
    .def QCtrH=R25

    push QctrL
    push QctrH

    LOAD_CONST QCtrH, QCtrL, 0 
    Loop:
        cp XH, YH
        brlo DivideEnd
        breq Hequal

        sub XL,YL
        brcs XLlower
        sub XH, YH

        brbs 0, DivideEnd
        adiw QCtrH:QCtrL, 1
        rjmp Loop

        Hequal:
        cp XL, YL
        brlo DivideEnd
        adiw QCtrH:QCtrL, 1
        sub XH, YH
        sub XL, YL
        cpi XL, 0
        breq DivideEnd
        rjmp Loop

        XLlower:
        subi XH, 1
        sub XH, YH
        adiw QCtrH:QCtrL, 1
        rjmp Loop
    DivideEnd:

    mov QH, QCtrH
    mov QL, QCtrL
    
    pop QctrH
    pop QctrL
ret

NumberToDigits:
    ;*** NumberToDigits ***
    ;input : Number: R16-17
    ;output: Digits: R16-19
    ;internals: X_R,Y_R,Q_R,R_R - see _Divide
    ; internals


    push Dig0
	push Dig1
	push Dig2
	push Dig3


    LOAD_CONST R19, R18, 1000 ; Divisor
    rcall Divide
    mov Dig0, R18

    LOAD_CONST R19, R18, 100 ; Divisor
    rcall Divide
    mov Dig1, R18

    LOAD_CONST R19, R18, 10 ; Divisor
    rcall Divide
    mov Dig2, R18
    mov Dig3, R16

    mov Digit_0, Dig0
    mov Digit_1, Dig1
    mov Digit_2, Dig2
    mov Digit_3, Dig3

    pop Dig3
    pop Dig2
    pop Dig1
    pop Dig0

ret

modulo10000:
    push R18
    push R19
    push R17
    push R16

    mov R16, R0
    mov R17, R1

    LOAD_CONST R19, R18, 10000
    rcall Divide

    mov R0, R16
    mov R1, R17

    pop R16
    pop R17
    pop R18
    pop R19    
ret




.macro SET_OCR1A
    push R27
    push R26
    LOAD_CONST R27,R26, @0
    out OCR1AH, R27
    out OCR1AL, R26
    pop R26
    pop R27
.endmacro

SET_OCIE1A:
    push R20
    ldi R20, $40; 40 = 64
    out TIMSK, R20
    pop R20
ret


SET_CTC_MODE_AND_PRESCALAR_256:
    CLI
    push R20
    ldi R20, $0C; C=12
    out TCCR1B, R20
    pop R20
    SEI
ret


;_startMain

_main:
	
	sei
    SET_OCR1A 15625
    rcall SET_OCIE1A
	rcall SET_CTC_MODE_AND_PRESCALAR_256
	
	;ldi r16, 0b100000
	;out GIMSK, r16
	;ldi r16, 0b1
	;out PCMSK, r16


    ;external interrupt init
    in R16, GIMSK
    ori R16,(1<<PCIE0)
    out GIMSK, R16

    in R16, PCMSK0
    ori R16,(1<<PCINT0)
    out PCMSK0, R16

	ldi R17, 0x7F ; 0111 1111
	ldi R16, 0x1E ; 0001 1110
	out DDRD, R17 ; 7 output pins for displaying segments (D)
	out DDRB, R16 ; 4 output pins for displaying digits (B)

    ;digits to be displayed
	ldi r16, 0 ;left one
	mov Digit_3, r16
	mov Digit_2, r16
	mov Digit_1, r16
	mov Digit_0, r16 


MainLoop:

	SET_DIGIT 0
	SET_DIGIT 1
	SET_DIGIT 2
	SET_DIGIT 3

rjmp MainLoop

;_endMain
DigitTable: .db 63, 6, 91, 79, 102, 109, 125, 7, 127, 111