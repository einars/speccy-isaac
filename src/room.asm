                include "room-tiles.asm"

                module Room

fill            ld (hl), a
                inc hl
                djnz fill
                ret


SetAttributes:
                ld hl, 0x5800

                ld a, Bg.black + Color.white
                ld b, 32
                call fill

                ld a, Bg.black + Color.white
                ld b, 32
                call fill

                ld a, Bg.red + Color.white
                ld b, 32
                call fill


                ld a, Bg.red + Color.white + Color.bright
                ld b, 32
                call fill



                ld a, Bg.red + Color.white + Color.bright
                ld b, 32
                call fill

                ld c, 14
1
                ld a, Bg.red + Color.white + Color.bright
                ld b, 2
                call fill

                ld a, Bg.blue + Color.white + Color.bright
                ld b, 28
                call fill

                ld a, Bg.red + Color.white + Color.bright
                ld b, 2
                call fill

                dec c
                jr nz, 1b



                ld a, Bg.red + Color.white + Color.bright
                ld b, 32
                call fill

                ld a, Bg.red + Color.white + Color.bright
                ld b, 32
                call fill

                ld a, Bg.red + Color.white
                ld b, 32
                call fill

                ld a, Bg.black + Color.white
                ld b, 32
                call fill

                ld a, Bg.black + Color.white
                ld b, 32
                call fill


                ld bc, 00
                ld de, room

loop_q
                ld c, 0
loop_p
                ld a, (de)
                cp S.v1
                jr nz, not_this

                call AttrAddrPQ
                ld (hl), Bg.black + Color.white + Color.bright
                inc hl
                ld (hl), Bg.black + Color.white + Color.bright
                dec hl
                push de
                ld de, 32
                add hl, de
                pop de
                ld (hl), Bg.black + Color.white + Color.bright
                inc hl
                ld (hl), Bg.black + Color.white + Color.bright

not_this
                inc de
                inc c
                ld a, c
                cp 16
                jr nz, loop_p

                inc b
                ld a, b
                cp 9
                jr nz, loop_q

                ret

AttrAddrPQ:     ; BC - pq (c = p)
                ; out - HL - attribute address for top left

                ld l, b
                ld h, 0; q * 32 * 2
                add hl, hl
                add hl, hl
                add hl, hl
                add hl, hl
                add hl, hl
                add hl, hl
                ld a, l
                add c
                add c
                ld l, a

                push de
                ld de, 0x5800 + 96
                add hl, de
                pop de

                ret

TileAtXY:
                ; BC - xy (c = x)
                ; out - A - tile
                ld a, c
                srl a
                srl a
                srl a
                srl a
                and 0xff
                ld c, a

                ld a, b
                sub 24 ; 24 pikseļi — augšējais ekrāns

                and 0b01110000
                add c
                ld c, a
                ld b, 0

                push hl
                ld hl, room
                add hl, bc
                ld a, (hl)
                pop hl
                ret

                endmodule





room            db W.ul, W.up, W.up, W.up, W.up, W.up, W.up, W.up, W.up, W.up, W.up, W.up, W.up, W.up, F.oo, W.ur
                db W.rt, F.oo, F.oo, F.oo, F.oo, F.oo, F.oo, F.oo, F.oo, F.oo, F.oo, F.oo, F.oo, F.oo, F.oo, W.rt
                db W.rt, F.oo, F.oo, F.oo, F.oo, S.v1, F.oo, F.oo, F.oo, S.v1, F.oo, F.oo, F.oo, F.oo, F.oo, W.rt
                db W.rt, F.oo, F.oo, F.oo, F.oo, F.oo, F.oo, F.oo, F.oo, F.oo, F.oo, F.oo, F.oo, F.oo, F.oo, W.rt
                db W.rt, F.oo, F.oo, S.v1, F.oo, F.oo, F.oo, S.v1, F.oo, F.oo, F.oo, S.v1, F.oo, F.oo, F.oo, W.rt
                db W.rt, F.oo, F.oo, F.oo, F.oo, F.oo, F.oo, F.oo, F.oo, F.oo, F.oo, F.oo, F.oo, F.oo, F.oo, W.rt
                db W.rt, F.oo, F.oo, F.oo, F.oo, S.v1, F.oo, F.oo, F.oo, S.v1, F.oo, F.oo, F.oo, F.oo, F.oo, W.rt
                db W.rt, F.oo, F.oo, F.oo, F.oo, F.oo, F.oo, F.oo, F.oo, F.oo, F.oo, F.oo, F.oo, F.oo, F.oo, W.rt
                db W.dl, W.dn, W.dn, W.dn, W.dn, W.dn, W.dn, W.dn, W.dn, W.dn, W.dn, W.dn, W.dn, W.dn, F.oo, W.dr
                dup 128 : DB W.rt : EDUP





