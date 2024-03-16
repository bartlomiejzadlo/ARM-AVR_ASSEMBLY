;*** Divide ***
; X/Y -> Quotient,Remainder
; Input/Output: R16-19, Internal R24-25


.macro LOAD_CONST
    ldi @0, high(@2)
    ldi @1, low(@2)
.endmacro


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




LOAD_CONST R17,R16,1200
LOAD_CONST R19,R18,500
rcall Divide
nop



Divide:
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