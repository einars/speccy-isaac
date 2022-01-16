                device zxspectrum48

                org 5f00h

Start:
                ld de, InterruptRoutine
                call im2.Setup

                xor a
                ld (The.timer), a

                ld a, 0b110
                out (254), a

                ld hl, 0x4000
                ld de, 0x4001
                ld bc, 192 * 32 - 1
                ld a, 0b10001000
                ld (hl), a
                ldir
                ld bc, 798 - 1
                ld a, Color.white + Bg.blue + Color.bright
                ld (hl), a
                ldir


.again          
                ld a, (The.isaac_x)
                ld c, a
                ld a, (The.isaac_y)
                ld b, a
                call Isaac

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

                ld c, 0 ; has movement?

                ld a, (keyboard.movement)
                bit UP, a
                jr z, no_up

                inc c
                ld hl, The.isaac_y
                dec (hl)
                ld hl, The.isaac_facing
                ld (hl), UP
no_up:
                bit DOWN, a
                jr z, no_down

                inc c
                ld hl, The.isaac_y
                inc (hl)
                ld hl, The.isaac_facing
                ld (hl), DOWN
no_down:
                bit LEFT, a
                jr z, no_left

                inc c
                ld hl, The.isaac_x
                dec (hl)
                ld hl, The.isaac_facing
                ld (hl), LEFT
no_left:
                bit RIGHT, a
                jr z, no_right

                inc c
                ld hl, The.isaac_x
                inc (hl)
                ld hl, The.isaac_facing
                ld (hl), RIGHT

no_right:

                xor a
                or c
                jr nz, had_movement

no_movement:    ld hl, The.isaac_facing
                ld (hl), DOWN
                ld hl, The.isaac_step
                ld (hl), 0
                ld hl, The.isaac_step_counter
                ld (hl), 0
                jr isaac_step_done

had_movement:   ; animate steps
                ld hl, The.isaac_step_max
                ld a, (The.isaac_step_counter)
                inc a
                cp (hl)
                jr z, next_step

                ld (The.isaac_step_counter), a
                jr isaac_step_done

next_step:      xor a
                ld (The.isaac_step_counter), a
                ld a, (The.isaac_step)
                inc a
                and 3
                ld (The.isaac_step), a

isaac_step_done:
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


                include "the.asm"

                include "draw.asm"
                include "keyboard.asm"

                include "generated-sprites.asm"



                ; do not put anything after this line
                ; ----------------------------
                include "im2.asm"


	savesna "isaac.sna", Start

