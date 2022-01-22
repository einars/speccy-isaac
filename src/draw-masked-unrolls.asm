
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
                ld a, (de) ; 7
                and (hl)   ; 7
                inc hl     ; 6
                or (hl)    ; 7
                inc hl     ; 6
                ld (de), a ; 7

                LineInc_DE ; X

                djnz .m0   ; 13 / 8
                ret

.m1 ;=================================================

                ex hl, de
1
                ld a, (de)
                ld c, 0xff

                rra
                rr c
                or 0b10000000

                and (hl)
                ld (hl), a
                inc hl

                ld a, c

                and (hl)
                ld (hl), a
                dec hl

                inc de

                ld a, (de)
                ld c, 0

                rra
                rr c
                and 0b01111111

                or (hl)
                ld (hl), a
                inc hl

                ld a, c

                or (hl)
                ld (hl), a
                dec hl

                LineInc_HL
                inc de

                djnz 1b

                ex hl, de

                ret

.m2 ;=================================================

                ex hl, de
2
                ld a, (de)
                ld c, 0xff

                rra
                rr c
                rra
                rr c
                or 0b11000000

                and (hl)
                ld (hl), a
                inc hl

                ld a, c

                and (hl)
                ld (hl), a
                dec hl

                inc de

                ld a, (de)
                ld c, 0

                rra
                rr c
                rra
                rr c
                and 0b00111111

                or (hl)
                ld (hl), a
                inc hl

                ld a, c

                or (hl)
                ld (hl), a
                dec hl

                LineInc_HL
                inc de

                djnz 2b

                ex hl, de
                ret

.m3 ;=================================================
                ex hl, de
3
                ld a, (de)
                ld c, 0xff

                rra
                rr c
                rra
                rr c
                rra
                rr c
                or 0b11100000

                and (hl)
                ld (hl), a
                inc hl

                ld a, c

                and (hl)
                ld (hl), a
                dec hl

                inc de

                ld a, (de)
                ld c, 0

                rra
                rr c
                rra
                rr c
                rra
                rr c
                and 0b00011111

                or (hl)
                ld (hl), a
                inc hl

                ld a, c

                or (hl)
                ld (hl), a
                dec hl

                LineInc_HL
                inc de

                djnz 3b

                ex hl, de
                ret

.m4 ;=================================================
                ex hl, de
4
                ld a, (de)
                ld c, 0xff

                rra
                rr c
                rra
                rr c
                rra
                rr c
                rra
                rr c
                or 0b11110000

                and (hl)
                ld (hl), a
                inc hl

                ld a, c

                and (hl)
                ld (hl), a
                dec hl

                inc de

                ld a, (de)
                ld c, 0

                rra
                rr c
                rra
                rr c
                rra
                rr c
                rra
                rr c
                and 0b00001111

                or (hl)
                ld (hl), a
                inc hl

                ld a, c

                or (hl)
                ld (hl), a
                dec hl

                LineInc_HL
                inc de

                djnz 4b

                ex hl, de
                ret


.m5 ;=================================================
                ex hl, de
5
                ld a, (de)
                ld c, 0xff

                rla
                rl c
                rla
                rl c
                rla
                rl c
                or 0b00000111

                ex af, af'
                ld a, (hl)
                and c
                ld (hl), a
                inc hl

                ex af, af'
                and (hl)
                ld (hl), a
                dec hl

                inc de

                ld a, (de)
                ld c, 0

                rla
                rl c
                rla
                rl c
                rla
                rl c
                and 0b11111000

                ex af, af'
                ld a, (hl)
                or c
                ld (hl), a
                inc hl

                ex af, af'
                or (hl)
                ld (hl), a
                dec hl

                LineInc_HL
                inc de

                djnz 5b

                ex hl, de
                ret


.m6 ;=================================================
                ex hl, de
6
                ld a, (de)
                ld c, 0xff

                rla
                rl c
                rla
                rl c
                or 0b00000011

                ex af, af'
                ld a, (hl)
                and c
                ld (hl), a
                inc hl

                ex af, af'
                and (hl)
                ld (hl), a
                dec hl

                inc de

                ld a, (de)
                ld c, 0

                rla
                rl c
                rla
                rl c
                and 0b11111100

                ex af, af'
                ld a, (hl)
                or c
                ld (hl), a
                inc hl

                ex af, af'
                or (hl)
                ld (hl), a
                dec hl

                LineInc_HL
                inc de

                djnz 6b

                ex hl, de
                ret


.m7 ;=================================================
                ex hl, de
6
                ld a, (de)
                ld c, 0xff

                rla
                rl c
                or 0b00000001

                ex af, af'
                ld a, (hl)
                and c
                ld (hl), a
                inc hl

                ex af, af'
                and (hl)
                ld (hl), a
                dec hl

                inc de

                ld a, (de)
                ld c, 0

                rla
                rl c
                and 0b11111110

                ex af, af'
                ld a, (hl)
                or c
                ld (hl), a
                inc hl

                ex af, af'
                or (hl)
                ld (hl), a
                dec hl

                LineInc_HL
                inc de

                djnz 6b

                ex hl, de
                ret


