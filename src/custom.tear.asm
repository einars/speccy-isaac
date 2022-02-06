                module Tear

Spawn
                pushx

                call n_tears_on_screen
                and a
                jz 1f

                ld hl, Isaac.tear_limit
                cp (hl)

                jp nc, .enough
1
                ld bc, (Isaac.pos)
                ld a, b
                sub tear_isaac_adj
                ld b, a
                ld a, (Isaac.facing)
                cp 0xff
                ret z

                call adjust_for_head

                ld de, Tear.Draw
                ld hl, Tear.Update
                ld a, s_isaac_tear
                call appear

                ld a, (Isaac.facing)
                ld (ix + sd0), a
.enough
                popx
                ret

n_tears_on_screen:
                xor a
                ld (.count + 1), a
                call .tears_count_impl
.count          ld a, 0
                ret
.tears_count_impl
                call map_sprites_without_isaac
                ld a, (ix)
                cp s_isaac_tear
                ret nz
                ld hl, .count + 1
                inc (hl)
                ret


adjust_for_head:
                ; in: BC - tear coordinates
                ; out: 
                ; dirties HL
                ;break
                ld hl, .adjustments
                ld a, (Isaac.facing)
                rlca
                add l
                ld l, a
                ld a, (hl)
                add c
                ld c, a
                inc hl
                ld a, (hl)
                add b
                ld b, a
                ret

                align 8
.adjustments    db  0, -5; up
                db  0,  5 ; down
                db -5,  0 ; left
                db  5,  0 ; right
                


tear_isaac_adj  equ 10 ; move actual coord up this much
tear_visual_adj equ 0 ; and, extra visual adjustment

Draw:
                ; BC - coordinates
                ;ld bc, (ix + spr_pos)
                ; A = flag. 0 = clear, 1 = draw
                or a
                jz .clear

                ld a, b
                sub tear_visual_adj
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
                sub tear_visual_adj
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
                ld a, (ix + sd0) ; direction
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
