                device zxspectrum48

                org 8000h

Start:
                ld de, InterruptRoutine
                call im2.Setup

                xor a
                ld (The.timer), a

                ld a, 0b110
                out (254), a

                ld hl, 0x4000
                ld de, 182 * 32
                xor a
.loop 
                ld (hl), a
                inc hl
                dec de

                dec d
                inc d
                jr nz, .loop

                dec e
                inc e
                jr nz, .loop

.again          
                ld a, (The.isaac_x)
                ld c, a
                ld a, (The.isaac_y)
                ld b, a
                call Isaac

                ld a, (The.isaac_x)
                add 18
                ld c, a
                ld a, (The.isaac_y)
                ld b, a
                call Isaac

                ld a, (The.isaac_x)
                add 36
                ld c, a
                ld a, (The.isaac_y)
                ld b, a
                call Isaac

                ld a, (The.isaac_x)
                ld c, a
                ld a, (The.isaac_y)
                add 24
                ld b, a
                call Isaac

                ld a, (The.isaac_x)
                add 18
                ld c, a
                ld a, (The.isaac_y)
                add 24
                ld b, a
                call Isaac

                ld a, (The.isaac_x)
                add 36
                ld c, a
                ld a, (The.isaac_y)
                add 24
                ld b, a
                call Isaac

                ld a, (The.isaac_x)
                ld c, a
                ld a, (The.isaac_y)
                add 48
                ld b, a
                call Isaac

                ld a, (The.isaac_x)
                add 18
                ld c, a
                ld a, (The.isaac_y)
                add 48
                ld b, a
                call Isaac

                ld a, (The.isaac_x)
                add 36
                ld c, a
                ld a, (The.isaac_y)
                add 48
                ld b, a
                call Isaac

                ld a, (The.isaac_x)
                ld c, a
                ld a, (The.isaac_y)
                add 64
                ld b, a
                call Isaac

                ld a, (The.isaac_x)
                add 18
                ld c, a
                ld a, (The.isaac_y)
                add 64
                ld b, a
                call Isaac

                ld a, (The.isaac_x)
                add 36
                ld c, a
                ld a, (The.isaac_y)
                add 64
                ld b, a
                call Isaac

                call wait_vsync

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
                ld a, (keyboard.movement)
                bit keyboard.BIT_UP, a
                jr z, no_up

                ld hl, The.isaac_y
                dec (hl)
no_up:
                bit keyboard.BIT_DOWN, a
                jr z, no_down

                ld hl, The.isaac_y
                inc (hl)
no_down:
                bit keyboard.BIT_LEFT, a
                jr z, no_left

                ld hl, The.isaac_x
                dec (hl)
no_left:
                bit keyboard.BIT_RIGHT, a
                jr z, no_right

                ld hl, The.isaac_x
                inc (hl)
no_right:

                xor a
                ld (vsync), a

                pop iy
                pop ix
                pop af
                pop bc
                pop de
                pop hl

                ei
                reti
vsync db 0

wait_vsync:     ld a, 1
                ld (vsync), a

                ld a, 0b101
                out (254), a

k:              ld a, (vsync)
                or a
                jr nz, k

                ld a, 0b110
                out (254), a

                ret


                include "sprites.asm"
                include "keyboard.asm"



                ; do not put anything after this line
                ; ----------------------------
                include "im2.asm"

                include "the.asm"

	savesna "isaac.sna", Start

