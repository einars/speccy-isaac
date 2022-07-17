; double-column masked draw routine
                module Masked_double

ma_impl         macro
                ; mask: C B A
                ; sprite: E D A'
                inc l
                inc l
                and (hl)
                ld (hl), a
                ex af, af'
                or (hl)
                ld (hl), a

                dec l

                ld a, (hl)
                and b
                or d
                ld (hl), a
                dec l
                ld a, (hl)
                and c
                or e
                ld (hl), a

                LineInc_HL
                endm


mb_impl         macro
                ; mask: A C B
                ; sprite: A' E D
                and (hl)
                ld (hl), a
                ex af, af'
                or (hl)
                ld (hl), a
                inc l
                ld a, (hl)
                and c
                or e
                ld (hl), a
                inc l
                ld a, (hl)
                and b
                or d
                ld (hl), a

                dec l
                dec l

                LineInc_HL
                endm

Draw:
                ; BC = XY of sprite
                ; HL = sprite

                ; on return:
                ; everything messed up

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
                add c
                add c
                ld (.jump_table+1), a


                ld (mret + 1), sp
                ld (.sp + 1), hl
.sp             ld sp, 0

                ex de, hl

                ld a, b ; line counter will live in b'

                exx
                ld b, a

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
1               exx
                pop bc
                pop de
                ld a, (hl)
                and c
                or e
                ld (hl), a
                inc l
                ld a, (hl)
                and b
                or d
                ld (hl), a
                dec l

                LineInc_HL
                exx
                djnz 1b
                jp mret


m1
1               exx
                pop bc
                ld a, 255
                scf
                rr c
                rr b
                rra
                ex af, af'
                pop de
                xor a
                rr e
                rr d
                rra
                ex af, af'
                ; mask: C B A
                ; sprite: E D A'

                ma_impl

                exx
                djnz 1b
                jp mret

m2
1               exx
                pop bc
                ld a, 255
                scf
                dup 2
                  rr c
                  rr b
                  rra
                edup
                ex af, af'
                pop de
                xor a
                dup 2
                  rr e
                  rr d
                  rra
                edup
                ex af, af'

                ma_impl

                exx
                djnz 1b
                jp mret

m3
1               exx
                pop bc
                ld a, 255
                scf
                dup 3
                  rr c
                  rr b
                  rra
                edup
                ex af, af'
                pop de
                xor a
                dup 3
                  rr e
                  rr d
                  rra
                edup
                ex af, af'

                ma_impl

                exx
                djnz 1b
                jp mret

m4
1               exx
                pop bc
                pop de
                ld a, 255
                scf
                dup 4
                  rr c
                  rr b
                  rra
                edup
                ex af, af'
                xor a
                dup 4
                  rr e
                  rr d
                  rra
                edup
                ex af, af'

                ma_impl

                exx
                djnz 1b
                ;jp mret

; avoid jump for the slowest sprite draw rtn
mret            ld sp, 0
                ret



m5
1               exx
                pop bc
                pop de
                ld a, 255
                scf
                dup 3
                  rl b
                  rl c
                  rla
                edup
                ex af, af
                xor a
                dup 3
                  rl d
                  rl e
                  rla
                edup
                ex af, af'
                ; mask: A C B
                ; sprite: A' E D

                mb_impl

                exx
                djnz 1b
                jp mret

m6
1               exx
                pop bc
                pop de
                ld a, 255
                scf
                dup 2
                  rl b
                  rl c
                  rla
                edup
                ex af, af
                xor a
                dup 2
                  rl d
                  rl e
                  rla
                edup
                ex af, af

                mb_impl

                exx
                djnz 1b
                jp mret

m7
1               exx
                pop bc
                pop de
                ld a, 255
                scf
                dup 1
                  rl b
                  rl c
                  rla
                edup
                ex af, af
                xor a
                dup 1
                  rl d
                  rl e
                  rla
                edup
                ex af, af

                mb_impl

                exx
                djnz 1b
                jp mret

                endmodule
