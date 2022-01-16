                device zxspectrum48

                org 8500h

ScreenBase equ 4000h
ScreenLines equ 182
ScreenCharsPerLine equ 32

start:
                di

                ld a, 0b110
                out (254), a


                ld hl, ScreenBase
                ld de, ScreenLines * ScreenCharsPerLine
                ld a, 0
.loop:
                ld (hl), a
                inc hl
                dec de

                dec d
                inc d
                jr nz, .loop

                dec e
                inc e
                jr nz, .loop

                ld b, 64
                ld c, 15

aga:
                ;inc c
                ld a, c
                cp 240
                jr c, 1f
                ld a, 15
1:              ld c, a
                push bc
                call Isaac
                pop bc

                push bc
                ld a, b
                add b, 30
                ld b, a
                call Isaac
                pop bc

                push bc
                ld a, b
                add b, 60
                ld b, a
                call Isaac
                pop bc

                jr aga

                ;ld de, 4004h
                ;ld c, 0
                ;call Isaac

                ;ld de, 4008h
                ;ld c, 5
                ;call Isaac

                halt

                include "sprites.asm"

	savesna "isaac.sna",start

  
; vim: set sw=16 :

