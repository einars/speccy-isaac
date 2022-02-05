restore_mask_1:
                ld a, c
                sub 4
                ld c, a
                ld a, b
                sub (hl)
                ld b, a

                call Util.Scr_of_XY
                ld c, a
                ld b, (hl)

                inc hl
                jp single_column_clean


restore_mask_2:
                ld a, c
                sub 8
                ld c, a
                ld a, b
                sub (hl)
                ld b, a

                call Util.Scr_of_XY
                ld c, a
                ld b, (hl)

                inc hl

                ld a, b
                di
                ld (sp_ret + 1), sp
                ld (.sp + 1), hl
.sp             ld sp, 0

                ;jp double_column_clean



double_column_clean:
                ; DE = screen, DE|8000 = offscreen, HL = sprite

1
                ex af,af

                pop bc
                
                set 7, d

                ld a, (de) ; offscreen
                inc de
                cpl
                or c ; and inverse mask
                cpl
                ld l, a

                ld a, (de) ; offscreen
                dec de
                cpl
                or b ; and inverse mask
                cpl
                ld h, a

                res 7, d

                ld a, (de) ; screen
                and c ; mask
                or l  ; screen
                ld (de), a
                inc de

                ld a, (de)
                and b
                or h
                ld (de), a
                dec de

                LineInc_DE

                pop bc
                
                ex af, af
                dec a
                jp nz, 1b
                ; jp sp_ret

sp_ret          ld sp, 0
                ei
                ret

single_column_clean:
                ex de, hl; HL = screen, DE = sprite
                ld a, b
1
                ex af,af

                ld a, (de)
                inc de
                ld c, a ; c = mask

                set 7, h
                ld a, (hl) ; offscreen
                res 7, h
                cpl
                or c ; and inverse mask
                cpl
                ld b, a
                ld a, (hl) ; screen
                and c ; mask
                or b  ; screen
                ld (hl), a

                inc de

                LineInc_HL
                
                ex af, af
                dec a
                jp nz, 1b
                ret
