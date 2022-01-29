                module Scenes

Isaacs:
                ld hl, isaac_init
                ld bc, 0x3080
                call appear

                ld hl, isaac_init
                ld bc, 0x4081
                call appear

                ld hl, isaac_init
                ld bc, 0x5082
                call appear

                ld hl, isaac_init
                ld bc, 0x6083
                call appear

                ld hl, isaac_init
                ld bc, 0x7084
                call appear

                ld hl, isaac_init
                ld bc, 0x8085
                call appear

                ld hl, isaac_init
                ld bc, 0x9086
                call appear

                ld hl, isaac_init
                ld bc, 0xa087
                call appear
                ret


Spiders:

                ld hl, spider_init
                ld bc, 0x5530
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

Spiders2:
                ld hl, spider_init
                ld bc, 0x7080
                call appear


Spider:
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
