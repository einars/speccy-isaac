                module Spider

Appear:         ; BC - coordinates
                ld de, spider_f0
                ld hl, Spider.Update
                ld a, s_monster
                call appear
                xor a
                ld (ix + sd0), a ; frame, 1/0
                ld (ix + sd1), a ; frame_counter

                ld (ix + spr_ticks), 4
                ret


Update:
                call entity_tick
                ret z

                inc (ix + sd1) ; increase leg frame switcher
                ld a, (ix + sd1)
                cp 5
                jnz .legs_done
                ld a, (ix + sd0)
                inc a
                and 1
                ld (ix + sd0), a
                ld (ix + sd1), 0
                ld hl, spider_f0
                jz .o
                ld hl, spider_f1
.o              ld (ix + spr_sprite), hl

.legs_done
                ld bc, (ix + spr_pos)
                call random
                ld de, hl

                ld a, d
                and 7

                cp 1
                jz .yplus
                cp 2
                jz .yminus
                cp 3
                jz 1f

                ; move to isaac direction
                ld a, (ix + spr_y)
                ld hl, Isaac.y
                cp (hl)
                jz 1f
                jc .yplus
                dec b

                jr 1f
.yplus          inc b
                jr 1f
.yminus         dec b

1               ld a, e
                and 7
                cp 1
                jz .xplus
                cp 2
                jz .xminus
                cp 3
                jz 2f

                ld a, (ix + spr_x)
                ld hl, Isaac.x
                cp (hl)
                jz 2f
                jc .xplus
                dec c
                jr 2f
.xplus          inc c
                jr 2f
.xminus         dec c

2
                push bc
                call Util.TileAtXY
                pop bc

                and Geo.perm + Geo.wall
                ret nz

                ld (ix + spr_pos), bc

                xor a
                ret

                endmodule
