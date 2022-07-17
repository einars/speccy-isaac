; non-masked sprites
; this fire is not generated
nm_mimic_f0:
                db Sprite.Flags.unmasked | Sprite.Flags.double_column
                db 19
                db 0b00000011, 0b11000000
                db 0b00001111, 0b11110000
                db 0b00011111, 0b11111000
                db 0b00111111, 0b11111100
                db 0b00111111, 0b11111100
                db 0b01100111, 0b11100110
                db 0b01000011, 0b11000010
                db 0b01000011, 0b11000010
                db 0b01100111, 0b11100110
                db 0b00111110, 0b01111100
                db 0b00111100, 0b00111100
                db 0b00011100, 0b00111000
                db 0b00001111, 0b11110000
                db 0b00000011, 0b11000000
                db 0b00000100, 0b00100000
                db 0b00000101, 0b11100000
                db 0b00000101, 0b11100000
                db 0b00000011, 0b00000000
                db 0b00000011, 0b00000000


nm_mimic_f1:
                db Sprite.Flags.unmasked | Sprite.Flags.double_column
                db 19
                db 0b00000011, 0b11000000
                db 0b00001111, 0b11110000
                db 0b00011111, 0b11111000
                db 0b00111111, 0b11111100
                db 0b00111111, 0b11111100
                db 0b01100111, 0b11100110
                db 0b01000011, 0b11000010
                db 0b01000011, 0b11000010
                db 0b01100111, 0b11100110
                db 0b00111110, 0b01111100
                db 0b00111100, 0b00111100
                db 0b00011100, 0b00111000
                db 0b00001111, 0b11110000
                db 0b00000011, 0b11000000
                db 0b00000100, 0b00100000
                db 0b00000101, 0b11100000
                db 0b00000101, 0b11100000
                db 0b00000000, 0b11000000
                db 0b00000000, 0b11000000

nm_spider_f0:	db (Sprite.Flags.double_column | Sprite.Flags.unmasked)
                db 5
                db 0b00001000, 0b00100000
                db 0b00110111, 0b11011000
                db 0b00100111, 0b11001000
                db 0b00101011, 0b10101000
                db 0b00000010, 0b10000000

nm_spider_f1:	db (Sprite.Flags.double_column | Sprite.Flags.unmasked)
                db 5
                db 0b00001000, 0b00100000
                db 0b00110111, 0b11011000
                db 0b00100111, 0b11001000
                db 0b01001010, 0b10100100
                db 0b00001000, 0b00100000
