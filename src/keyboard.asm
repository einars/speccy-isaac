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


keymap          
                db 0xfb, 0b00000010, (1 << BIT_UP) ; W
                db 0xfd, 0b00000001, (1 << BIT_LEFT) ; A
                db 0xfd, 0b00000010, (1 << BIT_DOWN) ; S
                db 0xfd, 0b00000100, (1 << BIT_RIGHT) ; D
                db 0

                endmodule
