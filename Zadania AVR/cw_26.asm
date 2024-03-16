MainLoop:
ldi R27, 40
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
    sts 0x60, R27
    sts 0x61, R26
    ldi R27, 7
    ldi R26, 205
    Loop_01:
        sbiw X,1 // X (r26:r27)
        brbc 1, Loop_01
    lds R27, 0x60
    lds R26, 0x61
    ret

/*

ldi R27, 7
        ldi R26, 207
        Loop1:
            sbiw X,1 // X (r26:r27)
            brbc 1, Loop1 
   */