
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



.macro LOAD_CONST
    ldi @0, high(@2)
    ldi @1, low(@2)
.endmacro


ldi r19, 30
clr R20

out DDRB, r19 

LOAD_CONST R17,R16,5

MainLoop:
out PORTB, r19
rcall DelayInMs
out PORTB, r20
rcall DelayInMs
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


