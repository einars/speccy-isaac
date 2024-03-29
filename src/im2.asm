                module im2

jumpspace equ 0xfdfd
table_base equ 0xfe00

Setup:
                ; DE - handler routine
                di
                pop hl
                ld sp, jumpspace - 1
                push hl

                ld hl, jumpspace
                xor a

1               ld (hl), a
                inc hl
                cp h
                jr nz, 1b

                ld hl, jumpspace
                ld (hl), 0xc3
                inc hl
                ld (hl), e
                inc hl
                ld (hl), d

                ld hl, table_base
                ld b, 129

                ld a, h
                ld i, a ; interrupt register hi

.loop           ld (hl), 0xfd
                inc hl
                ld (hl), 0xfd
                inc hl
                djnz .loop

                im 2
                ret

                endmodule
