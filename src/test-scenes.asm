                module Scenes

Isaacs:
                ld bc, 0x3080
                call mimic_appear
Isaacs7:

                ld bc, 0x4071
                call mimic_appear
Isaacs6:

                ld bc, 0x5082
                call mimic_appear
Isaacs5:

                ld bc, 0x6093
                call mimic_appear
Isaacs4:

                ld bc, 0x70a4
                call mimic_appear
Isaacs3:

                ld bc, 0x80b5
                call mimic_appear

Isaacs2:

                ld bc, 0x90c6
                call mimic_appear

Isaac
Isaacs1
                ld bc, 0xa0d7
                call mimic_appear
                ret


;Spiders:
;
;                ld hl, spider_init
;                ld bc, 0x5530
;                call Spider.Appear
;
;                ld hl, spider_init
;                ld bc, 0x5530
;                call Spider.Appear
;
;                ld hl, spider_init
;                ld bc, 0x6530
;                call Spider.Appear
;
;                ld hl, spider_init
;                ld bc, 0x7530
;                call Spider.Appear
;
Spiders5
                ld bc, 0x8530
                call Spider.Appear
Spiders4
                ld bc, 0x7060
                call Spider.Appear
Spiders3
                ld bc, 0x7070
                call Spider.Appear

Spiders2
                ld bc, 0x7080
                call Spider.Appear

Spiders1
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
