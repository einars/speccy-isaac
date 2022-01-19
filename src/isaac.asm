                module Isaac

OnHit:
                ld a, Color.red
                out (254), a
                ret

Move:
                ld de, 0 ; movement delta
                ld a, (The.isaac_speed)
                ld b, a ; b = + speed
                neg
                ld c, a ; c = - speed

                ld hl, The.isaac_facing


                ld a, (keyboard.movement)
                bit UP, a
                jr z, no_up

                ld d, c ; -speed
                ld (hl), UP

no_up:          bit DOWN, a
                jr z, no_down

                ld d, b ; +speed
                ld (hl), DOWN

no_down:        bit LEFT, a
                jr z, no_left

                ld e, c; -speed
                ld (hl), LEFT

no_left:        bit RIGHT, a
                jr z, no_right

                ld e, b ; +speed
                ld (hl), RIGHT

no_right:

                ld a, d
                or e
                jr nz, had_movement

no_movement:    ld hl, The.isaac_facing
                ld (hl), DOWN
                ld hl, The.isaac_step
                ld (hl), 0
                ld hl, The.isaac_step_counter
                ld (hl), 0
                jr isaac_step_done

had_movement:   
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
                jr z, skip_2 ; no movement at all

                push hl
                pop ix

                ;ld c, (ix + 0)
                ld c, (hl)
                ld b, (ix + 1)

                ld a, e
                or a
                jr z, skip_1

                ld a, c
                add e
                ld c, a

                push bc
                call Room.TileAtXY
                pop bc

                and Geo.perm + Geo.wall
                jr nz, skip_1

                ld (ix), c
skip_1          
                ld a, d
                or a
                jr z, skip_2

                ld c, (ix)

                ld a, b
                add d
                ld b, a

                push bc
                call Room.TileAtXY
                pop bc

                and Geo.perm + Geo.wall
                jr nz, skip_2

                ld (ix + 1), b

skip_2
                ret
                



                endmodule

