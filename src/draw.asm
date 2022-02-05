sprite_draw:
                ; hl - sprite base + 1 (after width, looking at height)
                ; bc - bottom center -> top left
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

                ;jp double_column_masked


                include "draw-masked-2c.asm"
                include "draw-masks.asm"
