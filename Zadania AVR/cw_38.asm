
ldi r16, 9
rcall DigitTo7segCode
nop

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