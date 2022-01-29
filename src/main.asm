                display "debug: ",/A, Offscreen.RestoreDirty


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
                ld hl, isaac_init
                ld bc, 0x4045
                push bc
                call appear


                ;call Scenes.Spider
                ;call Scenes.Spiders2
                ;call Scenes.Spiders
                ;call Scenes.Isaacs


                ei

.again          

                ld a, (tick)
                push af
                ;ld a, Color.red
                ;out (254), a
                call Offscreen.RestoreDirty
                call draw_sprites_ordered
                ;ld a, Color.green
                ;out (254), a
                pop af
                ld hl, tick
                cp (hl)
                jnz .again ; redraw is slow, interrupt missed - no messing with halt


                ;ld a, Color.white
                ;out (254), a
                ;ld b, 20
                ;djnz $
                ;ld a, Color.red
                ;out (254), a

                halt ; smooth mode

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
                ei
                reti

tick:           db 0

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

