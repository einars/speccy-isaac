restore_mask:
                ld a, (hl)
                inc hl
                cp 1
                jp z, restore_mask_1
                jp restore_mask_2


sprite_draw:
                ; hl - sprite base
                ; BC - coordinates of bottom pixel
                ld a, (hl)
                inc hl
                cp 1
                jz draw_masked_1
                
draw_masked_2:
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

                jp double_column_masked

draw_masked_1:
                ; hl - sprite base + 1
                ; bc - bottom center -> top left
                ld a, c
                sub 3
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
                include "draw-masks.asm"
