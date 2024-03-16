
ldi r16, 9
rcall Square
nop

Square:
    ldi R30, low(SquareTable<<1) 
    ldi R31, high(SquareTable<<1)
    add R30, r16
    lpm r16, Z
    ret


SquareTable: .db 0x0, 0x1, 0x4, 0x9, 0x10, 0x19, 0x24, 0x31, 0x40, 0x51   