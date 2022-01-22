                module The

                org 0xe000

isaac_pos:
isaac_x db 40
isaac_y db 40
isaac_speed db 1

isaac_facing db LEFT
isaac_step db 0
isaac_step_counter db 0
isaac_step_max db 5

timer db 0

                endmodule

UP    equ 0
LEFT  equ 1
DOWN  equ 2
RIGHT equ 3



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

