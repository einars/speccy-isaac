                ; kills hl, bc, de
sprite_1ch:     ld a, c
                add a, c
                add a, c
                ld (again+1), a
again:          jr $
                ; jump table to implementations
                jp s1_0
                jp s1_1
                jp s1_2
                jp s1_3
                jp s1_4
                jp s1_5
                jp s1_6
                jp s1_7

s1_0:
                ld a, (hl)
                ld (de), a

                LineInc_DE

                inc hl
                djnz s1_0
                ret

s1_1:           ld a, (hl)
                rrca
                ld c, a
                and 0b01111111
                ex hl, de
                or (hl)
                ex hl, de
                ld (de), a

                inc de

                ld a, c
                and 0b10000000
                ex hl, de
                or (hl)
                ex hl, de
                ld (de), a

                dec de

                LineInc_DE
                inc hl

                djnz s1_1
                ret

s1_2:           ld a, (hl)
                rrca
                rrca
                ld c, a
                and 0b00111111
                ex hl, de
                or (hl)
                ex hl, de
                ld (de), a

                inc de

                ld a, c
                and 0b11000000
                ex hl, de
                or (hl)
                ex hl, de
                ld (de), a

                dec de

                LineInc_DE
                inc hl

                djnz s1_2
                ret

s1_3:           ld a, (hl)
                rrca
                rrca
                rrca
                ld c, a
                and 0b00011111
                ex hl, de
                or (hl)
                ex hl, de
                ld (de), a

                inc de

                ld a, c
                and 0b11100000
                ex hl, de
                or (hl)
                ex hl, de
                ld (de), a

                dec de

                LineInc_DE
                inc hl

                djnz s1_3
                ret

s1_4:           ld a, (hl)
                rrca
                rrca
                rrca
                rrca
                ld c, a
                and 0b00001111
                ex hl, de
                or (hl)
                ex hl, de
                ld (de), a

                inc de

                ld a, c
                and 0b11110000
                ex hl, de
                or (hl)
                ex hl, de
                ld (de), a

                dec de

                LineInc_DE
                inc hl

                djnz s1_4
                ret


s1_5:           ld a, (hl)
                rlca
                rlca
                rlca
                ld c, a
                and 0b00000111
                ex hl, de
                or (hl)
                ex hl, de
                ld (de), a

                inc de

                ld a, c
                and 0b11111000
                ex hl, de
                or (hl)
                ex hl, de
                ld (de), a

                dec de

                LineInc_DE
                inc hl

                djnz s1_5
                ret

s1_6:           ld a, (hl)
                rlca
                rlca
                ld c, a
                and 0b00000011
                ex hl, de
                or (hl)
                ex hl, de
                ld (de), a

                inc de

                ld a, c
                and 0b11111100
                ex hl, de
                or (hl)
                ex hl, de
                ld (de), a

                dec de

                LineInc_DE
                inc hl

                djnz s1_6
                ret

s1_7:           ld a, (hl)
                rlca
                ld c, a
                and 0b00000001
                ex hl, de
                or (hl)
                ex hl, de
                ld (de), a

                inc de

                ld a, c
                and 0b11111110
                ex hl, de
                or (hl)
                ex hl, de
                ld (de), a

                dec de

                LineInc_DE
                inc hl

                djnz s1_7
                ret

