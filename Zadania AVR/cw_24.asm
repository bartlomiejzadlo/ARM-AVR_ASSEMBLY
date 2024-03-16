MainLoop:
ldi R27, 20
rcall DelayInMs
nop
rjmp MainLoop

DelayInMs:
    Loop0: 
        rcall DelayOneMs
        DEC R27
        nop
        brbc 1, Loop0
    ret


DelayOneMs:
    ldi R27, 7
    ldi R26, 205
    Loop_01:
        sbiw X,1 // X (r26:r27)
        brbc 1, Loop_01
    ret

/*

ldi R27, 7
        ldi R26, 207
        Loop1:
            sbiw X,1 // X (r26:r27)
            brbc 1, Loop1 
   */