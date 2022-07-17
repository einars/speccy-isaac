



// sample sprite layout for moving things around
map_base
map_type db 0
map_x db 0
map_y db 0
map_sprite dw 0

map_t db 0
map_ticks db 0

map_health db 0
map_prev_x db 0
map_prev_y db 0
map_prev_sprite dw 0
map_update dw 0
map_sd0 db 0
map_sd1 db 0
map_sd2 db 0
map_sd3 db 0
map_sd4 db 0
map_sd5 db 0
;map_sd4 db 0
;map_sd5 db 0
sprite_length equ $ - map_base

                // some fields are accessed linearily
                assert ((map_type - map_base) == 0), Do not move entity type around
                assert ((map_x - map_base) == 1), Do not move entity position around
                assert ((map_y - map_base) == 2), Do not move entity position around
                assert ((map_sprite - map_base) == 3), Do not move entity sprite around

spr_type        equ map_type - map_base
spr_x           equ map_x - map_base
spr_y           equ map_y - map_base
spr_pos         equ spr_x
spr_sprite      equ map_sprite - map_base
spr_health      equ map_health - map_base
spr_prev_x      equ map_prev_x - map_base
spr_prev_y      equ map_prev_y - map_base
spr_prev_pos    equ spr_prev_x
spr_prev_sprite equ map_prev_sprite - map_base
spr_update      equ map_update - map_base
spr_t           equ map_t - map_base
spr_ticks       equ map_ticks - map_base
sd0             equ map_sd0 - map_base
sd1             equ map_sd1 - map_base
sd2             equ map_sd2 - map_base
sd3             equ map_sd3 - map_base
sd4             equ map_sd4 - map_base
sd5             equ map_sd5 - map_base


tick_threshold  equ 12
 ; custom tick counter for updates more seldom than every frame
 ; use by calling entity_tick.
 ; spr_ticks are 12-based:
 ;  - 12+ — every frame
 ;  - 6   - every second frame
 ;  - 4   - every third frame
 ; etc

sprite_death  equ 0xff

Custom_draw   equ 0x80
Every_frame   equ 0x40

s_nothing       equ 0
s_monster       equ 1
s_isaac_tear    equ (0x02 or Custom_draw or Every_frame)
s_isaac         equ (0x0f or Every_frame)

                module Entity


Appear:
                ; A - spr_type
                ; BC - at what pos
                ; DE - pointer to sprite
                ; HL - update_func
                ; returns:
                ; IX = pointer to sprite structure. you may wish to tweak it
                push hl
                push de
                push af
                ld hl, spritelist
                ld de, spr_length
1               ld a, (hl)
                inc a
                jz .found_space_in_end
                dec a
                jz .found_space
                add hl, de
                jr 1b

.found_space_in_end
                push hl
                pop ix
                ld (ix + spr_length), 255
1
                pop af
                ld (hl), a
                pop de
                pop hl
                ld (ix + spr_pos), bc
                ld (ix + spr_prev_pos), bc
                ld (ix + spr_sprite), de
                ld (ix + spr_prev_sprite), de
                ld (ix + spr_update), hl
                ret

.found_space
                push hl
                pop ix
                ;ld (ix + spr_length), 255
                jp 1b

Map_no_isaac:
                pop hl
                ld (Map.smc + 1), hl
                ld ix, spritelist + spr_length ; by convention, isaac is first
                jp Map.reentry


Map:
                ; stack — function to call for all sprites
                ; IX will get the sprite pointer
                pop hl
                ld (.smc + 1), hl
                ld ix, spritelist
.reentry
1               ld a, (ix)

                inc a
                ret z
                dec a
                jz .skip_this
.all_ok
.smc            call 0000
.skip_this
                ld bc, spr_length
                add ix, bc
                jr 1b



Map_noix:
                ; stack — function to call for all sprites
                ;      IX will get the sprite pointer
                ;      Do not touch the alt. regs there thx
                pop hl
                ld (.smc + 1), hl
                ld hl, spritelist
.reentry
1               ld a, (hl)
                or a
                jp z, .skip_this
                inc a
                ret z

.all_ok
                push hl
.smc            call 0000
                pop hl
.skip_this
                ld a, spr_length                 ; [7 .. 7]
                Add_HL_A
                jp 1b

Tick:
                ; returns:
                ; Z = skip this turn
                ; NZ = do your thing
                ld a, (ix + spr_t)
                add (ix + spr_ticks)
                cp tick_threshold
                jnc .skip_frame
                sub tick_threshold
                ld (ix + spr_t), a
                xor a
                inc a
                ret
.skip_frame
                ld (ix + spr_t), a
                xor a
                ret


draw_sprites_all:
                ld a, 7
                call DebugLine
                call Map
                call Entity.Materialize
                ld a, Color.red
                call DebugLine
                ret

Draw_all_chaotic:
.sprites_per_frame equ 2

                call .draw_important_stuff

                ld a, Color.yellow
                call DebugLine

.reentry_hl     ld hl, spritelist + spr_length ; smc
                ld b, .sprites_per_frame
                ld c, 2 ; avoid spinning around if nothing to draw

