                module Poof

poof_duration equ 6

Appear:         ; BC - coordinates
                ld de, nm_poof_f0
                ld hl, Poof.Update
                ld a, s_decoration
                call Entity.Appear
                ld (ix + spr_health), 255
                ld (ix + sd0), poof_duration ; frames
                ld (ix + sd1), 2 ; frame counter
                ret


Update:
                dec (ix + sd0) ; increase leg frame switcher
                ld a, (ix + sd0)
                or a
                jz .next_poof
                xor a
                ret

.next_poof
                dec (ix + sd1)
                jz .die

                ld (ix + sd0), poof_duration

                ld hl, nm_poof_f1
                ld (ix + spr_sprite), hl
                xor a
                ret


.die
                ld a, sprite_death
                ret

                endmodule
