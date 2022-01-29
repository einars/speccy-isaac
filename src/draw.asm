draw_masked_2:
                ; hl - sprite base

                ; bc - top left xy
                call Offscreen.MarkDirty2
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

                jp double_column_masked

draw_masked_1:
                ; hl - sprite base
                ; bc - top left xy
                call Util.Scr_of_XY
                ; de - now is screen pos
                ; a - offset


                ld c, a

                ld b, (hl)

                inc hl
                jp single_column_masked


draw_masked_custom:
                ; hl - sprite base

                ; bc - top left xy
                call Util.Scr_of_XY
                ; de - now is screen pos
                ; a - offset
                ld c, a

1               ld a, (hl)
                or a
                ret z
                ld b, a ; height
                inc hl

                ; now:
                ; DE — &screen_addr
                ; HL - &image_data (starting with mask)
                ; B - height of column
                ; C - bit offset

                push de
                push bc
                call single_column_masked
                pop bc
                pop de

                inc de
                jr 1b




                include "draw-masked-1c.asm"
                include "draw-masked-2c.asm"
