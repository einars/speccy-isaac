                device zxspectrum48

                org 8000h

Start:
1               ld a, 0b110
                out (254), a

                ld de, InterruptRoutine
                call im2.Setup


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

                ld b, 64
                ld c, 15

aga:
                ;ld hl, isaac_x
                ;inc (hl)

                ;inc c
                ld a, (isaac_x)
                ld c, a
                ld a, (isaac_y)
                ld b, a
                call Isaac

                jr aga


InterruptRoutine:
                push hl
                push de
                push bc
                push af
                push ix
                push iy

                call keyboard.Read
                ld a, (keyboard.movement)
                bit keyboard.BIT_UP, a
                jr z, no_up

                ld hl, isaac_y
                dec (hl)
no_up:
                bit keyboard.BIT_DOWN, a
                jr z, no_down

                ld hl, isaac_y
                inc (hl)
no_down:
                bit keyboard.BIT_LEFT, a
                jr z, no_left

                ld hl, isaac_x
                dec (hl)
no_left:
                bit keyboard.BIT_RIGHT, a
                jr z, no_right

                ld hl, isaac_x
                inc (hl)
no_right:

                pop iy
                pop ix
                pop af
                pop bc
                pop de
                pop hl

                ei
                reti
isaac_x db 40
isaac_y db 40


                include "sprites.asm"
                include "keyboard.asm"



                ; do not put anything after this line
                ; ----------------------------
                include "im2.asm"

	savesna "isaac.sna", Start

