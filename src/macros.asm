LineInc_DE      macro

                ; move down a pixel line
                ; H 0-1-0-y7-y6-y2-y1-y0 l y5-y4-y3-x4-x3-x2-x1-x0

                inc d
                ld a, d
                and 7
                jr nz, .q
                ld a, e
                add a, 32
                ld e, a
                jr c, .q
                ld a, d
                sub 8
                ld d, a
.q:

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
