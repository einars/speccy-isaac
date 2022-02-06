                module Isaac

pos equ spritelist + spr_pos
x equ spritelist + spr_x
y equ spritelist + spr_y

;isaac_pos
;isaac_x db 0
;isaac_y db 0

speed db 1

; it would've been better if these would live in spritelist at spd0..spdx
facing db LEFT
step db 0
step_counter db 0
step_max db 5

tear_limit db 3

fire_timer db 0
fire_frequency db 21
firing db 0





OnHit:
                ld a, Color.red
                ;out (254), a
                ret

tmp_junk db 0

Move:
                ld de, 0 ; movement delta
                ld a, (Isaac.speed)
                ld b, a ; b = + speed
                neg
                ld c, a ; c = - speed

                ld hl, Isaac.tmp_junk ; Isaac.facing

                ld a, (Isaac.fire_timer)
                or a
                jz .no_dec_fire_timer
                dec a
                ld (Isaac.fire_timer), a
.no_dec_fire_timer:

                ld a, (keyboard.movement)
                bit FIRE_M, a
                jnz .fire_m
                bit FIRE_D, a
                jnz .fire_d

                ; no fire pressed — allow facing reset
                ; switch from tmp_junk to actual facing
                ld hl, Isaac.facing
                jp .post_fire

.fire_d
                ld a, (Isaac.fire_timer)
                or a
                jnz .post_fire

                ld a, (Isaac.fire_frequency)
                ld (Isaac.fire_timer), a
                
                ld a, (keyboard.fire_direction)
                ld (Isaac.facing), a
                call Tear.Spawn
                jp .post_fire


.fire_m
                ld a, (Isaac.fire_timer)
                or a
                jnz .post_fire

                ld a, (Isaac.fire_frequency)
                ld (Isaac.fire_timer), a
                
                ld a, (Isaac.facing)
                call Tear.Spawn


.post_fire
                ld a, (keyboard.movement)
                bit UP, a
                jr z, .no_up

                ld d, c ; -speed
                ld (hl), UP

.no_up:         bit DOWN, a
                jr z, .no_down

                ld d, b ; +speed
                ld (hl), DOWN

.no_down:       bit LEFT, a
                jr z, .no_left

                ld e, c; -speed
                ld (hl), LEFT

.no_left:        bit RIGHT, a
                jr z, .no_right

                ld e, b ; +speed
                ld (hl), RIGHT

.no_right:

                ld a, d
                or e
                jr nz, .had_movement

                ; no movement
                ld a, (keyboard.movement)
                and keyboard.MASK_FIRE_M
                jnz .no_reset_facing ; fire pressed - continue firing
                ld a, (keyboard.movement)
                and keyboard.MASK_FIRE_D
                jnz .no_reset_facing ; fire pressed - continue firing

                ld hl, Isaac.facing
                ld (hl), DOWN

.no_reset_facing
                ld hl, Isaac.step
                ld (hl), 0
                ld hl, Isaac.step_counter
                ld (hl), 0
                jr .step_done

.had_movement:   

                ; de = delta
                ld hl, Isaac.pos
                call ApplyMovement
                ; animate steps
                ld hl, Isaac.step_max
                ld a, (Isaac.step_counter)
                inc a
                cp (hl)
                jr z, .next_step

                ld (Isaac.step_counter), a
                jr .step_done

.next_step:      xor a
                ld (Isaac.step_counter), a
                ld a, (Isaac.step)
                inc a
                and 3
                ld (Isaac.step), a

.step_done:
                ret


ApplyMovement:
                ; hl — ptr to current coordinates
                ; de - delta
                ld a, d
                or e
                ret z ; no movement at all

                push hl
                pop iy

                ld c, (iy + 0)
                ld b, (iy + 1)

                ld a, e
                or a
                jr z, 1f

                ld a, c
                add e
                ld c, a

                push bc
                call Util.TileAtXY
                pop bc

                and Geo.perm + Geo.wall
                jr nz, 1f

                ld (iy), c

1               ld a, d
                or a
                ret z

                ld c, (iy)

                ld a, b
                add d
                ld b, a

                push bc
                call Util.TileAtXY
                pop bc

                and Geo.perm + Geo.wall
                ret nz

                ld (iy + 1), b

                ret
                


                endmodule

