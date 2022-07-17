ud_restore       macro
                ; inverse mask: E D C
                ld a, b
                ld (.smc + 1), a

                set 7, h
                ld a, (hl)
                and e
                ld b, a

                res 7, h


                ld a, (hl)
                cpl
                or e
                cpl
                or b
                ld (hl), a

                inc l

                set 7, h
                ld a, (hl)
                and d
                ld b, a

                res 7, h
                ld a, (hl)
                cpl
                or d
                cpl
                or b
                ld (hl), a

                inc l

                set 7, h
                ld a, (hl)
                and c
                ld b, a

                res 7, h
                ld a, (hl)
                cpl
                or c
                cpl
                or b
                ld (hl), a

                dec l
                dec l
                
                LineInc_HL
.smc            ld b, 0

                endm

                module Unmasked_double
TurboRestore:
                ; fast restore, three chars wide brutal
                ; looks ugly on overap, though
                ld a, c
                sub 7
                ld c, a
                ld a, b
                sub (hl)
                ld b, a
                call Util.Scr_of_XY
                ld c, a
                ld b, (hl)
                ex hl, de

1
                ld e, l
                ld a, h
                or 0xc0
                ld d, a
                ld a, (de)
                ld (hl), a
                inc e
                inc l
                ld a, (de)
                ld (hl), a
                inc e
                inc l
                ld a, (de)
                ld (hl), a
                dec l
                dec l
                LineInc_HL
                djnz 1b
                ret




Restore:
                ;jp TurboRestore

                ; BC = XY of sprite
                ; HL = sprite
                ; restores area taken by sprite w/offscreen
                ld a, c
                sub 7
                ld c, a
                ld a, b
                sub (hl)
                ld b, a

                call Util.Scr_of_XY

                ld c, a
                ld b, (hl)

                inc hl
                ld (dcret + 1), sp
                ld (.sp + 1), hl
.sp             ld sp, 0

                ex de, hl

                ; 47
                ld a, c
                add a, c
                add a, c
                ld (.jump_table + 1), a

                ; B = height
                ; HL = screen,
                ; HL|8000 = offscreen
                ; SP = mask + sprite
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
1               pop de ; mask
                ld c, 0
                ud_restore

                djnz 1b
                jp dcret

dc1:            
1               pop de ; mask

                xor a
                dup 1
                  rr e
                  rr d
                  rra
                edup
                ld c, a

                ud_restore

                djnz 1b
                jp dcret

dc2:            
1               pop de ; mask

                xor a
                dup 2
                  rr e
                  rr d
                  rra
                edup
                ld c, a

                ud_restore

                djnz 1b
                jp dcret

dc3:            
1               pop de

                xor a
                dup 3
                  rr e
                  rr d
                  rra
                edup
                ld c, a

                ud_restore

                djnz 1b
                jp dcret

dc4:            
1               pop de ; mask

                xor a
                dup 4
                  rr e
                  rr d
                  rra
                edup
                ld c, a

                ud_restore

                djnz 1b
;                jp dcret
; avoid jump for the slowest of mask-restores

dcret           ld sp, 0
                ret

dc5:            
1               pop de

                ld c, d
                ld d, e
                xor a
                dup 3
                  rl c
                  rl d
                  rla
                edup

                ld e, a
                ud_restore


                djnz 1b
                jp dcret

dc6:            
1               pop de
                ld c, d
                ld d, e
                xor a
                dup 2
                  rl c
                  rl d
                  rla
                edup

                ld e, a
                ud_restore


                djnz 1b
                jp dcret

dc7:            
1               pop de

                ld c, d
                ld d, e
                xor a
                dup 1
                  rl c
                  rl d
                  rla
                edup

                ld e, a
                ud_restore

                djnz 1b
                jp dcret

                endmodule

