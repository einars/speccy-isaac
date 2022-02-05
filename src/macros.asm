LineInc_DE      macro

                ; move down a pixel line
                ; H 0-1-0-y7-y6-y2-y1-y0 l y5-y4-y3-x4-x3-x2-x1-x0

                inc d
                ld a, d
                and 7
                jr nz, .lq
                ld a, e
                add a, 32
                ld e, a
                jr c, .lq
                ld a, d
                sub 8
                ld d, a
.lq
                endm

LineInc_HL      macro

                ; move down a pixel line
                ; H 0-1-0-y7-y6-y2-y1-y0 l y5-y4-y3-x4-x3-x2-x1-x0

                inc h
                ld a, h
                and 7
                jr nz, .lq
                ld a, l
                add a, 32
                ld l, a
                jr c, .lq
                ld a, h
                sub 8
                ld h, a
.lq
                endm

jz              macro label
                jr z, label
                endm

jc              macro label
                jr c, label
                endm
                
jnz             macro label
                jr nz, label
                endm

jnc             macro label
                jr nc, label
                endm

pushx           macro
                push hl
                push de
                push bc
                endm

popx            macro
                pop bc
                pop de
                pop hl
                endm


stop            macro 
                di
                push af
                ld a, Color.magenta
                out (254), a
                pop af
                halt
                endm

Add_HL_A        macro
                add a, l
                ld l, a
                adc a, h
                sub l
                ld h, a
                endm

negc            macro
                jp nc, 1f
                neg
1
                endm

cplc            macro
                jp nc, 1f
                cpl
1
                endm
