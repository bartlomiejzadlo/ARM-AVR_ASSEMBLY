
; Define pull-ups and set outputs high
; Define directions for port pins
;ldi r16,(1<<PB4)|(1<<PB1)|(1<<PB0)
;ldi r17,(1<<DDB3)|(1<<DDB2)|(1<<DDB1)|(1<<DDB0)
;out PORTB,r16
;out DDRB,r17
; Insert nop for synchronization
;nop
; Read port pins
;in r16,PINB


//PORTB – Digits_P, PORTD – Segments_P

.equ Digits_P = PORTB
.equ Segments_P = PORTD
.macro LOAD_CONST
    ldi @0, high(@2)
    ldi @1, low(@2)
.endmacro



ldi R21, 127
out DDRD, R21

ldi R20, 63 
out Segments_P, r20


.equ Digit_1 = 9
.equ Digit_2 = 8
.equ Digit_3 = 7
.equ Digit_4 = 6





LOAD_CONST R17,R16,5

out Segments_P, r20

MainLoop:

ldi r23, 2
out Digits_P, r23
ldi r16, Digit_1
rcall DigitTo7segCode
out Segments_P, r16
LOAD_CONST R17,R16,5
rcall DelayInMs

ldi r23, 4
out Digits_P, r23
ldi r16, Digit_2
rcall DigitTo7segCode
out Segments_P, r16
LOAD_CONST R17,R16,5
rcall DelayInMs

ldi r23,8
out Digits_P, r23
ldi r16, Digit_3
rcall DigitTo7segCode
out Segments_P, r16
LOAD_CONST R17,R16,5
rcall DelayInMs

ldi r23, 16
out Digits_P, r23
ldi r16, Digit_4
rcall DigitTo7segCode
out Segments_P, r16
LOAD_CONST R17,R16,5
rcall DelayInMs

rjmp MainLoop


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

