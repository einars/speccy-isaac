                module keyboard

Read:
                xor a
                ld d, a
                ld e, a
                ld bc, 0xfffe

                ld hl, keymap
.loop           ld a, (hl)
                inc hl
                and a
                jz .done

                cp b
                jz .no_port_change ; same port - no need to read again

                ld b, a
                in a, (c) ; that's port BC actually
                ld e, a

.no_port_change
                ld a, e
                and (hl) ; 0 - pressed
                inc hl
                jnz .next

                ; key pressed
                ld a, (hl)

                cp MASK_FIRE_D
                jz .handle_directional_fire

                or d
                ld d, a

.next           inc hl
                inc hl
                jr .loop

.done           ld a, d
                ld (movement), a

                ret
                
.handle_directional_fire
                or d
                ld d, a ; set mask_fire_d flag
                inc hl
                ld a, (hl)
                ld (fire_direction), a
                inc hl
                jr .loop



                

movement db 0
fire_direction db 0

MASK_UP    equ 1 << UP
MASK_LEFT  equ 1 << LEFT
MASK_DOWN  equ 1 << DOWN
MASK_RIGHT equ 1 << RIGHT
MASK_FIRE_M equ 1 << FIRE_M
MASK_FIRE_D equ 1 << FIRE_D


keymap          
                db 0xfb, 0b00000010, MASK_UP, 0 ; W
                db 0xfd, 0b00000001, MASK_LEFT, 0 ; A
                db 0xfd, 0b00000010, MASK_DOWN, 0 ; S
                db 0xfd, 0b00000100, MASK_RIGHT, 0 ; D

                ; cursor joystick
                db 0xf7, 0b00010000, MASK_LEFT, 0
                db 0xef, 0b00010000, MASK_DOWN, 0
                db 0xef, 0b00000100, MASK_RIGHT, 0
                db 0xef, 0b00001000, MASK_UP, 0

                db 0xef, 0b00000001, MASK_FIRE_M, 0

                db 0x7f, 0b00000100, MASK_FIRE_M, 0 ; M
                db 0x7f, 0b00000001, MASK_FIRE_M, 0 ; space

                db 0xdf, 0b00000100, MASK_FIRE_D, UP    ; "I"
                db 0xbf, 0b00000100, MASK_FIRE_D, DOWN  ; "J"
                db 0xbf, 0b00001000, MASK_FIRE_D, LEFT  ; "K"
                db 0xbf, 0b00000010, MASK_FIRE_D, RIGHT ; "L"

                db 0

                endmodule
