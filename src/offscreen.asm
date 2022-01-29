                module Offscreen

fill            ld (hl), a
                inc hl
                djnz fill
                ret

; offsceen will contain a clean background
; hl — offscreen address for debugging purposes
Build:
                ld hl, Offscreen
                ld de, room
                ld a, l
                add (32 * Room.TopReserve)
                ld l, a

                ld c, Room.H
.col
                ld b, Room.W

                push hl
.row
                ld a, (de)
                push hl
                push de
                push bc
                call draw_room_tile
                pop bc
                pop de
                pop hl

                inc hl
                inc hl
                inc de

                djnz .row

                pop hl

                ld b, 16
.nextrow        LineInc_HL
                djnz .nextrow

                dec c
                jnz .col
1:
                ret

Draw:  ; speed not really required
                ld hl, Offscreen
                ld de, 0x4000
                ld bc, 6144
                ldir
                ret


MarkDirty2:
                ; BC = xy
                push bc
                push hl
                ld a, (hl)

                srl c
                srl c
                srl c
                srl c ; c = x / 16

                ld a, b
                sub 0x20 ; upper line adjustment, 32 pixels
                and 0xf0
                or c

                ; bc = pq

                ld h, (room / 256)
                ld l, a

                set Geo.dirty_bit, (hl)
                inc l
                set Geo.dirty_bit, (hl)

                ld a, l
                add a, Room.W - 1
                ld l, a

                set Geo.dirty_bit, (hl)
                inc l
                set Geo.dirty_bit, (hl)

                pop hl
                pop bc
                ret

MarkAllDirty:
                ld hl, room
                ld b, Room.W * Room.H
1
                set 7,(hl) ; Geo.dirty
                inc hl
                djnz 1b
                ret


dirty_slice     db 0
RestoreNextDirtySlice:
                ld hl, dirty_slice
                ld a, (hl)
                inc a
                cp Room.H
                jnz 1f
                xor a
1
                ld (hl), a

RestoreDirtySlice:
                ; restore dirty tiles on horizontal line Q
                ; A = Q

                ld d, a

                rlca
                rlca
                rlca
                rlca
                ld l, a
                ld h, room >> 8
                ; hl - &room

                ld b, Room.W
.x
                bit Geo.dirty_bit, (hl)
                jnz .redraw

.loop
                inc hl
                djnz .x
                ret

.redraw:
                res Geo.dirty_bit, (hl)
                
                push bc
                push hl
                push de

                ld a, Room.W
                sub b
                ld c, a
                ld b, d

                call Util.XY_of_PQ
                call Util.Scr_of_XY
                ld h, d
                ld l, e
                set 7, h

                dup 8
                  ld a, (hl)
                  ld (de), a
                  inc hl
                  inc de

                  ld a, (hl)
                  ld (de), a
                  dec hl
                  dec de

                  inc h
                  inc d
                edup

                dec d
                LineInc_DE
                ld h, d
                ld l, e
                set 7, h

                dup 8
                  ld a, (hl)
                  ld (de), a
                  inc hl
                  inc de

                  ld a, (hl)
                  ld (de), a
                  dec hl
                  dec de

                  inc h
                  inc d
                edup

                pop de
                pop hl
                pop bc
                jp .loop







RestoreDirty:
                ld hl, room
                ld b, Room.H * Room.W
1
                ld a, (hl)
                
                and Geo.dirty ; testing Geo.dirty
                jnz .restore
.loop
                inc hl
                djnz 1b
                ret


.restore
                ld a, (hl)
                and 0x7f
                ;or a ; reset Geo.dirty
                ;rra
                ld (hl), a

                ; we have to restore the tile at position given by c

                push bc
                push hl
                ld a, Room.H * Room.W
                sub b
                ; get screen address
                ;stop
                call Util.PQ_of_BPQ
                call Util.XY_of_PQ
                call Util.Scr_of_XY

                ld h, d
                ld l, e
                set 7, h

                dup 8
                  ld a, (hl)
                  ld (de), a
                  inc hl
                  inc de

                  ld a, (hl)
                  ld (de), a
                  dec hl
                  dec de

                  inc h
                  inc d
                edup

                dec d
                LineInc_DE
                ld h, d
                ld l, e
                set 7, h

                dup 8
                  ld a, (hl)
                  ld (de), a
                  inc hl
                  inc de

                  ld a, (hl)
                  ld (de), a
                  dec hl
                  dec de

                  inc h
                  inc d
                edup

                pop hl
                pop bc
                jp .loop





draw_room_tile:
                ; in: A - tile index
                ; HL - (off)screen position

                cp S.v1
                jz .tile_nonempty
                and Geo.wall + Geo.perm
                jnz .tile_nonempty


                jp .tile_empty
.tile_nonempty
                ld de, tile_stone_001 + 1

                dup 7
                ld a, (de)
                ld (hl), a
                inc de
                inc l
                ld a, (de)
                ld (hl), a
                inc de
                dec l
                inc h
                edup

                ld a, (de)
                ld (hl), a
                inc de
                inc l
                ld a, (de)
                ld (hl), a
                inc de
                dec l

                LineInc_HL

                dup 8
                ld a, (de)
                ld (hl), a
                inc de
                inc l
                ld a, (de)
                ld (hl), a
                inc de
                dec l
                inc h
                edup

                ret



.tile_empty     xor a
                
                dup 7
                  ld (hl), a
                  inc l
                  ld (hl), a
                  dec l
                  inc h
                edup

                ld (hl), 0
                inc l
                ld (hl), 128
                dec l
                inc h

                dec h
                LineInc_HL

                xor a

                dup 7
                  ld (hl), a
                  inc l
                  ld (hl), a
                  dec l
                  inc h
                edup
                xor a
                ld (hl), a
                inc l
                ld (hl), a

                ret



SetAttributes:
                ld hl, 0x5800

                ld a, Bg.black + Color.white
                ld b, 32 * (Room.TopReserve - 1)
                call fill

                ; avoid cleaning the single line the isaac's head pops out
                ld a, Bg.black + Color.black
                ld b, 32
                call fill

                ld a, Bg.red + Color.white + Color.bright
                ld b, 32
                call fill



                ld a, Bg.red + Color.white + Color.bright
                ld b, 32
                call fill

                ld c, (Room.H - 2) * 2
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
                
                ret


                ld bc, 00
                ld de, room

loop_q
                ld c, 0
loop_p
                ld a, (de)
                cp S.v1
                jr nz, not_this

                call Util.AttrAddrPQ
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
                cp 10
                jr nz, loop_q

                ret


                org 0xc000
Offscreen       ds 6144
Offattrs        ds 768 ; unused

                endmodule


