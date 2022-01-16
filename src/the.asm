                module The

isaac_x db 40
isaac_y db 40

isaac_facing db LEFT
isaac_moving db LEFT

timer db 0

                endmodule

UP    equ 1 << keyboard.BIT_UP
LEFT  equ 1 << keyboard.BIT_LEFT
DOWN  equ 1 << keyboard.BIT_DOWN
RIGHT equ 1 << keyboard.BIT_RIGHT
