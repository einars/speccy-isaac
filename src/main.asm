                device zxspectrum48

                include "macros.asm"

                org 8000h

Start:          jr 1f

                ei
                di
                rst 0
                ; made in Latvia

1

                call Offscreen.SetAttributes

                call Offscreen.Build
                call Offscreen.Draw

                ld de, InterruptRoutine
                call im2.Setup


                ld a, Color.black
                out (254), a

                call text.Debug

                ; shold always be first
                ld bc, 0x3545
                call isaac_appear


                ;call Scenes.Isaacs2
                call Scenes.Isaacs3
                ;call Scenes.Isaacs1
                ;call Scenes.Isaacs3
                ;; call Scenes.Spiders3
                ;call Scenes.Spiders2

                ei
                halt

.again          

                call BlinkDo
                ;call LoadIndicator.FrameStart

                di
                call draw_sprites_chaotic
                ;call draw_sprites_all
                ei

                ld a, Color.green
                call DebugLine
                call keyboard.Read
                ld a, Color.green
                call DebugLine

                call Logic ; out of interrupt, end of screen

                halt


                ;call LoadIndicator.FrameEnd

                ; ld b, 25 : halt : djnz 1b

                jr .again

                include "test-scenes.asm"

seed            dw 1245
random:        
                ld de, (seed)
                ld a, d
                ld h, e
                ld l, 0xfd
                or a
                sbc hl, de
                sbc hl, de
                ld d, 0
                sbc a, d
                ld e, a
                sbc hl, de
                jnc 1f
                inc hl
1               ld (seed), hl
                ret

Logic:
                call Isaac.Move

                call Update_sprites

                ld hl, Isaac.y
                ld b, (hl)
                ld hl, Isaac.x
                ld c, (hl)
                ld hl, Isaac.OnHit
                call hittest_sprites
                ret

bg              db 0
bg_counter      db 0
Blink:          ld (bg), a
                ld a, 4
                ld (bg_counter), a
                ret

BlinkDo:        ld a, (bg)
                or a
                ret z
                out (254), a
                ld a, (bg_counter)
                dec a
                ld (bg_counter), a
                ret nz
                out (254), a ; 0
                ld (bg), a 
                ret

DebugLine:
                ;ret
                push bc
                out (254), a
                ld b, 12
                nop
                djnz $-1
                ld a, 0
                out (254), a
                pop bc
                ret

InterruptRoutine:
                di
                pushx
                push af

                ;call keyboard.Read

                ld hl, tick
                inc (hl)

                pop af
                popx

                ei
                reti

tick:           db 0

                include "loadindicator.asm"
                include "isaac.asm"
                include "draw.asm"
                include "keyboard.asm"
                include "text.asm"

                include "entities.asm"

                include "generated-sprites.asm"
                include "custom.tear.asm"
                include "monster.spider.asm"


                include "room.asm"
                include "util.asm"
                include "offscreen.asm"
                include "im2.asm"
                include "the.asm"


	savesna "isaac.sna", Start
	;;savetap "isaac.tap", Start

