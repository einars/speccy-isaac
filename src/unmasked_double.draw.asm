                module Unmasked_double

ua_impl         macro
                ; sprite: E D A
                inc l
                inc l
                or (hl)
                ld (hl), a
                dec l
                ld a, (hl)
                or d
                ld (hl), a
                dec l
                ld a, (hl)
                or e
                ld (hl), a

                LineInc_HL

                endm

ub_impl         macro
                ; sprite: A E D

                or (hl)
                ld (hl), a
                inc l
                ld a, (hl)
                or e
                ld (hl), a
                inc l
                ld a, (hl)
                or d
                ld (hl), a
                dec l
                dec l

                LineInc_HL

                endm


Draw:
                ; BC = XY of sprite
                ; HL = sprite


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

                ; HL - sprite data (actual mask+sprite, without height-byte)
                ; DE - screen address
                ; B - height
                ; C - bit offset

                ; on return:
                ; everything messed up

                ld a, c
                add c
                add c
                ld (.jump_table+1), a


                ld (mret + 1), sp
                ld (.sp + 1), hl
.sp             ld sp, 0

                ex de, hl

                ; B, B' = height
                ; HL' = screen
                ; SP = mask + sprite

.jump_table     jr $
                ; jump table to implementations
                jp m0
                jp m1
                jp m2
                jp m3
                jp m4
                jp m5
                jp m6
                jp m7



m0
1               
                pop de
                ld a, (hl)
                or e
                ld (hl), a
                inc l
                ld a, (hl)
                or d
                ld (hl), a
                dec l

                LineInc_HL

                djnz 1b
                jp mret


m1
1               
                pop de
                xor a

                rr e
                rr d
                rra

                ; sprite: E D A'

                ua_impl

                djnz 1b
                jp mret

m2
1               pop de
                xor a
                dup 2
                  rr e
                  rr d
                  rra
                edup

                ua_impl

                djnz 1b
                jp mret

m3
1               pop de
                xor a
                dup 3
                  rr e
                  rr d
                  rra
                edup

                ua_impl

                djnz 1b
                jp mret

m4
1               pop de
                xor a
                dup 4
                  rr e
                  rr d
                  rra
                edup

                ua_impl

                djnz 1b

; avoid jump for the slowest sprite draw
mret            ld sp, 0
                ret



m5
1               pop de
                xor a
                dup 3
                  rl d
                  rl e
                  rla
                edup
                ; sprite: A E D

                ub_impl

                djnz 1b
                jp mret

m6
1               pop de
                xor a
                dup 2
                  rl d
                  rl e
                  rla
                edup
                ; sprite: A E D

                ub_impl

                djnz 1b
                jp mret

m7
1               pop de
                xor a
                rl d
                rl e
                rla
                ; sprite: A E D

                ub_impl

                djnz 1b
                jp mret

                endmodule
