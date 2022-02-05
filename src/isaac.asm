                module Isaac

OnHit:
                ld a, Color.red
                ;out (254), a
                ret

Move:
                ld de, 0 ; movement delta
                ld a, (The.isaac_speed)
                ld b, a ; b = + speed
                neg
                ld c, a ; c = - speed

                ld hl, The.isaac_facing

                ld a, (The.isaac_fire_timer)
                or a
                jz .no_dec_fire_timer
                dec a
                ld (The.isaac_fire_timer), a
.no_dec_fire_timer:

                ld a, (keyboard.movement)
                bit FIRE_M, a
                jz .no_fire_m

                ld a, (The.isaac_fire_timer)
                or a
                jnz .no_fire_m

                ld a, (The.isaac_fire_frequency)
                ld (The.isaac_fire_timer), a
                
                ld a, (The.fire_direction)
                call spawn_isaac_bullet_in_direction

.no_fire_m
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
                ld hl, The.isaac_facing
                ld (hl), DOWN
                ld hl, The.isaac_step
                ld (hl), 0
                ld hl, The.isaac_step_counter
                ld (hl), 0
                jr isaac_step_done

.had_movement:   
                ld a, (hl)
                ld (The.fire_direction), a

                ; de = delta
                ld hl, The.isaac_pos
                call ApplyMovement
                ; animate steps
                ld hl, The.isaac_step_max
                ld a, (The.isaac_step_counter)
                inc a
                cp (hl)
                jr z, next_step

                ld (The.isaac_step_counter), a
                jr isaac_step_done

next_step:      xor a
                ld (The.isaac_step_counter), a
                ld a, (The.isaac_step)
                inc a
                and 3
                ld (The.isaac_step), a

isaac_step_done:
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
                

spawn_isaac_bullet_in_direction
                ; A - direction
                pushx
                ld h, a
                ld bc, (The.isaac_pos)
                ld a, b
                sub 12
                ld b, a
                ld a, h
                call isaac_bullet_appear
                popx
                ret


                endmodule

