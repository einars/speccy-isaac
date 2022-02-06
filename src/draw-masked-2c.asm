
m2_prelude      macro
                ld a, (hl)
                inc hl
                ld b, (hl)
                inc hl
                ld c, 0xff
                endm

m2_intermission macro
                ex de, hl
                and (hl)
                exx
                ld e, a
                exx
                inc l
                ld a, (hl)
                and b
                exx
                ld d, a
                exx
                inc l
                ld a, (hl)
                and c
                exx
                ld c, a
                exx

                dec l
                dec l
                ex de, hl


                ld a, (hl)
                inc hl
                ld b, (hl)
                inc hl
                ld c, 0
                endm
                
                
m2_finish       macro
                ex de, hl
                exx
                or e
                exx
                ld (hl), a
                inc l
                ld a, b
                exx
                or d
                exx
                ld (hl), a
                inc l
                ld a, c
                exx
                or c
                exx
                ld (hl), a
                dec l
                dec l
                ex de, hl

                LineInc_DE


                endm
                ; HL - sprite
                ; DE - screen address
                ; B - height
                ; C - bit offset

                ; on return:
                ; everything messed up

double_column_masked:
                ld a, c
                add a, c
                add a, c
                ld (.again+1), a

                ld a, b ; line counter will live in a'
.again          jr $
                ; jump table to implementations
                jp .m0
                jp .m1
                jp .m2
                jp .m3
                jp .m4
                jp .m5
                jp .m6
                jp .m7


.m0            
                ex af, af'
                ; hl - sprite
                ; de - screen

                ld b, (hl)
                inc hl
                ld c, (hl)
                inc hl


                ld a, (de)
                and b
                or (hl)
                ld (de), a


                inc hl
                inc e

                ld a, (de)
                and c
                or (hl)
                ld (de), a

                inc hl
                dec e

                LineInc_DE

                ex af, af'
                dec a
                jnz .m0

                ret

.m1 ;=================================================
                ex af, af'

                m2_prelude

                rra
                rr b
                rr c

                or 0b10000000

                m2_intermission

                rra
                rr b
                rr c
                and 0b01111111

                m2_finish

                ex af, af'
                dec a
                jnz .m1

                ret

.m2 ;=================================================

                ex af, af'

                m2_prelude

                dup 2
                  rra
                  rr b
                  rr c
                edup

                or 0b11000000

                m2_intermission

                dup 2
                  rra
                  rr b
                  rr c
                edup

                and 0b00111111

                m2_finish

                ex af, af'
                dec a
                jnz .m2

                ret


.m3 ;=================================================

                ex af, af'

                m2_prelude

                dup 3
                  rra
                  rr b
                  rr c
                edup

                or 0b11100000

                m2_intermission

                dup 3
                  rra
                  rr b
                  rr c
                edup

                and 0b00011111

                m2_finish

                ex af, af'
                dec a
                jnz .m3

                ret


.m4 ;=================================================

                ex af, af'

                m2_prelude

                dup 4
                  rra
                  rr b
                  rr c
                edup

                or 0b11110000

                m2_intermission

                dup 4
                  rra
                  rr b
                  rr c
                edup

                and 0b00001111

                m2_finish

                ex af, af'
                dec a
                jnz .m4

                ret


.m5 ;=================================================

                ex af, af'

                m2_prelude

                dup 5
                  rra
                  rr b
                  rr c
                edup

                or 0b11111000

                m2_intermission

                dup 5
                  rra
                  rr b
                  rr c
                edup

                and 0b00000111

                m2_finish

                ex af, af'
                dec a
                jnz .m5

                ret


.m6 ;=================================================

                ex af, af'

                m2_prelude

                dup 6
                  rra
                  rr b
                  rr c
                edup

                or 0b11111100

                m2_intermission

                dup 6
                  rra
                  rr b
                  rr c
                edup

                and 0b00000011

                m2_finish

                ex af, af'
                dec a
                jnz .m6

                ret


.m7 ;=================================================

                ex af, af'

                m2_prelude

                dup 7
                  rra
                  rr b
                  rr c
                edup

                or 0b11111110

                m2_intermission

                dup 7
                  rra
                  rr b
                  rr c
                edup

                and 0b00000001

                m2_finish

                ex af, af'
                dec a
                jnz .m7

                ret

