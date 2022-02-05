
                module Geo

perm  equ 0b01000000 ; nothing passes, ever
wall  equ 0b00100000 ; impassable for isaac
dirty equ 0b10000000 ; by convention, bit 7
free  equ 0

dirty_bit equ 7

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
oo equ Geo.free + 0x0a
xt equ Geo.perm + 0x0b
xb equ Geo.perm + 0x0c
                endmodule

                module Room
W equ 16
H equ 10
TopReserve equ 4 ; lines
TopReservePix equ TopReserve * 8 ; pixels
TopTiles equ TopReserve / 2 ; tiles

                endmodule

                align 256
room            db W.ul, W.up, W.up, W.up, W.up, W.up, W.up, W.up, W.up, W.up, W.up, W.up, W.up, W.up, W.up, W.ur
                db W.rt, F.oo, F.oo, F.oo, F.oo, F.oo, F.oo, F.oo, F.oo, F.oo, F.oo, F.oo, F.oo, F.oo, F.oo, W.rt
                db W.rt, F.oo, F.oo, F.oo, F.oo, S.v1, F.oo, F.oo, F.oo, S.v1, F.oo, F.oo, F.oo, F.oo, F.oo, W.rt
                db W.rt, F.oo, F.oo, F.oo, F.oo, F.oo, F.oo, F.oo, F.oo, F.oo, F.oo, F.oo, F.oo, F.oo, F.oo, W.rt
                db W.rt, F.oo, F.oo, S.v1, F.oo, F.oo, F.oo, S.v1, F.oo, F.oo, F.oo, S.v1, F.oo, F.oo, F.oo, W.rt
                db W.rt, F.oo, F.oo, S.v1, F.oo, F.oo, F.oo, S.v1, F.oo, F.oo, F.oo, S.v1, F.oo, F.oo, F.oo, W.rt
                db W.rt, F.oo, F.oo, F.oo, F.oo, F.oo, F.oo, F.oo, F.oo, F.oo, F.oo, F.oo, F.oo, F.oo, F.oo, W.rt
                db W.rt, F.oo, F.oo, F.oo, F.oo, S.v1, F.oo, F.oo, F.oo, S.v1, F.oo, F.oo, F.oo, F.oo, F.oo, W.rt
                db W.rt, F.oo, F.oo, F.oo, F.oo, F.oo, F.oo, F.oo, F.oo, F.oo, F.oo, F.oo, F.oo, F.oo, F.oo, W.rt
                db W.dl, W.dn, W.dn, W.dn, W.dn, W.dn, W.dn, W.dn, W.dn, W.dn, W.dn, W.dn, W.dn, W.dn, W.dn, W.dr
                ds 256 - (Room.W * Room.H) ; safety zone for dirty flags




