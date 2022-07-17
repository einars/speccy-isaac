                module Sprite

TraceStart:

Flags:
.masked equ 0x80
.unmasked equ 0x00

.single_column equ 0x01 ; unsupported yet
.double_column equ 0x02



Draw:
                ; hl - sprite base
                ; bc - bottom center -> top left

                ld a, (hl)
                inc hl
                and Sprite.Flags.masked
                jp nz, Masked_double.Draw
                jp Unmasked_double.Draw


Undraw:
                ld a, (hl)
                inc hl
                and Sprite.Flags.masked
                jp nz, Masked_double.Restore
                jp Unmasked_double.Restore

; ---

                include "masked_double.draw.asm"
                include "masked_double.restore.asm"

                include "unmasked_double.draw.asm"
                include "unmasked_double.restore.asm"

TraceEnd:       equ $

                endmodule
