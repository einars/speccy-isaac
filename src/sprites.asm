      include "utils.asm"

                include "sprite-isaac.asm"
Isaac:
                ; BC: x, y; base of the legs

                push bc
                ld a, c
                sub 8
                ld c, a
                ld a, b
                sub 21
                ld b, a
                call xy_to_pos
                ld c, a
                ex hl, de

                push de

                ld hl, head_c1
                ld b, 16
                call sprite_1ch

                pop de
                inc de

                ld hl, head_c2
                ld b, 16
                call again

                pop bc
                ld a, c
                sub 4
                ld c, a
                ld a, b
                sub 5
                ld b, a
                call xy_to_pos
                ld c, a
                ex hl, de

                ld hl, body
                ld b, 5
                call sprite_1ch

                ret


xy_to_pos:      ; b = y (0..191)
                ; c = x (0..255)
                ; out:
                ; HL - screen address
                ; A - scroll offset

                ld  h, 0
                ld  l, b            ; hl = row
                add hl, hl          ; hl = row number * 2
                ld  de, screen_map  ; de = screen map
                add hl, de          ; de = screen_map + (row * 2)
                ld  a, (hl)         ; ld hl, (hl)
                inc hl
                ld  h, (hl)
                ld  l, a            ; hl = address of first pixel in screen map

                ld  d, 0
                ld  a, c
                rrca
                rrca
                rrca
                and 0b00011111
                ld e, a             ; de = X (character based)
                add hl, de          ; hl = screen addr + 32
                ld a, c
                and 7
                ret


                ; kills hl, bc, de
sprite_1ch:     ld a, c
                add a, c
                add a, c
                ld (again+1), a
again:          jr $
                ; jump table to unwrapped implementations
                jp s1_0
                jp s1_1
                jp s1_2
                jp s1_3
                jp s1_4
                jp s1_5
                jp s1_6
                jp s1_7

s1_0:
                ld a, (hl)
                ld (de), a

                LineInc_DE

                inc hl
                djnz s1_0
                ret

s1_1:           ld a, (hl)
                rrca
                ld c, a
                and 0b01111111
                ex hl, de
                or (hl)
                ex hl, de
                ld (de), a

                inc de

                ld a, c
                and 0b10000000
                ex hl, de
                or (hl)
                ex hl, de
                ld (de), a

                dec de

                LineInc_DE
                inc hl

                djnz s1_1
                ret

s1_2:           ld a, (hl)
                rrca
                rrca
                ld c, a
                and 0b00111111
                ex hl, de
                or (hl)
                ex hl, de
                ld (de), a

                inc de

                ld a, c
                and 0b11000000
                ex hl, de
                or (hl)
                ex hl, de
                ld (de), a

                dec de

                LineInc_DE
                inc hl

                djnz s1_2
                ret

s1_3:           ld a, (hl)
                rrca
                rrca
                rrca
                ld c, a
                and 0b00011111
                ex hl, de
                or (hl)
                ex hl, de
                ld (de), a

                inc de

                ld a, c
                and 0b11100000
                ex hl, de
                or (hl)
                ex hl, de
                ld (de), a

                dec de

                LineInc_DE
                inc hl

                djnz s1_3
                ret

s1_4:           ld a, (hl)
                rrca
                rrca
                rrca
                rrca
                ld c, a
                and 0b00001111
                ex hl, de
                or (hl)
                ex hl, de
                ld (de), a

                inc de

                ld a, c
                and 0b11110000
                ex hl, de
                or (hl)
                ex hl, de
                ld (de), a

                dec de

                LineInc_DE
                inc hl

                djnz s1_4
                ret


s1_5:           ld a, (hl)
                rlca
                rlca
                rlca
                ld c, a
                and 0b00000111
                ex hl, de
                or (hl)
                ex hl, de
                ld (de), a

                inc de

                ld a, c
                and 0b11111000
                ex hl, de
                or (hl)
                ex hl, de
                ld (de), a

                dec de

                LineInc_DE
                inc hl

                djnz s1_5
                ret

