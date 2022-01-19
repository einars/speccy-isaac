                device zxspectrum48

                org 5f00h

Start:          jr 1f

                ei
                di
                rst 0
                ; made in Latvia


1               ld de, InterruptRoutine
                call im2.Setup

                xor a
                ld (The.timer), a

                ld a, Color.black
                out (254), a

                ld hl, 0x4000
                ld de, 0x4001
                ld bc, 192 * 32 - 1
                xor a
                ld (hl), a
                ldir

                call Room.SetAttributes

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
/*

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

                jp .again


InterruptRoutine:
                push hl
                push de
                push bc
                push af
                push ix
                push iy

                ld hl, The.timer
                inc (hl)

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

