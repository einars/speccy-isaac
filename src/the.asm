NONE equ 0xff

UP    equ 0
DOWN  equ 1
LEFT  equ 2
RIGHT equ 3

FIRE_M equ 4 ; movement direction
FIRE_D equ 5 ; directional fire

Mask:
.on equ  0x00
.off equ 0x80


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
                display "monsters:      ",/A, EntitiesStart, "...",/A, EntitiesEnd, " (", /A, (EntitiesEnd - EntitiesStart), ")"
                display "top:           ",/A, $
                display "everything:    ",/A, ($ - Start)
                display "---"
                display "spritelist: ",/A, (spritelist)
                display "draw routines: ",/D, (Sprite.TraceEnd - Sprite.TraceStart)
                display "alphabet gfx:  ",/D, (text.Alphabet.TraceEnd - text.Alphabet.TraceStart)
                display "code:          ",/D, (EntitiesStart - Start), " (alphabet gfx included)"
                display "free at least: ",/D, (0xc000 - $)
