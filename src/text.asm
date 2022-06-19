                module text
Debug:
                ld hl, text_debug_0
                ld bc, 0x0006 + 0x0100
                call Write

                ld hl, text_debug_1
                ld bc, 0x0a06 + 0x0100
                call Write

                ld hl, text_debug_2
                ld bc, 0x0a06 + 0x0a00 + 0x0100
                call Write
                ret

text_debug_0    db "WOW, ALPHABET ACTUALLY WORKS!", 0
text_debug_1    db "DOES THIS MEAN THAT THIS PROJECT IS NOT DEAD?", 0
text_debug_2    db "YES, PROBABLY. LAST CHANGES: 2022-06-19", 0


Write:
1
                ; HL — pointer to text (zero-terminated)
                ; BC — screen coordinates

                ld a, (hl)
                or a
                ret z


                push hl
                ; get letter
                ; ld hl, sample_letter
                call get_letter


                ld a, (hl) ; width
                ex af, af ; A' = width. for next char position calculation later
                inc hl

                call Util.Scr_of_XY
                ; DE = screen address
                ; A = offset, 0..8
                push bc

smc_height      equ $ + 1
                ld b, 7
                ld c, a

2
                push hl

                ld h, (hl)
                ld l, 0

                call shr_hl_c

                ld a, (de)
                or h
                ld (de), a
                inc e
                ld a, (de)
                or l
                ld (de), a
                dec e
                call Util.LineincDE

                pop hl
                inc hl
                djnz 2b
                
                pop bc
                ex af, af
                add c
                ld c, a

                pop hl
                inc hl
                jp 1b


shr_hl_c:
                ld a, c
                or a
1
                ret z
                rr h
                rr l
                dec a
                jp 1b

get_letter:     ; in: A - letter
                ; out: HL = base
                ld hl, smc_height
                ld (hl), 7

                ; comma get special treatment as it goes out of bounds
                cp ','
                jz .comma
                ;jp .unknown

                ;cp ' '
                ;jc 1f

                ;cp 'Z'+1
                ;jnc 1f

                ; A..Z!
                ; HL = Alphabet.Base + 8 * A

                ld hl, Alphabet.Base
                sub ' '

                push de
                ld d, 0
                ld e, a
                add hl, de
                add hl, de
                add hl, de
                add hl, de
                add hl, de
                add hl, de
                add hl, de
                add hl, de
                pop de

                ;push de
                ;ld d, 0
                ;add a ; x2
                ;add a ; x4
                ;add a ; x8
                ;ld e, a
                ;add hl, de
                ;pop de

                ret
                

1               
.unknown         
                ld hl, Alphabet.Unknown
                ret

.comma          
                ld (hl), 8
                ld hl, Alphabet.CustomComma
                ret

                include "text.alphabet.asm"
                endmodule

