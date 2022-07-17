                module Sprite

Flags:
.masked equ 0x80
.unmasked equ 0x00

.single_column equ 0x01 ; unsupported yet
.double_column equ 0x02



Draw:
                ; hl - sprite base
                ; bc - bottom center -> top left

                ld a, (hl)
                and Sprite.Flags.masked
                jnz .masked


.unmasked
                inc hl
                ; writeme
                ret

.masked
                inc hl
                ld a, c
                sub 7
                ld c, a
                ld a, b
                sub (hl)
                inc a
                ld b, a

                call Util.Scr_of_XY
                ; de - now is screen pos
                ; a - offset
                ld c, a

                ld b, (hl)
                inc hl

                ; now:
                ; DE — &screen_addr
                ; HL - &image_data (starting with mask)
                ; B - height of column
                ; C - bit offset


                jp Draw_masked_double


Undraw:
                ld a, (hl)
                and Sprite.Flags.masked
                jnz .masked

.unmasked
                ret

.masked
                inc hl
                jp Restore_masked_double

; ---

                include "masked_double.draw.asm"
                include "masked_double.restore.asm"


                endmodule
