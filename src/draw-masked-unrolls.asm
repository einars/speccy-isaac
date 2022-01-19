
                ; HL - image data
                ; DE - screen address
                ; B - height
                ; C - bit offset

                ; on return:
                ; HL - byte after sprite data end
                ; everything else probably messed up

masked_1c:      
                ld a, c
                add a, c
                add a, c
                ld (again+1), a
again           jr $
                ; jump table to implementations
                jp .m0
                jp .m1
                jp .m2;.m2
                jp .m3;.m3
                jp .m4;.m4
                jp .m5;.m5
                jp .m6;.m6
                jp .m7;.m7
.m0
                ld a, (de)
                and (hl)
                inc hl
                or (hl)
                inc hl
                ld (de), a

                LineInc_DE

                djnz .m0
                ret

.m1 ;=================================================
                ; apply mask
                ld a, (hl)
                rrca
                ld c, a
                and 0b01111111
                or  0b10000000
                ex hl, de
                and (hl)
                ld (hl), a
                ex hl, de

                inc de

                ld a, c
                and 0b10000000
                or  0b01111111
                ex hl, de
                and (hl)
                ld (hl), a
                ex hl, de

                dec de

                inc hl

                ; apply sprite

                ld a, (hl)
                rrca
                ld c, a
                and 0b01111111
                ex hl, de
                or (hl)
                ld (hl), a
                ex hl, de

                inc de

                ld a, c
                and 0b10000000
                ex hl, de
                or (hl)
                ld (hl), a
                ex hl, de

                dec de

                LineInc_DE
                inc hl

                djnz .m1

                ret



.m2 ;=================================================
                ; apply mask
                ld a, (hl)
                rrca
                rrca
                ld c, a
                and 0b00111111
                or  0b11000000
                ex hl, de
                and (hl)
                ld (hl), a
                ex hl, de

                inc de

                ld a, c
                and 0b11000000
                or  0b00111111
                ex hl, de
                and (hl)
                ld (hl), a
                ex hl, de

                dec de

                inc hl

                ; apply sprite

                ld a, (hl)
                rrca
                rrca
                ld c, a
                and 0b00111111
                ex hl, de
                or (hl)
                ld (hl), a
                ex hl, de

                inc de

                ld a, c
                and 0b11000000
                ex hl, de
                or (hl)
                ld (hl), a
                ex hl, de

                dec de

                LineInc_DE
                inc hl

                djnz .m2

                ret



.m3 ;=================================================
                ; apply mask
                ld a, (hl)
                rrca
                rrca
                rrca
                ld c, a
                and 0b00011111
                or  0b11100000
                ex hl, de
                and (hl)
                ld (hl), a
                ex hl, de

                inc de

                ld a, c
                and 0b11100000
                or  0b00011111
                ex hl, de
                and (hl)
                ld (hl), a
                ex hl, de

                dec de

                inc hl

                ; apply sprite

                ld a, (hl)
                rrca
                rrca
                rrca
                ld c, a
                and 0b00011111
                ex hl, de
                or (hl)
                ld (hl), a
                ex hl, de

                inc de

                ld a, c
                and 0b11100000
                ex hl, de
                or (hl)
                ld (hl), a
                ex hl, de

                dec de

                LineInc_DE
                inc hl

                djnz .m3

                ret



.m4 ;=================================================
                ; apply mask
                ld a, (hl)
                rrca
                rrca
                rrca
                rrca
                ld c, a
                and 0b00001111
                or  0b11110000
                ex hl, de
                and (hl)
                ld (hl), a
                ex hl, de

                inc de

                ld a, c
                and 0b11110000
                or  0b00001111
                ex hl, de
                and (hl)
                ld (hl), a
                ex hl, de

                dec de

                inc hl

                ; apply sprite

                ld a, (hl)
                rrca
                rrca
                rrca
                rrca
                ld c, a
                and 0b00001111
                ex hl, de
                or (hl)
                ld (hl), a
                ex hl, de

                inc de

                ld a, c
                and 0b11110000
                ex hl, de
                or (hl)
                ld (hl), a
                ex hl, de

                dec de

                LineInc_DE
                inc hl

                djnz .m4

                ret



.m5 ;=================================================
                ; apply mask
                ld a, (hl)
                rlca
                rlca
                rlca
                ld c, a
                and 0b00000111
                or  0b11111000
                ex hl, de
                and (hl)
                ld (hl), a
                ex hl, de

                inc de

                ld a, c
                and 0b11111000
                or  0b00000111
                ex hl, de
                and (hl)
                ld (hl), a
                ex hl, de

                dec de

                inc hl

                ; apply sprite

                ld a, (hl)
                rlca
                rlca
                rlca
                ld c, a
                and 0b00000111
                ex hl, de
                or (hl)
                ld (hl), a
                ex hl, de

                inc de

                ld a, c
                and 0b11111000
                ex hl, de
                or (hl)
                ld (hl), a
                ex hl, de

                dec de

                LineInc_DE
                inc hl

                djnz .m5

                ret



.m6 ;=================================================
                ; apply mask
                ld a, (hl)
                rlca
                rlca
                ld c, a
                and 0b00000011
                or  0b11111100
                ex hl, de
                and (hl)
                ld (hl), a
                ex hl, de

                inc de

                ld a, c
                and 0b11111100
                or  0b00000011
                ex hl, de
                and (hl)
                ld (hl), a
                ex hl, de

                dec de

                inc hl

                ; apply sprite

                ld a, (hl)
                rlca
                rlca
                ld c, a
                and 0b00000011
                ex hl, de
                or (hl)
                ld (hl), a
                ex hl, de

                inc de

                ld a, c
                and 0b11111100
                ex hl, de
                or (hl)
                ld (hl), a
                ex hl, de

                dec de

                LineInc_DE
                inc hl

                djnz .m6

                ret



.m7 ;=================================================
                ; apply mask
                ld a, (hl)
                rlca
                ld c, a
                and 0b00000001
                or  0b11111110
                ex hl, de
                and (hl)
                ld (hl), a
                ex hl, de

                inc de

                ld a, c
                and 0b11111110
                or  0b00000001
                ex hl, de
                and (hl)
                ld (hl), a
                ex hl, de

                dec de

                inc hl

                ; apply sprite

                ld a, (hl)
                rlca
                ld c, a
                and 0b00000001
                ex hl, de
                or (hl)
                ld (hl), a
                ex hl, de

                inc de

                ld a, c
                and 0b11111110
                ex hl, de
                or (hl)
                ld (hl), a
                ex hl, de

                dec de

                LineInc_DE
                inc hl

                djnz .m7

                ret



