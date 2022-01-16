im2_table_base equ 0xd000

                module im2

Setup:          ; DE - handler routine
                ld a, e
                ld (smc + 1), a
                ld a, d
                ld (smc + 2), a

                di
                ld hl, im2_table_base
                ld b, 129

                ld a, h
                ld i, a ; interrupt register hi

.loop           ld (hl), 0xd1
                inc hl
                ld (hl), 0xd1
                inc hl
                djnz .loop

                im 2
                ei
                ret


                ; interrupt table
                org im2_table_base
                defs 256

                org 0xd1d1
smc:            jp $0

                endmodule
