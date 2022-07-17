                module Scenes

Mimic7:

                ld bc, 0x4071
                call Mimic.Appear
Mimic6:

                ld bc, 0x5082
                call Mimic.Appear
Mimic5:

                ld bc, 0x6093
                call Mimic.Appear
Mimic4:

                ld bc, 0x70a4
                call Mimic.Appear
Mimic3:

                ld bc, 0x80b5
                call Mimic.Appear

Mimic2:

                ld bc, 0x90c6
                call Mimic.Appear

Mimic1:
Mimic:
                ld bc, 0xa0d7
                call Mimic.Appear
                ret


Spider5
                ld bc, 0x8530
                call Spider.Appear
Spider4
                ld bc, 0x7060
                call Spider.Appear
Spider3
                ld bc, 0x7070
                call Spider.Appear

Spider2
                ld bc, 0x7080
                call Spider.Appear

Spider1
Spider
                ld bc, 0x7090
                call Spider.Appear
                ret
;
;
;
;
;/*
;
;                ld hl, spider_init
;                ld bc, 0x55d0
;                call appear
;
;                ld hl, spider_init
;                ld bc, 0x65d0
;                call appear
;
;                ld hl, spider_init
;                ld bc, 0x75d0
;                call appear
;
;                ld hl, spider_init
;                ld bc, 0x85d0
;                call appear
;
;                ld hl, spider_init
;                ld bc, 0x55e0
;                call appear
;
;                ld hl, spider_init
;                ld bc, 0x65e0
;                call appear
;
;                ld hl, spider_init
;                ld bc, 0x75e0
;                call appear
;
;                ld hl, spider_init
;                ld bc, 0x85e0
;                call appear
;*/
                endmodule
