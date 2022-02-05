
                align 256

max_sprites     equ 32

spritelist:     ds (max_sprites * spr_length), 255

spr_type        equ 0
spr_pos         equ 1
spr_x           equ 1
spr_y           equ 2

spr_prev_pos         equ 3
spr_prev_x           equ 3
spr_prev_y           equ 4

spr_sprite     equ 5 ; , 6

spr_speed       equ 7
spr_tick        equ 8 ; writes on every update

spr_update      equ 9 ; , 10

spr_data        equ 11
sd0             equ spr_data
sd1             equ spr_data + 1
sd2             equ spr_data + 2
sd3             equ spr_data + 3
sd4             equ spr_data + 4

spr_length      equ 16 ; sometimes important, search for spr_length

s_nothing       equ 0
s_monster       equ 1
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
                ld (ix + spr_speed), 32 ; default speed, 1/f
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

.all_ok
.smc            call 0000
                ld bc, spr_length
                add ix, bc
                jr 1b



sort_area       ds max_sprites * 2



draw_sprites_ordered:

                ld a, (ord_remaining)
                or a
                jz .sort_again

                ld b, a
                ld iy, (ord_left_at)
                jp .draw_reentry




.sort_again:     
                ld ix, spritelist + spr_length ; ignore isaac
                ld bc, spr_length
                ld hl, sort_area
                ld d, 1 ; sprite index

                // sort_area will contain:
                // [ y, idx ] [ y, idx ], ...

1               ld a, (ix)
                or a
                jz .next
                inc a
                jz .done
                ld a, (ix + spr_y)
                ld (hl), a
                inc hl
                ld (hl), d
                inc hl
.next           add ix, bc
                inc d
                jp 1b
.done
                ; now bubble-sort that shit


                push de
                ; stack sorting is slightly faster, but interrupts need to be disabled
                jr .bubble_ix
                ;jr .nuff


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
                ld ix, spritelist
                call update_sprite
                call materialize_sprite

                dup 3
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
                call update_sprite ; todo: handle death
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

ord_remaining db 0
ord_left_at dw 0



draw_sprites_chaotic:
                call map_sprites
                call materialize_sprite
                ret

draw_sprites_cleanest:
                ld b, Room.H
                ld d, Room.TopReservePix
                ld e, Room.TopReservePix + 16 ; next tile
                ld hl, spritelist
.new_row

.row_loop
                ld a, (hl)
                or a
                jz .next
                inc a
                jnz .maybe_draw_this
                ld hl, spritelist

                ; sprite list iterated
                ; move to next line

                ld d, e
                ld a, 16
                add e
                ld e, a
                ld hl, spritelist
                djnz .new_row
                ret

.pop_next:
                pop hl
.next
                ld a, spr_length
                add l
                ld l, a
                jnc .row_loop
                inc h
                jp .row_loop

.maybe_draw_this
                push hl
                inc l
                inc l
                ld a, (hl) ; pos_y
                cp d
                jp c, .pop_next
                cp e
                jp nc, .pop_next
                dec l
                dec l
                ld ix, hl
                push bc
                exx
                call materialize_sprite
                exx
                pop bc
                jp .pop_next

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
                ld a, (ix + spr_tick)
                add (ix + spr_speed)
                cp 32
                jc 1f


                ld hl, (ix + spr_update)
                ld (.smc + 1), hl

                push af
.smc            call 0
                pop af
                sub 32

                ; todo: check if the sprite died

1               ld (ix + spr_tick), a
                ret


materialize_sprite:

                ;or a ; idx = 0 — always draw isaac
                ;jz .no_skip

                ;call random
                ;and 7
                ;ret nz

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


move_sprite_in_cardinal_direction:
                ; ix = sprite
                ; A = direction (UP / LEFT / DOWN / RIGHT
                ld bc, (ix + spr_pos)
                or a
                jz .up
                dec a
                jz .left
                dec a
                jz .right
                ; down
                inc b
                jr 1f
.up             dec b
                jr 1f
.left           dec c
                jr 1f
.right          inc c
1               
                push bc
                call Util.TileAtXY
                pop bc

                and Geo.perm + Geo.wall
                ret nz
                ld (ix + spr_pos), bc
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
                ld hl, spider_f0
                jz .o
                ld hl, spider_f1
.o              ld (ix + spr_sprite), hl

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

1               ld a, e
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
                call Util.TileAtXY
                pop bc

                and Geo.perm + Geo.wall
                ret nz

                ld (ix + spr_pos), bc

                xor a

                ret
;
;spider_draw:
;                ld a, (ix + spr_x)
;                sub 8
;                ld c, a
;                ld a, (ix + spr_y)
;                sub 7
;                ld b, a
;                ld hl, spider_f0
;                ld a, (ix + sd0)
;                or a
;                jz 1f
;                ld hl, spider_f1
;1               jp draw_masked_2
;

isaac_update:   
                ld hl, The.isaac_step
                ld a, (The.isaac_facing)
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
                ld a, (The.isaac_x)
                ld (ix + spr_x), a
                ld a, (The.isaac_y)
                ld (ix + spr_y), a
                xor a
                ret




spl_isaac
                dw isaac_up_f0
                dw isaac_up_f1
                dw isaac_up_f0
                dw isaac_up_f2
                dw isaac_left_f0
                dw isaac_left_f1
                dw isaac_left_f0
                dw isaac_left_f2
                dw isaac_down_f0
                dw isaac_down_f1
                dw isaac_down_f0
                dw isaac_down_f2
                dw isaac_right_f0
                dw isaac_right_f1
                dw isaac_right_f0
                dw isaac_right_f2


isaac_appear:   ; BC - coordinates of isaac

                ld a, c
                ld (The.isaac_x), a
                ld a, b
                ld (The.isaac_y), a

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
                ld a, (ix + sd2)

                call move_sprite_in_cardinal_direction
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
                ld (ix + spr_speed), 16
                xor a
                ld (ix + sd0), a
                ld (ix + sd1), a
                ld (ix + sd2), a
                ld (ix + sd3), a
                ret

spider_appear:   ; BC - coordinates of isaac
                ld de, spider_f0
                ld hl, spider_update
                ld a, s_monster
                call appear
                ld (ix + spr_speed), 16
                ;call random
                ;ld (ix + spr_speed), a
                xor a
                ld (ix + sd0), a ; frame, 1/0
                ld (ix + sd1), a ; frame_counter
                ret

                
                
