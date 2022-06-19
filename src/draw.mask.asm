                module Mask
edc_impl        macro
                ; MASK: E D C
                ld a, b ; store B into A'
                ex af, af

                set 7, h
                ld a, (hl)
                res 7, h

                cpl
                or e
                cpl

                ld b, a

                ld a, (hl)
                and e
                or b
                ld (hl), a

                inc l

                set 7, h
                ld a, (hl)
                res 7, h
                cpl
                or d
                cpl

                ld b, a

                ld a, (hl)
                and d
                or b
                ld (hl), a

                inc l

                set 7, h
                ld a, (hl)
                res 7, h
                cpl
                or c
                cpl

                ld b, a

                ld a, (hl)
                and c
                or b
                ld (hl), a

                dec l
                dec l
                
                LineInc_HL
                ex af, af
                ld b, a

                endm


Restore:
                ; BC = XY of sprite
                ; HL = sprite
                ; restores area taken by sprite w/offscreen
                ld a, c
                sub 7
                ld c, a
                ld a, b
                sub (hl)
                inc a
                ld b, a

                call Util.Scr_of_XY

                ;; restore only pixels under mask
                ;; pretty and proper, yet slow and complicated
                ;; tried to just restore 3 chars of offscreen — it is fast — but 
                ;; tends to be v. ugly when thes sprites overlap
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

                ; MASK: E-D
                set 7, h

                ld a, (hl)
                cpl
                or e
                cpl
                ld c, a

                res 7, h
                ld a, (hl)
                and e
                or c
                ld (hl), a

                set 7, h
                inc l

                ld a, (hl)
                cpl
                or d
                cpl
                ld c, a

                res 7, h
                ld a, (hl)
                and d
                or c
                ld (hl), a

                dec l
                
                LineInc_HL

                pop de ; crap

                djnz 1b
                jp dcret

dc1:            
1               pop de ; mask

                ld c, 255
                scf
                dup 1
                  rr e
                  rr d
                  rr c
                edup

                edc_impl
                pop de ; crap

                djnz 1b
                jp dcret

dc2:            
1               pop de ; mask

                ld c, 255
                scf
                dup 2
                  rr e
                  rr d
                  rr c
                edup

                edc_impl
                pop de ; crap

                djnz 1b
                jp dcret

dc3:            
1               pop de ; mask

                ld c, 255
                scf
                dup 3
                  rr e
                  rr d
                  rr c
                edup

                edc_impl
                pop de ; crap

                djnz 1b
                jp dcret

dc4:            
1               pop de ; mask

                ld c, 255
                scf
                dup 4
                  rr e
                  rr d
                  rr c
                edup

                edc_impl
                pop de ; crap

                djnz 1b
;                jp dcret
; avoid jump for the slowest of mask-restores

dcret           ld sp, 0
                ret

dc5:            
1               pop de ; mask

                ld c, d
                ld d, e
                ld e, 255
                scf
                dup 3
                  rl c
                  rl d
                  rl e
                edup

                edc_impl

                pop de ; crap

                djnz 1b
                jp dcret

dc6:            
1               pop de ; mask
                ld c, d
                ld d, e
                ld e, 255
                scf
                dup 2
                  rl c
                  rl d
                  rl e
                edup

                edc_impl

                pop de ; crap

                djnz 1b
                jp dcret

dc7:            
1               pop de ; mask

                ld c, d
                ld d, e
                ld e, 255
                scf
                dup 1
                  rl c
                  rl d
                  rl e
                edup

                edc_impl

                pop de ; crap

                djnz 1b
                jp dcret


                endmodule



