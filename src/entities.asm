
                align 256
spritelist:     
                dup 1024 : db 0 : edup

spr_type        equ 0
spr_draw_flag   equ 1
spr_pos         equ 2
spr_x           equ 2
spr_y           equ 3
spr_speed       equ 4
spr_tick        equ 5 ; writes on every update

spr_draw        equ 6
spr_update      equ 8

spr_canary      equ 10
spr_data        equ 11
sd0             equ spr_data
sd1             equ spr_data + 1
sd2             equ spr_data + 2
sd3             equ spr_data + 3
sd4             equ spr_data + 4

spr_length      equ 16

s_nothing       equ 0
s_spider        equ 1
s_isaac        equ 0x69


appear:
                ; BC - at what pos
                ; HL — initializer func; gets ix = ptr to sprite table
                push hl
                ld hl, spritelist
                ld de, spr_length
1               ld a, (hl)
                or a
                jz found_space
                cp 255
                jz found_space
                add hl, de
                jr 1b

found_space
                push hl
                pop ix
                ;or a
                ;jz 1f ; a = 0 - this is a dead sprite place
                ld (ix + spr_length), 255
                ld (ix + spr_pos), bc
                ld (ix + spr_canary), 13
                ret ; jmp $init

map_sprites_without_isaac:
                pop hl
                ld (map_sprites.smc + 1), hl
                ld ix, spritelist + spr_length ; by convention, isaac is first
                jr map_sprites.reentry


map_sprites:
                ; stack — function to call for all sprites
                ;      IX will get the sprite pointer
                ;      Do not touch the alt. regs there thx
                pop hl
                ld (.smc + 1), hl
                ld ix, spritelist
.reentry
1               ld a, (ix)
                or a
                ret z
                inc a
                ret z

                ld a, (ix + spr_canary)
                cp 13
                jz .all_ok
                
                ld a, Color.magenta
                out (254), a
                di
                halt

.all_ok
.smc            call 0000
                ld bc, spr_length
                add ix, bc
                jr 1b



draw_sprites_ordered:
                ; this is much too slow
                ; the current algorithm is piss-poor
                ; it repeatedly does this:
                ;   - walk through all undrawn sprites, searching lowest coords
                ;   - walk through all sprites, drawing the sprites matching these coords
                ; repeat until no undrawn sprites found
                ; even some kind of bubble sort would probably be better/faster

                ; set all "walked" to zero
                ld bc, spr_length
                ld ix, spritelist
1
                ld a, (ix)
                inc a
                jz .cont
                ld (ix + spr_draw_flag), a
                add ix, bc
                jr 1b
.cont

                ; pass 1: find smallest idx for undrawn sprite
.pass1_restart
                ld hl, 0xffff ; min x, y
                ld ix, spritelist
                ld d, 0 ; found anything?
                ld bc, spr_length
                
.pass1
                ld a, (ix)
                ;or a
                ;jz .not_this
                inc a
                jz .pass1_iteration_done

                ld a, (ix + spr_draw_flag)
                or a
                jz .not_this ; already drawn

                ld a, (ix + spr_y)
                cp h
                jc .found_candidate
                jnz .not_this
                ; y match. compare x

                ;ld a, (ix + spr_x)
                ;cp l
                ;jnc .not_this

.found_candidate:
                ;ld l, (ix + spr_x)
                ld h, (ix + spr_y)
                inc d

.not_this
                add ix, bc
                jr .pass1

                ld a, (ix + spr_y)
                or a
                

.pass1_iteration_done:

                ld a, d
                or a
                ret z

                ld ix, spritelist

; pass2: call draw for all sprites that match b/c location

                ; now
                ; HL = min x, y
                ; BC = spr_length
                
                ; walk through the sprites and, if they match HL coords, draw them

.pass2_loop
                ld a, (ix)
                or a
                jz .pass2_next
                inc a
                jz .pass1_restart
                ld a, (ix + spr_y)
                cp h
                jnz .pass2_next
                ;ld a, (ix + spr_x)
                ;cp l
                ;jnz .pass2_next

                ld (ix + spr_draw_flag), 0

                push hl
                ld hl, (ix + spr_draw)
                ld (.smccall + 1), hl
.smccall        call 0
                pop hl
.pass2_next     ld bc, spr_length
                add ix, bc
                jr .pass2_loop
                



draw_sprites:
                ;call map_sprites
                call map_sprites
                ld hl, (ix + spr_draw)
                jp hl


hittest_sprites:
                ; bc - (isaac) coords
                ; hl - on hit success

                ld (.smc + 1), hl
                ld l, c
                ld h, b
                ld (.bc + 1), hl

                call map_sprites_without_isaac

                ld a, (ix + spr_x)
