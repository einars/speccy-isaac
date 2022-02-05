                module Custom

Bullet:
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
                ld hl, bullet_sprites
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
                ld hl, bullet_sprites
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

update_isaac_bullet:
                ld h, (ix + sd0)
                ld a, 2
                ;call move_in_cardinal_direction
                call move_cardinal_ht_enemy
                jc .hit_enemy
                jnz .die
                xor a
                ret
.die            ld a, sprite_death
                ret
.hit_enemy      ; i die and the enemy gets hit as well
                call enemy_hit
                ld a, sprite_death
                ret


                


                align 8
bullet_sprites:
                dg OO------
                dg -OO-----
                dg --OO----
                dg ---OO---
                dg ----OO--
                dg -----OO-
                dg ------OO
                dg ------OO ; sic, for perf reasons don't bother with jumping over sprites


                endmodule
