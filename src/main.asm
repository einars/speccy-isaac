                device zxspectrum48

                org 5f00h

Start:          jr 1f

                Ei
                Di
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


.again          
                ld a, (The.isaac_x)
                ld c, a
                ld a, (The.isaac_y)
                ld b, a
                call Isaac


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

                include "generated-sprites.asm"


                include "room.asm"
                include "the.asm"

                ; do not put anything after this line
                ; ----------------------------
                include "im2.asm"


	savesna "isaac.sna", Start

