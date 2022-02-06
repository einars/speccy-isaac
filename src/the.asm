                module The

isaac_pos equ spritelist + spr_pos
isaac_x equ spritelist + spr_x
isaac_y equ spritelist + spr_y

;isaac_pos
;isaac_x db 0
;isaac_y db 0

isaac_speed db 1

; it would've been better if these would live in spritelist at spd0..spdx
isaac_facing db LEFT
isaac_step db 0
isaac_step_counter db 0
isaac_step_max db 5

fire_direction db LEFT

isaac_fire_timer db 0
isaac_fire_frequency db 21
isaac_firing db 0

timer db 0

                endmodule

UP    equ 0
LEFT  equ 1
DOWN  equ 2
RIGHT equ 3

FIRE_M equ 4 ; movement direction
FIRE_D equ 5 ; directional fire



Color:
.black   equ 0
.blue    equ 1
.red     equ 2
.magenta equ 3
.green   equ 4
.cyan    equ 5
.yellow  equ 6
.white   equ 7

.bright  equ 0b01000000

Bg:
.black   equ 0 << 3
.blue    equ 1 << 3
.red     equ 2 << 3
.magenta equ 3 << 3
.green   equ 4 << 3
.cyan    equ 5 << 3
.yellow  equ 6 << 3
.white   equ 7 << 3




                display "start:         ",/A, Start
                display "top:           ",/A, $
                display "everything:    ",/A, ($ - Start)
                display "free at least: ",/A, (0xc000 - $)
