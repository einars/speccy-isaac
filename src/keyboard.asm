                module keyboard

Read:
                ld d, 0
                ld bc, 0xfffe

                ld hl, keymap
loop:           ld a, (hl)
                inc hl
                and a
                jr z, done

                ld b, a
                in a, (c) ; that's port BC actually

                and (hl) ; 0 - pressed
                inc hl
                jr nz, no_press

                ; key pressed
                ld a, d
                or (hl)
                ld d, a

no_press:       inc hl
                jr loop

done:           ld a, d
                ld (movement), a
                ret
                



                

movement db 0
fire     db 0

MASK_UP    equ 1 << UP
MASK_LEFT  equ 1 << LEFT
MASK_DOWN  equ 1 << DOWN
MASK_RIGHT equ 1 << RIGHT


keymap          
                db 0xfb, 0b00000010, MASK_UP ; W
                db 0xfd, 0b00000001, MASK_LEFT ; A
                db 0xfd, 0b00000010, MASK_DOWN ; S
                db 0xfd, 0b00000100, MASK_RIGHT ; D

                ; cursor joystick
                db 0xf7, 0b00010000, MASK_LEFT
                db 0xef, 0b00010000, MASK_DOWN
                db 0xef, 0b00000100, MASK_RIGHT
                db 0xef, 0b00001000, MASK_UP

                db 0

                endmodule
