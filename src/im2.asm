                module im2
                ; DE - handler routine

jumpspace equ 0xfdfd
table_base equ 0xfe00

Setup:
                di
                pop hl
                ld sp, jumpspace - 1
                push hl

                ld hl, jumpspace
                xor a

cleanup         ld (hl), a
                inc hl
                cp h
                jr nz, cleanup

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
                ei
                ret

                endmodule
