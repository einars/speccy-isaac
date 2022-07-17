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
                ld a, (Isaac.facing)
                cp 0xff
                ret z

                call adjust_for_head

                ld de, Tear.Draw
                ld hl, Tear.Update
                ld a, s_isaac_tear
                call Entity.Appear

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
                call Entity.Map
                ld a, (hl)
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
.adjustments    db  0, 0; up
                db  0,  1 ; down
                db -5,  0; left
                db  5,  0; right
                
height_adjustment equ 10


Draw:
                ; BC - coordinates
                ; A = flag. 0 = clear, 1 = draw

                or a
                jz .clear

                ld a, b
                sub Tear.height_adjustment
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
                sub Tear.height_adjustment
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
                call Entity.Move_in_cardinal_direction
                jnz .die ; hit the wall
                call Hittest_monsters
                ret z
                ; i die and the enemy gets hit as well
                ld a, (ix + sd0) ; direction
                call Entity.When_monster_hit
.die
                ld a, sprite_death
                ret


area_around_base equ 12
Hittest_monsters:
                ; bc - coordinates
                push de
                ld hl, bc
                ld (.bc + 1), hl

                ld hl, spritelist + spr_length
.loop
                ld a, (hl)
                cp 255
                jz .nothing_hit
                cp s_monster
                jnz .next

                inc hl
                ld a, (hl) ; x
.bc             ld bc, 0
                ; 10 pixels wide area around base
                add area_around_base / 2
                cp c
                jc .no_hit_dec1
                sub area_around_base
                cp c
                jnc .no_hit_dec1

                ; y pixels high
                inc hl
                ld a, (hl) ; y
                cp b
                jc .no_hit_dec2

                ex af, af'
                push hl
                inc hl
                ld a, (hl)
                inc hl
                ld h, (hl)
                ld l, a
                inc hl
                ld d, (hl) ; A = actual sprite height
                pop hl
                ex af, af'

                sub d
                cp b
                jnc .no_hit_dec2

                ; have hit!
                dec hl
                dec hl
                xor a
                dec a
                pop de
                ret

.no_hit_dec2    dec hl
.no_hit_dec1    dec hl
.next           ld bc, spr_length
                add hl, bc
                jp .loop

.nothing_hit    xor a
                pop de
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
