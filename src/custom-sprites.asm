                module Tear

Spawn
                pushx
                ld h, a
                ld bc, (The.isaac_pos)
                ld a, b
                sub 12

                ld b, a
                ld a, h

                push af ; direction
                ld de, Tear.Draw
                ld hl, Tear.Update
                ld a, s_isaac_tear
                call appear
                pop af

                ld (ix + sd0), a
                popx
                ret
                

Draw:
                ; BC - coordinates
                ;ld bc, (ix + spr_pos)
                ; A = flag. 0 = clear, 1 = draw
                or a
                jz .clear

                ld a, b
                and 0xfe ; ensure bullet is in a single char
                ld b, a

                ld a, c
                and 7
                ld hl, Tear.sprites
                add l
                ld l, a
                ld h, (hl)

                call Util.Scr_of_XY

                ld a, (de)
                xor h
                ld (de), a
                inc d
                ld a, (de)
                xor h
                ld (de), a

                ret
.clear
                ld a, b
                and 0xfe ; ensure bullet is in a single char
                ld b, a

                ld a, c
                and 7
                ld hl, Tear.sprites
                add l
                ld l, a
                ld h, (hl)

                call Util.Scr_of_XY

                set 7, d
                ld a, (de)
                and h
                ld c, a
                inc d
                ld a, (de)
                and h
                ld b, a
                dec d
                res 7, d
                ld a, (de)
                cpl
                or h
                cpl
                or c
                ld (de), a
                inc d
                ld a, (de)
                cpl
                or h
                cpl
                or b
                ld (de), a
                ret

Update:
                ld h, (ix + sd0)
                ld a, 2
                ;call move_in_cardinal_direction
                call move_in_cardinal_direction
                jnz .die ; hit the wall
                call ht_enemy
                ret z
                ; i die and the enemy gets hit as well
                call enemy_hit
.die
                ld a, sprite_death
                ret

                align 8
sprites:
                dg OO------
                dg -OO-----
                dg --OO----
                dg ---OO---
                dg ----OO--
                dg -----OO-
                dg ------OO
                dg ------OO ; sic, for perf reasons don't bother with jumping over sprites


                endmodule
