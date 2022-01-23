
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
                inc de

                ld a, (de)
                and c
                or (hl)
                ld (de), a

                inc hl
                dec de

                LineInc_DE

                ex af, af'
                dec a
                jnz .m0

                ret

.m1 ;=================================================
                ex af, af'

                ld a, (hl)
                inc hl
                ld b, (hl)
                inc hl
                ld c, 0xff
                rra
                rr b
                rr c

                or 0b10000000

                ex de, hl
                and (hl)
                ld (hl), a
                inc hl
                ld a, (hl)
                and b
                ld (hl), a
                inc hl
                ld a, (hl)
                and c
                ld (hl), a

                dec hl
                dec hl
                ex de, hl


                ld a, (hl)
                inc hl
                ld b, (hl)
                inc hl
                ld c, 0
                rra
                rr b
                rr c
                and 0b01111111

                ex de, hl
                or (hl)
                ld (hl), a
                inc hl
                ld a, (hl)
                or b
                ld (hl), a
                inc hl
                ld a, (hl)
                or c
                ld (hl), a
                dec hl
                dec hl
                ex de, hl

                LineInc_DE

                ex af, af'
                dec a
                jnz .m1

                ret

.m2 ;=================================================

                ex af, af'

                ld a, (hl)
                inc hl
                ld b, (hl)
                inc hl
                ld c, 0xff
                rra
                rr b
                rr c

                rra
                rr b
                rr c

                or 0b11000000

                ex de, hl
                and (hl)
                ld (hl), a
                inc hl
                ld a, (hl)
                and b
                ld (hl), a
                inc hl
                ld a, (hl)
                and c
                ld (hl), a

                dec hl
                dec hl
                ex de, hl


                ld a, (hl)
                inc hl
                ld b, (hl)
                inc hl
                ld c, 0

                rra
                rr b
                rr c

                rra
                rr b
                rr c

                and 0b00111111

                ex de, hl
                or (hl)
                ld (hl), a
                inc hl
                ld a, (hl)
                or b
                ld (hl), a
                inc hl
                ld a, (hl)
                or c
                ld (hl), a
                dec hl
                dec hl
                ex de, hl

                LineInc_DE

                ex af, af'
                dec a
                jnz .m2

                ret





.m3 ;=================================================
                ex af, af'

                ld a, (hl)
                inc hl
                ld b, (hl)
                inc hl
                ld c, 0xff
                rra
                rr b
                rr c

                rra
                rr b
                rr c

                rra
                rr b
                rr c

                or 0b11100000

                ex de, hl
                and (hl)
                ld (hl), a
                inc hl
                ld a, (hl)
                and b
                ld (hl), a
                inc hl
                ld a, (hl)
                and c
                ld (hl), a

                dec hl
                dec hl
                ex de, hl


                ld a, (hl)
                inc hl
                ld b, (hl)
                inc hl
                ld c, 0

                rra
                rr b
                rr c

                rra
                rr b
                rr c

                rra
                rr b
                rr c

                and 0b00011111

                ex de, hl
                or (hl)
                ld (hl), a
                inc hl
                ld a, (hl)
                or b
                ld (hl), a
                inc hl
                ld a, (hl)
                or c
                ld (hl), a
                dec hl
                dec hl
                ex de, hl

                LineInc_DE

                ex af, af'
                dec a
                jnz .m3

                ret

.m4 ;=================================================
                ex af, af'

                ld a, (hl)
                inc hl
                ld b, (hl)
                inc hl
                ld c, 0xff
                rra
                rr b
                rr c

                rra
                rr b
                rr c

                rra
                rr b
                rr c

                rra
                rr b
                rr c

                or 0b11110000

                ex de, hl
                and (hl)
                ld (hl), a
                inc hl
                ld a, (hl)
                and b
                ld (hl), a
                inc hl
                ld a, (hl)
                and c
                ld (hl), a

                dec hl
                dec hl
                ex de, hl


                ld a, (hl)
                inc hl
                ld b, (hl)
                inc hl
                ld c, 0

                rra
                rr b
                rr c

                rra
                rr b
                rr c

                rra
                rr b
                rr c

                and 0b00001111

                ex de, hl
                or (hl)
                ld (hl), a
                inc hl
                ld a, (hl)
                or b
                ld (hl), a
                inc hl
                ld a, (hl)
                or c
                ld (hl), a
                dec hl
                dec hl
                ex de, hl

                LineInc_DE

                ex af, af'
                dec a
                jnz .m4

                ret




.m5 ;=================================================

                ex af, af'

                ld a, 0xff
                ld b, (hl)
                inc hl
                ld c, (hl)
                inc hl

                rl c
                rl b
                rla

                rl c
                rl b
                rla

                rl c
                rl b
                rla

                ex de, hl
                and (hl)
                ld (hl), a
                inc hl
                ld a, (hl)
                and b
                ld (hl), a
                inc hl
                ld a, c
                or 0b00000111
                and (hl)
                ld (hl), a

                dec hl
                dec hl
                ex de, hl


                xor a
                ld b, (hl)
                inc hl
                ld c, (hl)
                inc hl

                rl c
                rl b
                rla

                rl c
                rl b
                rla

                rl c
                rl b
                rla


                ex de, hl
                or (hl)
                ld (hl), a
                inc hl
                ld a, (hl)
                or b
                ld (hl), a
                inc hl
                ld a, c
                and 0b11111000
                or (hl)
                ld (hl), a
                dec hl
                dec hl
                ex de, hl

                LineInc_DE

                ex af, af'
                dec a
                jnz .m5

                ret


.m6 ;=================================================

                ex af, af'

                ld a, 0xff
                ld b, (hl)
                inc hl
                ld c, (hl)
                inc hl

                rl c
                rl b
                rla

                rl c
                rl b
                rla

                ex de, hl
                and (hl)
                ld (hl), a
                inc hl
                ld a, (hl)
                and b
                ld (hl), a
                inc hl
                ld a, c
                or 0b00000011
                and (hl)
                ld (hl), a

                dec hl
                dec hl
                ex de, hl


                xor a
                ld b, (hl)
                inc hl
                ld c, (hl)
                inc hl

                rl c
                rl b
                rla

                rl c
                rl b
                rla


                ex de, hl
                or (hl)
                ld (hl), a
                inc hl
                ld a, (hl)
                or b
                ld (hl), a
                inc hl
                ld a, c
                and 0b11111100
                or (hl)
                ld (hl), a
                dec hl
                dec hl
                ex de, hl

                LineInc_DE

                ex af, af'
                dec a
                jnz .m6

                ret

.m7 ;=================================================

                ex af, af'

                ld a, 0xff
                ld b, (hl)
                inc hl
                ld c, (hl)
                inc hl

                rl c
                rl b
                rla

                ex de, hl
                and (hl)
                ld (hl), a
                inc hl
                ld a, (hl)
                and b
                ld (hl), a
                inc hl
                ld a, c
                or 0b00000001
                and (hl)
                ld (hl), a

                dec hl
                dec hl
                ex de, hl


                xor a
                ld b, (hl)
                inc hl
                ld c, (hl)
                inc hl

                rl c
                rl b
                rla

                ex de, hl
                or (hl)
                ld (hl), a
                inc hl
                ld a, (hl)
                or b
                ld (hl), a
                inc hl
                ld a, c
                and 0b11111110
                or (hl)
                ld (hl), a
                dec hl
                dec hl
                ex de, hl

                LineInc_DE

                ex af, af'
                dec a
                jnz .m7

                ret
