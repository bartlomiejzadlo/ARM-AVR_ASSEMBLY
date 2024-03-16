
MainLoop:
ldi R16, 20
ldi R17, 0
rcall DelayInMs
nop
rjmp MainLoop

DelayInMs:
    push R17
    push R16
    Loop0: 
        brbs 4, end
        rcall DelayOneMs
        DEC R16
        brbc 1, Loop0
        DEC R17
        brbs 4, end
        brbc 1, Loop0
    end:
    pop R16
    pop R17
    ret


DelayOneMs:
    push R27
    push R26
    ldi R27, 7 ; 7
    ldi R26, 205 ; 205
    Loop_01:
        sbiw X,1 // X (r26:r27)
        brbc 1, Loop_01
    pop R26
    pop R27
    ret
