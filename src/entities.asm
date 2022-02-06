

max_sprites     equ 32

spritelist:     ds (max_sprites * spr_length), 255

// sample sprite layout for moving things around
map_base
map_type db 0
map_x db 0
map_y db 0
map_sprite dw 0
map_life db 0
map_prev_x db 0
map_prev_y db 0
map_update dw 0
map_sd0 db 0
map_sd1 db 0
map_sd2 db 0
map_sd3 db 0
map_sd4 db 0
map_sd5 db 0
sprite_length equ $ - map_base

                assert (sprite_length == 16), The sprite area must be exactly 16
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
spr_life        equ map_life - map_base
spr_prev_x      equ map_prev_x - map_base
spr_prev_y      equ map_prev_y - map_base
spr_prev_pos    equ spr_prev_x
spr_update      equ map_update - map_base
sd0             equ map_sd0 - map_base
sd1             equ map_sd1 - map_base
sd2             equ map_sd2 - map_base
sd3             equ map_sd3 - map_base
sd4             equ map_sd4 - map_base
sd5             equ map_sd5 - map_base

                align 256

spr_t           equ sprite_length - 2
spr_ticks       equ sprite_length - 1
tick_threshold  equ 12
 ; custom tick counter for updates more seldom than every frame
 ; use by calling entity_tick.
 ; spr_ticks are 12-based:
 ;  - 12+ — every frame
 ;  - 6   - every second frame
 ;  - 4   - every third frame
 ; etc

spr_length      equ 16 ; sometimes important, search for spr_length

sprite_death  equ 0xff

Custom_draw   equ 0x80

s_nothing       equ 0
s_monster       equ 1
s_isaac_tear    equ (0x2 or Custom_draw)
s_isaac         equ 0x69


appear:
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
                or a
                jz .found_space
                cp 255
                jz .found_space_in_end
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
                ld (ix + spr_update), hl
                ret

.found_space
                push hl
                pop ix
                ;ld (ix + spr_length), 255
                jp 1b

map_sprites_without_isaac:
                pop hl
                ld (map_sprites.smc + 1), hl
                ld ix, spritelist + spr_length ; by convention, isaac is first
                jp map_sprites.reentry


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
                jp z, .skip_this
                inc a
                ret z

.all_ok
.smc            call 0000
.skip_this
                ld bc, spr_length
                add ix, bc
                jr 1b



sort_area       ds max_sprites * 2


entity_tick:
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


draw_sprites_ordered:

                ld a, (ord_remaining)
                or a
                jz .sort_again

                ld b, a
                ld iy, (ord_left_at)
                jp .draw_reentry




.sort_again:     
                ld ix, spritelist ; ignore isaac
                ld bc, spr_length
                ld hl, sort_area
                ld d, 0 ; sprite index
                ld e, 0 ; number of sprites

                ; ignore isaac, isaac gets updated always
                inc d
                add ix, bc

                // sort_area will contain:
                // [ y, idx ] [ y, idx ], ...

1               ld a, (ix)
                or a
                jz .next
                ;cp s_isaac_tear ; ignore tears
                ;jz .next
                inc a
                jz .done
                ld a, (ix + spr_y)
                ld (hl), a
                inc hl
                ld (hl), d
                inc hl
                inc e ; number of sprites alive
.next           add ix, bc
                inc d
                jp 1b
.done
                ; now bubble-sort that shit

                ld a, e
                ld d, a
                or e
                jp z, draw_requireds


                push de
                ; don't sort at all
                jp .nuff

                ; stack sorting is slightly faster, but interrupts need to be disabled
                jr .bubble_ix


;;; bubblesort, stack-based implementation
.bubble_stack:

                ld a, d

                dec a

                jz .nuff

                ld (.xsmc + 2), a
                ld (.ssp + 1), sp

.xagain         ld sp, sort_area
.xsmc           ld bc, 0
                pop de
.xbub           
                pop hl
                ld a, e
                cp l
                jp c, .xno_swap
                jp z, .xno_swap
                push de
                push hl
                pop hl
                ex de, hl
                inc c
.xno_swap:      ex de, hl
                djnz .xbub
                ld a, c
                or a
                jp nz, .xagain
.ssp            ld sp, 0
                jr .nuff


;;; bubblesort, ix-based implementation
.bubble_ix:
                ld b, d
                ld c, d
.again          ld ix, sort_area

                ld h, 0
                ld b, c
                dec b
                jz .nuff
.nbub:          ld a, (ix)
                ld e, (ix + 2)
                cp e
                ;jz .no_swap
                jc .no_swap
                ;jnc .no_swap
.swap           ld (ix), e
                ld (ix + 2), a
                ; swap indices
                ld a, (ix + 1)
                ld e, (ix + 3)
                ld (ix + 1), e
                ld (ix + 3), a
                inc h
.no_swap        inc ix
                inc ix
                djnz .nbub
                dec c
                jz .nuff
                ld a, h
                or h
                jnz .again
.nuff
                pop de

                ; now:
                ; D - n_elements
                ; &spritelist - y-sorted sprite indexes

                ld a, d
                ld (ord_remaining), a
                ld b, d

                ld hl, sort_area
                ld (ord_left_at), hl
.draw_reentry
.draw           

                call draw_requireds

                dup 2

                ld hl, (ord_left_at)
                inc hl
                ld l, (hl)
                ld h, 0
                add hl, hl
                add hl, hl
                add hl, hl
                add hl, hl ; hl = idx * 16 ; spr_length!
                ld bc, spritelist
                add hl, bc
                ld ix, hl

                call materialize_sprite

                ld hl, ord_left_at
                inc (hl)
                inc (hl)
                ;djnz .draw
                dec hl
                ;ld hl, ord_remaining
                dec (hl)
                ret z
                edup

                ret

