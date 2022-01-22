                display "mmm: ",/A,again.m0


                device zxspectrum48

                include "macros.asm"

                org 8000h

Start:          jr 1f

                ei
                di
                rst 0
                ; made in Latvia

1
                call Room.SetAttributes

                ld hl, 0x4000
                ld de, 0x4001
                ld bc, 192 * 32 - 1
                xor a
                ;ld a, 255
                ld (hl), a
                ldir


                ld de, InterruptRoutine
                call im2.Setup


                ld a, Color.black
                out (254), a



                ld hl, spider_init
                ld bc, 0x5530
                push bc
                call appear

                ld hl, spider_init
                ld bc, 0x5530
                call appear

                ld hl, spider_init
                ld bc, 0x6530
                call appear

                ld hl, spider_init
                ld bc, 0x7530
                call appear

                ld hl, spider_init
                ld bc, 0x8530
                call appear


                ld hl, spider_init
                ld bc, 0x7060
                call appear

                ld hl, spider_init
                ld bc, 0x7070
                call appear

                ld hl, spider_init
                ld bc, 0x7080
                call appear

                ld hl, spider_init
                ld bc, 0x7090
                call appear

/*
                ld hl, spider_init
                ld bc, 0x55d0
                call appear

                ld hl, spider_init
                ld bc, 0x65d0
                call appear

                ld hl, spider_init
                ld bc, 0x75d0
                call appear

                ld hl, spider_init
                ld bc, 0x85d0
                call appear

                ld hl, spider_init
                ld bc, 0x55e0
                call appear

                ld hl, spider_init
                ld bc, 0x65e0
                call appear

                ld hl, spider_init
                ld bc, 0x75e0
                call appear

                ld hl, spider_init
                ld bc, 0x85e0
                call appear
*/
                ei

.again          
                call Isaac

                call draw_sprites

                ld a, Color.white
                out (254), a
                ld b, 7
                djnz $
                ld a, Color.black
                out (254), a
                halt

                jr .again


seed            dw 1245
random:        
                ld de, (seed)
                ld a, d
                ld h, e
                ld l, 0xfd
                or a
                sbc hl, de
                sbc hl, de
                ld d, 0
                sbc a, d
                ld e, a
                sbc hl, de
                jnc 1f
                inc hl
1               ld (seed), hl
                ret

InterruptRoutine:
                di
                push hl
                push de
                push bc
                push af
                push ix
                push iy

                call keyboard.Read

                call Isaac.Move

                call update_sprites

                ld hl, The.isaac_y
                ld b, (hl)
                ld hl, The.isaac_x
                ld c, (hl)
                ld hl, Isaac.OnHit
                call hittest_sprites

                pop iy
                pop ix
                pop af
                pop bc
                pop de
                pop hl

                ei
                reti



                include "isaac.asm"
                include "draw.asm"
                include "keyboard.asm"

                include "entities.asm"

                include "generated-sprites.asm"


                include "room.asm"
                include "the.asm"

                ; do not put anything after this line
                ; ----------------------------
                include "im2.asm"


	savesna "isaac.sna", Start

