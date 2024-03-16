.macro LOAD_CONST
    ldi @0, high(@2)
    ldi @1, low(@2)
.endmacro

LOAD_CONST R17,R16,2

MainLoop:
    
    rcall DelayInMs
    nop
rjmp MainLoop

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


