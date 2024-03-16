
//PORTB – Digits_P, PORTD – Segments_P

.equ Digits_P = PORTB
.equ Segments_P = PORTD

.macro LOAD_CONST
    ldi @0, high(@2)
    ldi @1, low(@2)
.endmacro

.macro SET_DIGIT
    push r23
    push r16
    push r17
    ldi r23, @0
    
     
    cpi r23, 0
    brbs 1, Digit1

    cpi r23, 1
    brbs 1, Digit2

    cpi r23, 2
    brbs 1, Digit3

    cpi r23, 3
    brbs 1, Digit4

    Digit1:
    mov r16, Digit_1
    rjmp Finis

    Digit2:
    mov r16, Digit_2
    rjmp Finis

    Digit3:
    mov r16, Digit_3
    rjmp Finis

    Digit4:
    mov r16, Digit_4
    rjmp Finis
    
    Finis:


    ldi r23, (2<<@0)
    out Digits_P, r23


    rcall DigitTo7segCode
    out Segments_P, r16
    
    LOAD_CONST R17,R16,10
    rcall DelayInMs
    pop r17
    pop r16
    pop r23
.endmacro


.macro inkrementacja
    push R20

        inc @1
        ldi R20, 0
    
        cp @1, R20
        breq inkrementacjaL
        
        rjmp InkrementEnd
    
    inkrementacjaL:
        inc @0
    InkrementEnd:

    pop R20
.endmacro




//PROGRAM G£ÓWNY----------------------------------

.def PulseEdgeCtrL=R0
.def PulseEdgeCtrH=R1

mov PulseEdgeCtrL, R16
mov PulseEdgeCtrH, R17


push R21
ldi R21, 127
out DDRD, R21
pop R21


push R20
ldi R20, 63 
out Segments_P, r20
pop R20

//0
.def Digit_1 = r16
.def Digit_2 = r17
.def Digit_3 = r18
.def Digit_4 = r19



clr R0
clr R1

MainLoop:


    //rcall NumberToDigits

    inkrementacja R1, R0
    rcall modulo10000
    mov R16, R0
    mov R17, R1
    rcall NumberToDigits
    SET_DIGIT 0
    SET_DIGIT 1
    SET_DIGIT 2
    SET_DIGIT 3



 rjmp MainLoop

//KONIEC PROGRAMU G£ÓWNEGO ------------------------------

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


DigitTable: .db 63, 6, 91, 79, 102, 109, 125, 7, 127, 111   


DelayInMs:
    push R17
    push R16
    Loop0:      
        rcall DelayOneMs
        DEC R16
        brbc 1, Loop0
        cpi R17, 0
        brbs 1, end
        DEC R17
        rjmp Loop0
    end:
    pop R16
    pop R17
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

NumberToDigits:
    ;*** NumberToDigits ***
    ;input : Number: R16-17
    ;output: Digits: R16-19
    ;internals: X_R,Y_R,Q_R,R_R - see _Divide

    push R22
    push R23
    push R24
    push R25
    ; internals
    .def Dig0=R22 ; Digits temps
    .def Dig1=R23 ;
    .def Dig2=R24 ;
    .def Dig3=R25 

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

    mov R16, Dig0
    mov R17, Dig1
    mov R18, Dig2
    mov R19, Dig3

    pop R25
    pop R24
    pop R23
    pop R22
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
