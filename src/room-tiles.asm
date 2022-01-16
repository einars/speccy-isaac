                module Geo
perm  equ 0b10000000 ; nothing passes, ever
wall  equ 0b01000000 ; impassable for isaac
chasm equ 0b00100000 ; can fly over
free  equ 0
                endmodule

                module W ; walls
uninitialized  equ Geo.wall + 0x00
ul equ Geo.perm + 0x01
ur equ Geo.perm + 0x02
dl equ Geo.perm + 0x03
dr equ Geo.perm + 0x03
up equ Geo.perm + 0x04
dn equ Geo.perm + 0x05
lt equ Geo.perm + 0x06
rt equ Geo.perm + 0x07
                endmodule

                module S ; stone
v1 equ Geo.wall + 0x08
v2 equ Geo.wall + 0x09
                endmodule

                module F ; Floor
oo equ Geo.free + 0x10
                endmodule

