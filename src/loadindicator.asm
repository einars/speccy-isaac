                module LoadIndicator
counter         db 0

FrameStart:     xor a
                ld (counter), a
                ret

Tick:           
                ld a, (counter)
                inc a
                ;and 0x0f ; 15 frames should be enough for everyone
                ld (counter), a
                ret

FrameEnd:

                ; spin until the next interrupt
                ld hl, tick
                ld a, (hl)
                ld d, 20
.wait_frame
                cp (hl)
                jnz .got_frame

                dec d
                ld b, 200
.spin
                cp (hl)
                jnz .got_frame
                djnz .spin
                jp .wait_frame
                

.got_frame

                ld hl, 0x5800
                ld a, (counter)
                ;dec a ; we've already waited for the frame to end
                or a
                jz .draw_good
                ld b, a
                ld a, Color.black + Bg.red
                jr .draw

.draw_good      ld a, Color.black + Bg.green
                ld b, 1

.draw           ld c, b
1               ld (hl), a
                inc hl
                djnz 1b


                ld b, d
                ld a, Color.black + Bg.yellow

2
                ld (hl), a
                inc hl
                djnz 2b

                ld a, 33
                sub d
                ret z
                ld b, a

                ld a, Color.white + Bg.black
3
                ld (hl), a
                inc hl
                djnz 3b

                ret



                endmodule
