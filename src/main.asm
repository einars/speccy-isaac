                display "debug: ",/A, restore_mask


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


                ; shold always be first
                ld bc, 0x3545
                call isaac_appear


                ;call Scenes.Spiders
                ;call Scenes.Spider
                ;call Scenes.Spiders2
                ;call Scenes.Isaacs3
                ;call Scenes.Isaacs4
                ;call Scenes.Isaacs7
                call Scenes.Isaacs1

                ;call Scenes.Spiders1
                ;call Scenes.Spiders2
                ;call Scenes.Spiders2

                ei
                halt

.again          

                call LoadIndicator.FrameStart

               call draw_sprites_ordered
               ;call draw_sprites_cleanest
               ;call draw_sprites_chaotic

                call LoadIndicator.FrameEnd
                ;halt ; smooth mode
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

InterruptRoutine:
                di
                ld (.stack_ret + 1), sp
                ld sp, im2.Stack
                push hl
                push de
                push bc
                push af
                push ix
                push iy
                exx
                ex af, af'
                push hl
                push de
                push bc
                push af

                call LoadIndicator.Tick

                call keyboard.Read

                call Isaac.Move

                call update_sprites

                ld hl, The.isaac_y
                ld b, (hl)
                ld hl, The.isaac_x
                ld c, (hl)
                ld hl, Isaac.OnHit
                call hittest_sprites

                ld hl, tick
                inc (hl)

                pop af
                pop bc
                pop de
                pop hl
                ex af, af'
                exx

                pop iy
                pop ix
                pop af
                pop bc
                pop de
                pop hl
.stack_ret      ld sp, 0
                ei
                reti

tick:           db 0

                include "loadindicator.asm"
                include "isaac.asm"
                include "draw.asm"
                include "keyboard.asm"

                include "entities.asm"

                include "generated-sprites.asm"


                include "room.asm"
                include "util.asm"
                include "offscreen.asm"
                include "the.asm"

                ; do not put anything after this line
                ; ----------------------------
                include "im2.asm"


	savesna "isaac.sna", Start