s1_6:           ld a, (hl)
                rlca
                rlca
                ld c, a
                and 0b00000011
                ex hl, de
                or (hl)
                ex hl, de
                ld (de), a

                inc de

                ld a, c
                and 0b11111100
                ex hl, de
                or (hl)
                ex hl, de
                ld (de), a

                dec de

                LineInc_DE
                inc hl

                djnz s1_6
                ret

s1_7:           ld a, (hl)
                rlca
                ld c, a
                and 0b00000001
                ex hl, de
                or (hl)
                ex hl, de
                ld (de), a

                inc de

                ld a, c
                and 0b11111110
                ex hl, de
                or (hl)
                ex hl, de
                ld (de), a

                dec de

                LineInc_DE
                inc hl

                djnz s1_7
                ret

screen_map:
                dw 4000h, 4100h, 4200h, 4300h
                dw 4400h, 4500h, 4600h, 4700h
                dw 4020h, 4120h, 4220h, 4320h
                dw 4420h, 4520h, 4620h, 4720h
                dw 4040h, 4140h, 4240h, 4340h
                dw 4440h, 4540h, 4640h, 4740h
                dw 4060h, 4160h, 4260h, 4360h
                dw 4460h, 4560h, 4660h, 4760h
                dw 4080h, 4180h, 4280h, 4380h
                dw 4480h, 4580h, 4680h, 4780h
                dw 40A0h, 41A0h, 42A0h, 43A0h
                dw 44A0h, 45A0h, 46A0h, 47A0h
                dw 40C0h, 41C0h, 42C0h, 43C0h
                dw 44C0h, 45C0h, 46C0h, 47C0h
                dw 40E0h, 41E0h, 42E0h, 43E0h
                dw 44E0h, 45E0h, 46E0h, 47E0h
                dw 4800h, 4900h, 4A00h, 4B00h
                dw 4C00h, 4D00h, 4E00h, 4F00h
                dw 4820h, 4920h, 4A20h, 4B20h
                dw 4C20h, 4D20h, 4E20h, 4F20h
                dw 4840h, 4940h, 4A40h, 4B40h
                dw 4C40h, 4D40h, 4E40h, 4F40h
                dw 4860h, 4960h, 4A60h, 4B60h
                dw 4C60h, 4D60h, 4E60h, 4F60h
                dw 4880h, 4980h, 4A80h, 4B80h
                dw 4C80h, 4D80h, 4E80h, 4F80h
                dw 48A0h, 49A0h, 4AA0h, 4BA0h
                dw 4CA0h, 4DA0h, 4EA0h, 4FA0h
                dw 48C0h, 49C0h, 4AC0h, 4BC0h
                dw 4CC0h, 4DC0h, 4EC0h, 4FC0h
                dw 48E0h, 49E0h, 4AE0h, 4BE0h
                dw 4CE0h, 4DE0h, 4EE0h, 4FE0h
                dw 5000h, 5100h, 5200h, 5300h
                dw 5400h, 5500h, 5600h, 5700h
                dw 5020h, 5120h, 5220h, 5320h
                dw 5420h, 5520h, 5620h, 5720h
                dw 5040h, 5140h, 5240h, 5340h
                dw 5440h, 5540h, 5640h, 5740h
                dw 5060h, 5160h, 5260h, 5360h
                dw 5460h, 5560h, 5660h, 5760h
                dw 5080h, 5180h, 5280h, 5380h
                dw 5480h, 5580h, 5680h, 5780h
                dw 50A0h, 51A0h, 52A0h, 53A0h
                dw 54A0h, 55A0h, 56A0h, 57A0h
                dw 50C0h, 51C0h, 52C0h, 53C0h
                dw 54C0h, 55C0h, 56C0h, 57C0h
                dw 50E0h, 51E0h, 52E0h, 53E0h
                dw 54E0h, 55E0h, 56E0h, 57E0h

; vim: set sw=16 ts=16 :
