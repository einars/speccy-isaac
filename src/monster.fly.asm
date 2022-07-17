                module Fly

Appear:         ; BC - coordinates
                ld de, nm_fly_f0
                ld hl, Fly.Update
                ld a, s_monster
                call Entity.Appear
                xor a
                ld (ix + spr_health), 1
                ld (ix + sd0), a ; frame, 1/0
                ld (ix + sd1), a ; frame_counter

                call random
                and 0x03
                add 4
                ld (ix + spr_ticks), a
                ret


Update:
                call Entity.Tick
                ret z

                inc (ix + sd1) ; increase leg frame switcher
                ld a, (ix + sd1)
                cp 5
                jnz .no_sprite_change
                ld a, (ix + sd0)
                inc a
                and 1
                ld (ix + sd0), a
                ld (ix + sd1), 0
                ld hl, nm_fly_f0
                jz .o
                ld hl, nm_fly_f1
.o              ld (ix + spr_sprite), hl


.no_sprite_change
                ld bc, (ix + spr_pos)
                ld a, (ix + spr_y)
                ld hl, Isaac.y
                cp (hl)
                jz 1f
                jc .yplus
                dec b

                jr 1f
.yplus          inc b

1
                ld a, (ix + spr_x)
                ld hl, Isaac.x
                cp (hl)
                jz 2f
                jc .xplus
                dec c
                jr 2f
.xplus          inc c

2
                ld (ix + spr_pos), bc

                xor a
                ret

                endmodule
