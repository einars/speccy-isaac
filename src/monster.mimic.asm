                module Mimic

Appear:         ; BC - coordinates
                ld de, nm_mimic_f0
                ld hl, Mimic.Update
                ld a, s_monster
                call Entity.Appear
                ld (ix + spr_ticks), 12
                ld (ix + spr_health), 7
                xor a
                ld (ix + sd0), a
                ld (ix + sd1), a
                ld (ix + sd2), a
                ld (ix + sd3), a
                ret


Update:
                call Entity.Tick

                inc (ix + sd3)
                ld a, (ix + sd3)
                and 7
                jnz 2f ; .no_leg_update
                ld a, (ix + sd0)
                inc a
                and 1
                ld (ix + sd0), a
                jz 1f
                ld hl, nm_mimic_f0
                ld (ix + spr_sprite), hl
                jr 2f

1               ld hl, nm_mimic_f1
                ld (ix + spr_sprite), hl
2
                ld a, (ix + sd1) ; distance to run
                or a
                jz .choose_new_direction

                dec a
                ld (ix + sd1), a

                ld h, (ix + sd2)
                ld a, 1
                call Entity.Move_in_cardinal_direction
                jz .moved

.choose_new_direction

                call random
                ld b, a
                and 63
                ld (ix + sd1), a ; distance to run
                ld a, b
                and 3
                ld (ix + sd2), a ; direction

.moved
                xor a
                ret


                endmodule