draw_requireds:
                ; draw isaac and all of the bullets
                ld ix, spritelist
                ld hl, spritelist
                call materialize_sprite
                ld hl, spritelist
.b
                ld bc, spr_length
                add hl, bc
                ld a, (hl)
                cp 255
                ret z
                and Custom_draw
                jp z, .b
.draw_this      push hl
                pop ix
                push hl
                call materialize_sprite
                pop hl
                jp .b

                

ord_remaining db 0
ord_left_at dw 0



draw_sprites_chaotic:
                call map_sprites
                jp materialize_sprite


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

update_sprite:
                ld hl, (ix + spr_update)
                ld (.smc + 1), hl

.smc            call 0

                inc a ; sprite_death
                jz .handle_death

                ret
.handle_death:
                xor a
                ld (ord_remaining), a ; indirectly force redraw of all sprites

                ; dematerialize_sprite
                ;call dematerialize_sprite
                ;ret
                
dematerialize_sprite:
                ; IX = sprite
                ld a, (ix)

                ld (ix + 0), a ; mark entity as dead

                ld (ix + 0), 0 ; mark entity as dead
                and Custom_draw
                jp nz, .custom
                ld bc, (ix + spr_prev_pos)
                ld hl, (ix + spr_sprite)
                jp restore_mask
.custom         
                ld hl, (ix + spr_sprite)
                ld (.call + 1), hl
                ld bc, (ix + spr_prev_pos)
                xor a
.call           jp 0



materialize_sprite:

                ; IX = HL = sprite

                ;or a ; idx = 0 — always draw isaac
                ;jz .no_skip

                ;call random
                ;and 7
                ;ret nz
                ld a, (ix)
                and Custom_draw
                jp nz, materialize_sprite_custom

.no_skip
                ld a, (ix + spr_x)
                sub (ix + spr_prev_x)
                jnz .changed
                ;jp z, .no_change_x
                ;negc

                ;cp 2
                ;jnc .changed
                
.no_change_x
                ld a, (ix + spr_y)
                cp (ix + spr_prev_y)
                jp nz, .changed

                ; draw occassionally

                jp .draw

.changed
                ld bc, (ix + spr_prev_pos)
                ld hl, (ix + spr_sprite)
                call restore_mask


.draw
                ld bc, (ix + spr_pos)
                ld (ix + spr_prev_pos), bc
                ld hl, (ix + spr_sprite)
                jp sprite_draw

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
                



move_in_cardinal_direction:
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


ht_enemy
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



isaac_update:   
                ld hl, Isaac.step
                ld a, (Isaac.facing)
                rla
                rla
                add (hl) ; facing * 4 + step
                rla ; x2 (list of words)
                ld hl, spl_isaac
                Add_HL_A
                ld a, (hl)
                inc hl
                ld h, (hl)
                ld l, a

                ld (ix + spr_sprite), hl
                ;ld a, (Isaac.x)
                ;ld (ix + spr_x), a
                ;ld a, (Isaac.y)
                ;ld (ix + spr_y), a
                xor a
                ret




spl_isaac
                dw isaac_up_f0
                dw isaac_up_f1
                dw isaac_up_f0
                dw isaac_up_f2
                dw isaac_down_f0
                dw isaac_down_f1
                dw isaac_down_f0
                dw isaac_down_f2
                dw isaac_left_f0
                dw isaac_left_f1
                dw isaac_left_f0
                dw isaac_left_f2
                dw isaac_right_f0
                dw isaac_right_f1
                dw isaac_right_f0
                dw isaac_right_f2


isaac_appear:   ; BC - coordinates of isaac

                ld a, c
                ld (Isaac.x), a
                ld a, b
                ld (Isaac.y), a

                ld de, isaac_down_f0
                ld hl, isaac_update
                ld a, s_isaac
                call appear

                ld (ix + sd0), 0 ; frame, 1 vs 0
                ld (ix + sd1), 0 ; frame counter
                ret

mimic_update:
                inc (ix + sd3)
                ld a, (ix + sd3)
                and 7
                jnz 2f ; .no_leg_update
                ld a, (ix + sd0)
                inc a
                and 1
                ld (ix + sd0), a
                jz 1f
                ld hl, mimic_f0
                ld (ix + spr_sprite), hl
                jr 2f

1               ld hl, mimic_f1
                ld (ix + spr_sprite), hl
2
                ld a, (ix + sd1) ; distance to run
                or a
                jz .choose_new_direction

                dec a
                ld (ix + sd1), a

                ld h, (ix + sd2)
                ld a, 1
                call move_in_cardinal_direction
                jz .moved

.choose_new_direction
                
                call random
                ld b, a
                and 63
                ld (ix + sd1), a ; distance to run
                ld a, b
                and 3
                ld (ix + sd2), a ; direction

.moved
                xor a
                ret

                
                
mimic_appear:   ; BC - coordinates of isaac
                ld de, mimic_f0
                ld hl, mimic_update
                ld a, s_monster
                call appear
                xor a
                ld (ix + sd0), a
                ld (ix + sd1), a
                ld (ix + sd2), a
                ld (ix + sd3), a
                ret

enemy_hit:      push ix
                push hl
                pop ix
                call dematerialize_sprite
                pop ix
                ret