.bc             ld bc, 0

                add 8
                cp c
                ret c
                sub 16
                cp c
                ret nc


                ld a, (ix + spr_y)
                add 8
                cp b
                ret c

                sub 16
                cp b
                ret nc

                
.smc            call 0000
                pop bc ; eat return to map_sprites - finish iterating
                ret

                




update_sprites:
                call map_sprites

                ld a, (ix + spr_tick)
                add (ix + spr_speed)
1               cp 32
                jc noupdate

                
                push af
                ld hl, .ret
                push hl
                ld hl, (ix + spr_update)
                jp hl

.ret            pop af
                sub 32

noupdate        ld (ix + spr_tick), a
                ret


spidio db 4
                
spider_init:    
                ld (ix + spr_type), s_spider
                ld a, (spidio)
                ld (ix + spr_speed), a
                add 3
                ld (spidio), a

                ld (ix + spr_tick), 0
                ld (ix + spr_data + 1), 5
                ld hl, spider_draw
                ld (ix + spr_draw), hl
                ld hl, spider_update
                ld (ix + spr_update), hl
                ld (ix + sd0), 0 ; frame, 1 vs 0
                ld (ix + sd1), 0 ; frame counter
                ret

spider_update:
                inc (ix + sd1) ; increase leg frame switcher
                ld a, (ix + sd1)
                cp 5
                jnz .legs_done
                ld a, (ix + sd0)
                inc a
                and 1
                ld (ix + sd0), a
                ld (ix + sd1), 0

.legs_done
                ld bc, (ix + spr_pos)
                call random
                ld d, h
                ld e, l

                ld a, d
                and 7

                cp 1
                jz .yplus
                cp 2
                jz .yminus
                cp 3
                jz 1f

                ; move to isaac direction
                ld a, (ix + spr_y)
                ld hl, The.isaac_y
                cp (hl)
                jz 1f
                jc .yplus
                dec b

                jr 1f
.yplus          inc b
                jr 1f
.yminus         dec b

1               
                
                ld a, e
                and 7
                cp 1
                jz .xplus
                cp 2
                jz .xminus
                cp 3
                jz 2f

                ld a, (ix + spr_x)
                ld hl, The.isaac_x
                cp (hl)
                jz 2f
                jc .xplus
                dec c
                jr 2f
.xplus          inc c
                jr 2f
.xminus         dec c

2
                push bc
                call Room.TileAtXY
                pop bc

                and Geo.perm + Geo.wall
                ret nz

                ld (ix + spr_pos), bc

                ret

spider_draw:
                ld a, (ix + spr_x)
                sub 8
                ld c, a
                ld a, (ix + spr_y)
                sub 7
                ld b, a
                ld hl, spider_f0
                ld a, (ix + sd0)
                or a
                jz 1f
                ld hl, spider_f1
1               jp draw_masked_sprite


isaac_init:
                ld (ix + spr_type), s_isaac
                ld (ix + spr_speed), 32

                ld (ix + spr_tick), 0
                ld hl, isaac_draw
                ld (ix + spr_draw), hl
                ld hl, isaac_update
                ld (ix + spr_update), hl
                ld (ix + sd0), 0 ; frame, 1 vs 0
                ld (ix + sd1), 0 ; frame counter
                ret
                
isaac_update:   ret ; everything currently is done in Isaac.move elsewhere
isaac_draw:     
                ld a, (ix + spr_y)
                sub 20
                ld b, a

                ld a, (ix + spr_x)
                sub 8
                ld c, a

                ld hl, spl_isaac_facing
                ld a, (The.isaac_facing)
                or a
                rlca
                add l ; loc. guaranteed won't overflow
                ld l, a
                ld a, (hl)
                ld e, a
                inc hl
                ld a, (hl)
                ld d, a
                ex hl, de

                call draw_masked_sprite

                ld a, (The.isaac_y)
                sub 5
                ld b, a

                ld a, (The.isaac_x)
                sub 4
                ld c, a

                ld hl, spl_isaac_body
                ld a, (The.isaac_step)
                or a
                rlca
                add l
                ld l, a
                ld a, (hl)
                ld e, a
                inc hl
                ld a, (hl)
                ld d, a
                ex hl, de

                jp draw_masked_sprite

spl_isaac_facing
                dw isaac_up
                dw isaac_left
                dw isaac_down
                dw isaac_right
spl_isaac_body
                dw isaac_body_f0
                dw isaac_body_f1
                dw isaac_body_f2
                dw isaac_body_f3
