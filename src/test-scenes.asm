                module Scenes

Isaacs:
                ld hl, isaac_init
                ld bc, 0x2080
                call appear

                ld hl, isaac_init
                ld bc, 0x3081
                call appear

                ld hl, isaac_init
                ld bc, 0x4082
                call appear

                ld hl, isaac_init
                ld bc, 0x5083
                call appear

                ld hl, isaac_init
                ld bc, 0x6084
                call appear

                ld hl, isaac_init
                ld bc, 0x7085
                call appear

                ld hl, isaac_init
                ld bc, 0x8086
                call appear

                ld hl, isaac_init
                ld bc, 0x9087
                call appear
                ret


Spiders:

                ld hl, spider_init
                ld bc, 0x5530
                push bc
                call appear

                ld hl, spider_init
                ld bc, 0x5530
                call appear

                ld hl, spider_init
                ld bc, 0x6530
                call appear

                ld hl, spider_init
                ld bc, 0x7530
                call appear

                ld hl, spider_init
                ld bc, 0x8530
                call appear


                ld hl, spider_init
                ld bc, 0x7060
                call appear

                ld hl, spider_init
                ld bc, 0x7070
                call appear

                ld hl, spider_init
                ld bc, 0x7080
                call appear

                ld hl, spider_init
                ld bc, 0x7090
                call appear
                ret

                ld hl, spider_init
                ld bc, 0x7090
                call appear
                ret


/*

                ld hl, spider_init
                ld bc, 0x55d0
                call appear

                ld hl, spider_init
                ld bc, 0x65d0
                call appear

                ld hl, spider_init
                ld bc, 0x75d0
                call appear

                ld hl, spider_init
                ld bc, 0x85d0
                call appear

                ld hl, spider_init
                ld bc, 0x55e0
                call appear

                ld hl, spider_init
                ld bc, 0x65e0
                call appear

                ld hl, spider_init
                ld bc, 0x75e0
                call appear

                ld hl, spider_init
                ld bc, 0x85e0
                call appear
*/
                endmodule
