ma_impl         macro
                ; mask: C B C'
                ; sprite: E D E'
                ld a, (hl)
                and c
                or e
                ld (hl), a
                inc l
                ld a, (hl)
                and b
                or d
                ld (hl), a
                inc l
                ld a, (hl)
                exx
                and c
                or e
                exx
                ld (hl), a

                dec l
                dec l

                LineInc_HL
                endm
                

mb_impl         macro
                ; mask: C' C B
                ; sprite: E' E D
                ld a, (hl)
                exx
                and c
                or e
                exx
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

                ; HL - sprite
                ; DE - screen address
                ; B - height
                ; C - bit offset

                ; on return:
                ; everything messed up

double_column_masked:
                ld a, c
                add a, c
                add a, c
                ld (.jump_table+1), a

                
                ld (mret + 1), sp
                ld (.sp + 1), hl
.sp             ld sp, 0

                ex de, hl

                ld a, b ; line counter will live in a'

                ; A = B = height
                ; HL = screen
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
1               ex af, af'
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
                ex af, af'
                dec a
                jnz 1b
                jp mret

mret            ld sp, 0
                ret


m1
                break
1               ex af, af'
                pop bc
                ld a, 255
                scf
                rr c
                rr b
                rra
                exx : ld c, a : exx ; mask: C B C'
                pop de
                xor a
                rr e
                rr d
                rra
                exx : ld e, a : exx ; sprite: E D E'

                ma_impl

                ex af, af'
                dec a
                jnz 1b
                jp mret

m2
1               ex af, af'
                pop bc
                ld a, 255
                scf
                dup 2
                  rr c
                  rr b
                  rra
                edup
                exx : ld c, a : exx ; mask: C B C'
                pop de
                xor a
                dup 2
                  rr e
                  rr d
                  rra
                edup
                exx : ld e, a : exx ; sprite: E D E'

                ma_impl

                ex af, af'
                dec a
                jnz 1b
                jp mret

m3
1               ex af, af'
                pop bc
                ld a, 255
                scf
                dup 3
                  rr c
                  rr b
                  rra
                edup
                exx : ld c, a : exx ; mask: C B C'
                pop de
                xor a
                dup 3
                  rr e
                  rr d
                  rra
                edup
                exx : ld e, a : exx ; sprite: E D E'

                ma_impl

                ex af, af'
                dec a
                jnz 1b
                jp mret

m4
1               ex af, af'
                pop bc
                pop de
                ld a, 255
                scf
                dup 4
                  rr c
                  rr b
                  rra
                edup
                exx : ld c, a : exx ; mask: C B C'
                xor a
                dup 4
                  rr e
                  rr d
                  rra
                edup
                exx : ld e, a : exx ; sprite: E D E'

                ma_impl

                ex af, af'
                dec a
                jnz 1b
                jp mret

m5
1               ex af, af'
                pop bc
                pop de
                ld a, 255
                scf
                dup 3
                  rl b
                  rl c
                  rla
                edup
                exx : ld c, a : exx ; mask: C' C B
                xor a
                dup 3
                  rl d
                  rl e
                  rla
                edup
                exx : ld e, a : exx ; sprite: E' E D

                mb_impl

                ex af, af'
                dec a
                jnz 1b
                jp mret

m6
1               ex af, af'
                pop bc
                pop de
                ld a, 255
                scf
                dup 2
                  rl b
                  rl c
                  rla
                edup
                exx : ld c, a : exx ; mask: C' C B
                xor a
                dup 2
                  rl d
                  rl e
                  rla
                edup
                exx : ld e, a : exx ; sprite: E' E D

                mb_impl

                ex af, af'
                dec a
                jnz 1b
                jp mret

m7
1               ex af, af'
                pop bc
                pop de
                ld a, 255
                scf
                dup 1
                  rl b
                  rl c
                  rla
                edup
                exx : ld c, a : exx ; mask: C' C B
                xor a
                dup 1
                  rl d
                  rl e
                  rla
                edup
                exx : ld e, a : exx ; sprite: E' E D

                mb_impl

                ex af, af'
                dec a
                jnz 1b
                jp mret

