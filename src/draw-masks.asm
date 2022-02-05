dc_prelude      macro

                exx

                ld c, (hl)
                inc hl
                ld b, (hl)
                inc hl
                inc hl
                inc hl
                push hl ; 11
                ld a, 255
                scf
                endm

dc_impl         macro
                ; C B L' - mask rolled into position

                set 7, d

                ld a, (de) ; offscreen
                inc e
                cpl
                or c ; and inverse mask
                cpl
                ld l, a

                ld a, (de) ; offscreen
                inc e
                cpl
                or b ; and inverse mask
                cpl
                ld h, a

                ld a, (de) ; offscreen
                dec e
                dec e
                cpl
                exx
                or l ; and inverse mask
                cpl
                ld h, a
                exx
                ; L H H' — offscreen w/inverse mask applied

                res 7, d

                ld a, (de) ; screen
                and c ; mask
                or l  ; screen
                ld (de), a
                inc e

                ld a, (de)
                and b
                or h
                ld (de), a
                inc e

                ld a, (de)
                exx
                and l
                or h
                exx
                ld (de), a
                dec e
                dec e


                LineInc_DE

                pop hl ; 10

                exx
                endm




restore_mask_1:
                ld a, c
                sub 3
                ld c, a
                ld a, b
                sub (hl)
                ;inc a
                ld b, a

                call Util.Scr_of_XY
                ld c, a
                ld b, (hl)

                inc hl
                jp single_column_clean


restore_mask_2:
                ld a, c
                sub 7
                ld c, a
                ld a, b
                sub (hl)
                inc a
                ld b, a

                call Util.Scr_of_XY
                ld c, a
                ld b, (hl)

                inc hl

                ld a, c
                add a, c
                add a, c
                ld (.jump_table + 1), a

                ; B = height
                ; DE = screen,
                ; DE|8000 = offscreen
                ; HL = mask + sprite
.jump_table     jr $
                jp dc0
                jp dc1
                jp dc2
                jp dc3
                jp dc4
                jp dc5
                jp dc6
                jp dc7



dc0:
                ld a, b
                exx
                ld b, a
1
                dc_prelude

                exx
                ld l, a
                exx ; C B L' — rolled mask
                
                dc_impl

                djnz 1b
                ret

dc1:
                ld a, b
                exx
                ld b, a
1
                dc_prelude

                rr c
                rr b
                rra
                exx
                ld l, a
                exx ; C B L' — rolled mask
                
                dc_impl

                djnz 1b
                ret


dc2:
                ld a, b
                exx
                ld b, a
1
                dc_prelude

                rr c
                rr b
                rra
                rr c
                rr b
                rra
                exx
                ld l, a
                exx ; C B L' — rolled mask
                
                dc_impl

                djnz 1b
                exx
                ret


dc3:
                ld a, b
                exx
                ld b, a
1
                dc_prelude

                rr c
                rr b
                rra
                rr c
                rr b
                rra
                rr c
                rr b
                rra
                exx
                ld l, a
                exx ; C B L' — rolled mask
                
                dc_impl

                djnz 1b
                exx
                ret

dc4:
                ld a, b
                exx
                ld b, a
1
                dc_prelude

                dup 4
                 rr c
                 rr b
                 rra
                edup

                ; C B A — rolled mask
                exx
                ld l, a
                exx ; C B L' — rolled mask
                
                dc_impl

                djnz 1b
                exx
                ret

dc5:
                ld a, b
                exx
                ld b, a
1
                dc_prelude

                dup 5
                 rr c
                 rr b
                 rra
                edup

                exx
                ld l, a
                exx
                
                dc_impl

                djnz 1b
                exx
                ret

dc6:
                ld a, b
                exx
                ld b, a
1
                dc_prelude

                dup 6
                  rr c
                  rr b
                  rra
                edup

                exx
                ld l, a
                exx
                
                dc_impl

                djnz 1b
                exx
                ret

dc7:
                ld a, b
                exx
                ld b, a
1
                dc_prelude

                dup 7
                  rr c
                  rr b
                  rra
                edup

                exx
                ld l, a
                exx

                dc_impl

                djnz 1b
                exx
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

