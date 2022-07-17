                module Scenes

get_random_coords
                call random
                ld a, h
                and 0x5f
                add 40
                ld b, a
                ld a, l
                and 0x5f
                add 40
                ld c, a
                ret

Mimic            
                call get_random_coords
                jp Mimic.Appear

Fly             call get_random_coords
                jp Fly.Appear

Spider          call get_random_coords
                jp Spider.Appear

                endmodule
