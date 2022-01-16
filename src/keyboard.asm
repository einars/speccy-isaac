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

BIT_UP    equ 0
BIT_LEFT  equ 1
BIT_DOWN  equ 2
BIT_RIGHT equ 3

UP    equ 1 << BIT_UP
LEFT  equ 1 << BIT_LEFT
DOWN  equ 1 << BIT_DOWN
RIGHT equ 1 << BIT_RIGHT


keymap          
                db 0xfb, 0b00000010, UP ; W
                db 0xfd, 0b00000001, LEFT ; A
                db 0xfd, 0b00000010, DOWN ; S
                db 0xfd, 0b00000100, RIGHT ; D

                ; cursor joystick
                db 0xf7, 0b00010000, LEFT
                db 0xef, 0b00010000, DOWN
                db 0xef, 0b00000100, RIGHT
                db 0xef, 0b00001000, UP

                db 0

                endmodule
