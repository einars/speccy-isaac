
                align 256
spritelist:     db 0xff
                ds 511 ; max 512 / 16 sprites at a time
                
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

spr_data        equ 9
sd0             equ spr_data
sd1             equ spr_data + 1
sd2             equ spr_data + 2
sd3             equ spr_data + 3
sd4             equ spr_data + 4
sd5             equ spr_data + 5
sd6             equ spr_data + 6

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
                ret ; jmp $init

map_sprites:
                ; stack — function to call for all sprites
                ;      IX will get the sprite pointer
                ;      Do not touch the alt. regs there thx
                pop hl
                exx
                ld hl, spritelist
                ld bc, 16
1               ld a, (hl)
                or a
                ret z ; done. prob should continue if ever we impl dead sprites
                inc a
                ret z ; with alt regs, but who cares

                push hl ; ix = sprite address
                pop ix

                exx
                push hl ; remember func address

                push hl
                ld hl, .retmap
                ex (sp), hl
                jp hl

.retmap         pop hl ; get $func back
                exx
2               add hl, bc
                jr 1b

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

                push bc

                ld hl, .ret
                push hl
.smc            jp 0000

.ret
                pop bc
                ret
                




update_sprites:
                call map_sprites

                ld a, (ix + spr_tick)
                add a, 32

1               cp (ix + spr_speed)
                jc noupdate ; if speed > tick

                sub (ix + spr_speed)
                ld (ix + spr_tick), a
                
                push af

                ld hl, .ret
                push hl
                ld hl, (ix + spr_update)
                jp hl

.ret            pop af
                jr 1b

noupdate        ld (ix + spr_tick), a
                ret


spidio db 16
                
spider_init:    
                ld (ix + spr_type), s_spider
                ld a, (spidio)
                ld (ix + spr_speed), a
                add 8
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
                inc (ix + sd1)
                ld a, (ix + sd1)
                cp 5
                ret nz
                ld a, (ix + sd0)
                inc a
                and 1
                ld (ix + sd0), a
                ld (ix + sd1), 0
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


                