.loop
                ld a, (hl)
                inc a
                jz .restart
                dec a
                jz .next
                and Every_frame
                jnz .next

                push bc
                push hl
                push hl
                pop ix

                ld a, Color.white
                out (254), a
                call Entity.Materialize
                ld a, Color.black
                out (254), a

                pop hl
                pop bc

                djnz .next

                ld a, spr_length
                Add_HL_A
                ld (.reentry_hl + 1), hl

                ret



.restart        ld hl, spritelist
                dec c
                ret z
.next           ld a, spr_length
                Add_HL_A
                jp .loop

.draw_important_stuff:
                ; isaac and his tears are drawn every frame
                call Map_noix
                ld a, (hl)
                and Every_frame
                ret z
.mat            push hl
                pop ix
                call Entity.Materialize

                ret



Run_isaac_hittest:
                ; bc - (isaac) coords
                ; hl - on hit success

                ld (.smc + 1), hl
                ld l, c
                ld h, b
                ld (.bc + 1), hl

                call Map_no_isaac

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





n_sprites       db 0

Update_all:
                xor a
                ld (n_sprites), a
                call Map

.update_sprite
                ld hl, n_sprites
                inc (hl)
                ld hl, (ix + spr_update)
                ld (.smc + 1), hl

.smc            call 0

                inc a ; sprite_death
                ret nz
.handle_death:
                xor a

Dematerialize:
                ; IX = sprite
                ld a, (ix)

                ld (ix + 0), 0 ; mark entity as dead
                and Custom_draw
                jp nz, .custom
                ld bc, (ix + spr_prev_pos)
                ld hl, (ix + spr_prev_sprite)
                ;ld hl, (ix + spr_sprite)
                jp Sprite.Undraw
.custom
                ld hl, (ix + spr_sprite)
                ld (.call + 1), hl
                ld bc, (ix + spr_prev_pos)
                xor a
.call           jp 0



Materialize:
                ; IX = HL = sprite
                ld a, (hl)
                and Custom_draw
                jp nz, materialize_sprite_custom

                ld bc, (ix + spr_prev_pos)
                ld hl, (ix + spr_prev_sprite)
                call Sprite.Undraw


                ld bc, (ix + spr_pos)
                ld hl, (ix + spr_sprite)
                ld (ix + spr_prev_pos), bc
                ld (ix + spr_prev_sprite), hl
                jp Sprite.Draw

materialize_sprite_custom:
                ld bc, (ix + spr_prev_pos)
                ld hl, (ix + spr_sprite)
                ld (.call + 1), hl
                xor a ; disappear
                push hl
.call           call 0
                ld bc, (ix + spr_pos)
                ld (ix + spr_prev_pos), bc
                ld a, 1 ; draw
                ret ; call spr_draw




Move_in_cardinal_direction:
                ; ix = sprite
                ; h = direction (UP / DOWN / LEFT / RIGHT
                ; a = amount
                ld l, a
                ld a, h
                ld bc, (ix + spr_pos)
                or a
                jz .up
                dec a
                jz .down
                dec a
                jz .left
                ; right
                ld a, c
                add l
                ld c, a
                jr 1f
.up             ld a, b
                sub l
                ld b, a
                jr 1f
.left           ld a, c
                sub l
                ld c, a
                jr 1f
.down           ld a, b
                add l
                ld b, a
1
                push bc
                call Util.TileAtXY
                pop bc

                and Geo.perm + Geo.wall
                ret nz
                ld (ix + spr_pos), bc
                ret


Hittest_monsters:
                ; bc - coordinates
                push de
                ld hl, bc
                ld (.bc + 1), hl

                ld hl, spritelist + spr_length
.loop
                ld a, (hl)
                cp 255
                jz .nothing_hit
                cp s_monster
                jnz .next

                inc hl
                ld a, (hl) ; x
.bc             ld bc, 0
                ; 10 pixels wide area around base
                add 5
                cp c
                jc .no_hit_dec1
                sub 10
                cp c
                jnc .no_hit_dec1

                ; 8 pixels high
                inc hl
                ld a, (hl) ; y
                cp b
                jc .no_hit_dec2

                ex af, af'
                push hl
                inc hl
                ld a, (hl)
                inc hl
                ld h, (hl)
                ld l, a
                ld d, (hl) ; A = actual sprite height
                pop hl
                ex af, af'

                sub d
                cp b
                jnc .no_hit_dec2

                ; have hit!
                dec hl
                dec hl
                xor a
                dec a
                pop de
                ret

.no_hit_dec2    dec hl
.no_hit_dec1    dec hl
.next           ld bc, spr_length
                add hl, bc
                jp .loop

.nothing_hit    xor a
                pop de
                ret






When_monster_hit:
                ; A - direction from which it was hit
                ld (.dir + 1), a
                push ix
                push hl
                pop ix

                ld a, Color.blue
                call Blink

                ld a, (ix + spr_health)
                or a
                jz .fin

                dec a
                ld (ix + spr_health), a
                ld (ix + spr_t), 0

                jz .demat

.dir            ld h, 0
                ld a, 8
                call Move_in_cardinal_direction

                jp .fin

.demat          call Dematerialize
                ld a, Color.red
                call Blink
.fin
                pop ix
                ret

                endmodule


spr_length      equ 32 ; sometimes important, search for spr_length
max_sprites     equ 32
                align 256
spritelist:     ds (max_sprites * spr_length), 255

