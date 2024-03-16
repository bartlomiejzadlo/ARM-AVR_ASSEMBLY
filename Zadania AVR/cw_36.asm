
nop
nop
ldi R30, low(Table<<1) 
ldi R31, high(Table<<1)
lpm R20, Z 

adiw R30:R31,1 
lpm R21, Z 

adiw R30:R31,1 
lpm R22, Z 
adiw R30:R31,1 
lpm R23, Z 
nop
Table: .db 0x57, 0x58, 0x59, 0x5A 