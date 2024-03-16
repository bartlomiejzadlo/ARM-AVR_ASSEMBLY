MainLoop:
ldi R27, 20
rcall DelayInMs
nop
rjmp MainLoop

DelayInMs:
    Loop0: 
        rcall DelayOneMs
        DEC R27
        brbc 1, Loop0
    ret


DelayOneMs:
    push R27
    push R26
    ldi R27, 7
    ldi R26, 205
    Loop_01:
        sbiw X,1 // X (r26:r27)
        brbc 1, Loop_01
    pop R26
    pop R27
    ret

/*

ldi R27, 7
        ldi R26, 207
        Loop1:
            sbiw X,1 // X (r26:r27)
            brbc 1, Loop1 
   */