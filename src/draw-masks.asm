dca_impl        macro
                ; MASK: E D C
                set 7, h

                ld a, (hl)
                cpl
                or e
                cpl
                exx : ld e, a : exx

                inc l

                ld a, (hl)
                cpl
                or d
                cpl
                exx : ld d, a : exx

                inc l

                ld a, (hl)
                cpl
                or c
                cpl
                exx : ld c, a : exx
                ; OFFSCREEN: E' D' C'

                dec l
                dec l
                res 7, h

                ld a, (hl)
                and e
                exx : or e : exx
                ld (hl), a

                inc l
                ld a, (hl)
                and d
                exx : or d : exx
                ld (hl), a

                inc l
                ld a, (hl)
                and c
                exx : or c : exx
                ld (hl), a

                dec l
                dec l
                
                LineInc_HL

                endm

dcb_impl        macro
                ; MASK: C E D
                set 7, h

                ld a, (hl)
                cpl
                or c
                cpl
                exx : ld c, a : exx

                inc l

                ld a, (hl)
                cpl
                or e
                cpl
                exx : ld e, a : exx

                inc l

                ld a, (hl)
                cpl
                or d
                cpl
                exx : ld d, a : exx
                ; OFFSCREEN: C' E' D'

                dec l
                dec l
                res 7, h

                ld a, (hl)
                and c
                exx : or c : exx
                ld (hl), a

                inc l
                ld a, (hl)
                and e
                exx : or e : exx
                ld (hl), a

                inc l
                ld a, (hl)
                and d
                exx : or d : exx
                ld (hl), a

                dec l
                dec l
                
                LineInc_HL

                endm


restore_mask:
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
                ld (dcret + 1), sp
                ld (.sp + 1), hl
.sp             ld sp, 0

                ex de, hl

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

                ; MASK: E D
                set 7, h

                ld a, (hl)
                cpl
                or e
                cpl
                ld c, a

                inc l

                ld a, (hl)
                cpl
                or d
                cpl
                exx : ld c, a : exx
                ; offscreen: C C'

                dec l

                res 7, h

                ld a, (hl)
                and e
                or c
                ld (hl), a

                inc l

                ld a, (hl)
                and d
                exx : or c : exx
                ld (hl), a

                dec l
                
                LineInc_HL

                pop de ; crap

                djnz 1b
                jp dcret

dc1:            
1               pop de ; mask

                xor a
                dec a
                dup 1
                  rr e
                  rr d
                  rra
                edup
                ld c, a

                dca_impl
                pop de ; crap

                djnz 1b
                jp dcret

dc2:            
1               pop de ; mask

                xor a
                dec a
                dup 2
                  rr e
                  rr d
                  rra
                edup
                ld c, a

                dca_impl
                pop de ; crap

                djnz 1b
                jp dcret

dc3:            
1               pop de ; mask

                xor a
                dec a
                dup 3
                  rr e
                  rr d
                  rra
                edup
                ld c, a

                dca_impl
                pop de ; crap

                djnz 1b
                jp dcret

dc4:            
1               pop de ; mask

                xor a
                dec a
                dup 4
                  rr e
                  rr d
                  rra
                edup
                ld c, a

                dca_impl
                pop de ; crap

                djnz 1b
;                jp dcret
; avoid jump for the slowest of mask-restores

dcret           ld sp, 0
                ret

dc5:            
1               pop de ; mask

                xor a
                dec a
                dup 3
                  rl d
                  rl e
                  rla
                edup
                ld c, a

                dcb_impl ; offscreen: C E D

                pop de ; crap

                djnz 1b
                jp dcret

dc6:            
1               pop de ; mask

                xor a
                dec a
                dup 2
                  rl d
                  rl e
                  rla
                edup
                ld c, a

                dcb_impl ; offscreen: C E D

                pop de ; crap

                djnz 1b
                jp dcret

dc7:            
1               pop de ; mask

                xor a
                dec a
                dup 1
                  rl d
                  rl e
                  rla
                edup
                ld c, a

                dcb_impl ; offscreen: C E D

                pop de ; crap

                djnz 1b
                jp dcret





