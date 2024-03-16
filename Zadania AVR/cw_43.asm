;*** NumberToDigits ***
;input : Number: R16-17
;output: Digits: R16-19
;internals: X_R,Y_R,Q_R,R_R - see _Divide


.macro LOAD_CONST
    ldi @0, high(@2)
    ldi @1, low(@2)
.endmacro



LOAD_CONST R17, R16, 1
nop
rcall NumberToDigits

nop
nop


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
        brlo end
        breq Hequal

        sub XL,YL
        brcs XLlower
        sub XH, YH

        brbs 0, end
        adiw QCtrH:QCtrL, 1
        rjmp Loop

        Hequal:
        cp XL, YL
        brlo end
        adiw QCtrH:QCtrL, 1
        sub XH, YH
        sub XL, YL
        cpi XL, 0
        breq end
        rjmp Loop

        XLlower:
        subi XH, 1
        sub XH, YH
        adiw QCtrH:QCtrL, 1
        rjmp Loop
    end:

    mov QH, QCtrH
    mov QL, QCtrL
    
    pop QctrH
    pop QctrL
ret