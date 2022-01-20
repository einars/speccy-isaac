
                align 256
spritelist:     
                dup 1024 : db 0 : edup
                
                display "spritelist: ",/A,spritelist

; 9..15 bytes for an entity pers. data should be nuff? 
spr_type        equ 0
spr_pos         equ 1
spr_x           equ 1
spr_y           equ 2
spr_speed       equ 3
spr_tick        equ 4 ; writes on every update

spr_draw        equ 5
spr_update      equ 7

spr_canary      equ 9
spr_data        equ 10
sd0             equ spr_data
sd1             equ spr_data + 1
sd2             equ spr_data + 2
sd3             equ spr_data + 3
sd4             equ spr_data + 4
sd5             equ spr_data + 5
;sd6             equ spr_data + 6

spr_length      equ 16

s_nothing       equ 0
s_spider        equ 1


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

map_sprites:
                ; stack — function to call for all sprites
                ;      IX will get the sprite pointer
                ;      Do not touch the alt. regs there thx
                pop hl
                ld (.smc + 1), hl
                exx
                ld hl, spritelist
                ld bc, 16
1               ld a, (hl)
                or a
                jz .done
                inc a
                jz .done

                push hl ; ix = sprite address
                pop ix

                ld a, (ix + spr_canary)
                cp 13
                jz .all_ok
                
                ld a, Color.magenta
                out (254), a
                di
                halt

.all_ok
                exx
.smc            call 0000
                exx
                add hl, bc
                jr 1b
.done           exx
                ret

draw_sprites:
                call map_sprites
                ld hl, (ix + spr_draw)
                jp hl


hittest_sprites:
                ; bc - (isaac) coords
                ; hl - on hit success

                ld (.smc + 1), hl

                call map_sprites

                ld a, (ix + spr_x)

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

                ; break out of map_sprites
.smc            call 0000
                pop bc
                ret

                ; loop all the sprites
;                push bc
;.smc            call 0000
;                pop bc
;                ret
                




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
                ld bc, (ix + spr_pos)
                ld a, c
                sub 8
                ld c, a
                ld a, b
                sub 7
                ld b, a
                ld hl, spider_f0
                ld a, (ix + sd0)
                or a
                jz 1f
                ld hl, spider_f1
1               call draw_masked_sprite
                ret


                
