
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
    
    LOAD_CONST R17,R16,3
    rcall DelayInMs
    pop r17
    pop r16
    pop r23
.endmacro


ldi R21, 127
out DDRD, R21

ldi R20, 63 
out Segments_P, r20


.def Digit_1 = r16
.def Digit_2 = r17
.def Digit_3 = r18
.def Digit_4 = r19
ldi r22, 10



MainLoop:
    SET_DIGIT 0
    SET_DIGIT 1
    SET_DIGIT 2
    SET_DIGIT 3
    inc Digit_4
    cp Digit_4, r22 
    brne noteq4 
    
    clr Digit_4
    inc Digit_3
    cp Digit_3, r22 
    brne noteq4

    clr Digit_3
    inc Digit_2
    cp Digit_2, r22 
    brne noteq4
    
    clr Digit_2
    
    inc Digit_1
    cp Digit_1, r22
    brne noteq4
    clr Digit_1
    noteq4:
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

