                module Alphabet

unimplemented   macro
                db 6
                dg XXXXX---
                dg X---X---
                dg X---X---
                dg X---X---
                dg X---X---
                dg X---X---
                dg XXXXX---
                endm

; todo: 
;   [ ] item symbols (bomb, coin, key)
;   [ ] heart symbols
;   [ ] numbers
;   [ ] minor punctuation: dash, times, exclam, question
Base:
Space:
                ; handled magically in text.get_letter.space
                db 3
                dg --------
                dg --------
                dg --------
                dg --------
                dg --------
                dg --------
                dg --------

Exclam:         
                db 3
                dg XX------
                dg XX------
                dg XX------
                dg XX------
                dg XX------
                dg --------
                dg XX------

Quote:          unimplemented
Pound:          unimplemented
Dollar:         unimplemented
Percent:        unimplemented
Ampersand:      unimplemented

Apostrophe:
                db 2
                dg X-------
                dg X-------
                dg --------
                dg --------
                dg --------
                dg --------
                dg --------

OpenParen:      unimplemented
CloseParen:     unimplemented
Times:          unimplemented
Plus:           unimplemented
Comma:          unimplemented ; custom, as it goes below the baseline
Minus:          
                db 3
                dg --------
                dg --------
                dg --------
                dg --------
                dg XX------
                dg --------
                dg --------
Dot:            
                db 3
                dg --------
                dg --------
                dg --------
                dg --------
                dg --------
                dg XX------
                dg XX------

Div:            unimplemented
N0:             
                db 6
                dg -XXX----
                dg XX-XX---
                dg XX-XX---
                dg XX-XX---
                dg XX-XX---
                dg XX-XX---
                dg -XXX----
N1:             
                db 4
                dg XXX-----
                dg -XX-----
                dg -XX-----
                dg -XX-----
                dg -XX-----
                dg -XX-----
                dg -XX-----
N2:             
                db 6
                dg XXXX----
                dg ---XX---
                dg ---XX---
                dg --XX----
                dg -XX-----
                dg XX------
                dg XXXXX---
N3:             
                db 6
                dg XXXX----
                dg ---XX---
                dg ---XX---
                dg -XXX----
                dg ---XX---
                dg ---XX---
                dg XXXX----
N4:             
                db 3
                dg XX-XX---
                dg XX-XX---
                dg XX-XX---
                dg XX-XX---
                dg XXXXX---
                dg ---XX---
                dg ---XX---
N5:             
                db 6
                dg XXXXX---
                dg XX------
                dg XX------
                dg XXXX----
                dg ---XX---
                dg ---XX---
                dg XXXX----
N6:             
                db 6
                dg -XXX----
                dg XX------
                dg XX------
                dg XXXX----
                dg XX-XX---
                dg XX-XX---
                dg -XXX----
N7:             
                db 6
                dg XXXXX---
                dg ---XX---
                dg --XX----
                dg -XX-----
                dg -XX-----
                dg -XX-----
                dg -XX-----
N8:             
                db 3
                dg -XXX----
                dg XX-XX---
                dg XX-XX---
                dg -XXX----
                dg XX-XX---
                dg XX-XX---
                dg -XXX----
N9:             
                db 6
                dg -XXX----
                dg XX-XX---
                dg XX-XX---
                dg -XXXX---
                dg ---XX---
                dg ---XX---
                dg -XXX----
Colon:          
                db 2
                dg --------
                dg --------
                dg x-------
                dg --------
                dg --------
                dg x-------
                dg --------
Semicolon:      unimplemented
LessThan:       unimplemented
Equals:         unimplemented
GreaterThan:    unimplemented
Question:       
                db 6
                dg XXXX----
                dg ---XX---
                dg --XX----
                dg -XX-----
                dg -XX-----
                dg --------
                dg -XX-----
At:             unimplemented

A:
                db 6
                dg -XXX----
                dg XX-XX---
                dg XX-XX---
                dg XX-XX---
                dg XXXXX---
                dg XX-XX---
                dg XX-XX---

B:
                db 6
                dg XXXX----
                dg XX-XX---
                dg XX-XX---
                dg XXXX----
                dg XX-XX---
                dg XX-XX---
                dg XXXX----

C:
                db 5
                dg -XXX----
                dg XX------
                dg XX------
                dg XX------
                dg XX------
                dg XX------
                dg -XXX----

D:
                db 6
                dg XXXX----
                dg XX-XX---
                dg XX-XX---
                dg XX-XX---
                dg XX-XX---
                dg XX-XX---
                dg XXXX----

E:
                db 5
                dg XXXX----
                dg XX------
                dg XX------
                dg XXX-----
                dg XX------
                dg XX------
                dg XXXX----

F:
                db 5
                dg XXXX----
                dg XX------
                dg XX------
                dg XXXX----
                dg XX------
                dg XX------
                dg XX------

G:
                db 7
                dg -XXXX---
                dg XX------
                dg XX------
                dg XX-XXX--
                dg XX--XX--
                dg XX--XX--
                dg -XXXX---

H:
                db 6
                dg XX-XX---
                dg XX-XX---
                dg XX-XX---
                dg XXXXX---
                dg XX-XX---
                dg XX-XX---
                dg XX-XX---

I:
                db 3
                dg XX------
                dg XX------
                dg XX------
                dg XX------
                dg XX------
                dg XX------
                dg XX------

J:
                db 5
                dg XXXX----
                dg --XX----
                dg --XX----
                dg --XX----
                dg --XX----
                dg --XX----
                dg XXX-----

K:
                db 6
                dg XX-XX---
                dg XX-XX---
                dg XX-XX---
                dg XXXX----
                dg XX-XX---
                dg XX-XX---
                dg XX-XX---

L:
                db 6
                dg XX------
                dg XX------
                dg XX------
                dg XX------
                dg XX------
                dg XX------
                dg XXXXX---

M:
                db 8
                dg X-----X-
                dg XX---XX-
                dg XXX-XXX-
                dg XXXXXXX-
                dg XX-X-XX-
                dg XX---XX-
                dg XX---XX-

N:
                db 7
                dg X---XX--
                dg XX--XX--
                dg XXX-XX--
                dg XXXXXX--
                dg XX-XXX--
                dg XX--XX--
                dg XX---X--

O:
                db 6
                dg -XXX----
                dg XX-XX---
                dg XX-XX---
                dg XX-XX---
                dg XX-XX---
                dg XX-XX---
                dg -XXX----

P:
                db 6
                dg XXXX----
                dg XX-XX---
                dg XX-XX---
                dg XX-XX---
                dg XXXX----
                dg XX------
                dg XX------

Q:
                db 6
                dg -XXX----
                dg XX-XX---
                dg XX-XX---
                dg XX-XX---
                dg XXXXX---
                dg XX-XXX--
                dg -XXX-X--

R:
                db 6
                dg XXXX----
                dg XX-XX---
                dg XX-XX---
                dg XX-XX---
                dg XXXX----
                dg XX-XX---
                dg XX-XX---

S:
                db 6
                dg -XXXX---
                dg XX------
                dg XXX-----
                dg -XXX----
                dg --XXX---
                dg ---XX---
                dg XXXX----

T:
                db 5
                dg XXXX----
                dg -XX-----
                dg -XX-----
                dg -XX-----
                dg -XX-----
                dg -XX-----
                dg -XX-----

U:
                db 6
                dg XX-XX---
                dg XX-XX---
                dg XX-XX---
                dg XX-XX---
                dg XX-XX---
                dg XX-XX---
                dg -XXX----

V:
                db 6
                dg XX-XX---
                dg XX-XX---
                dg XX-XX---
                dg XX-XX---
                dg -XXX----
                dg -XXX----
                dg --X-----

W:
                db 8
                dg XX---XX-
                dg XX---XX-
                dg XX---XX-
                dg XX-X-XX-
                dg XXX-XXX-
                dg XX---XX-
                dg X-----X-

X:
                db 6
                dg XX-XX---
                dg XX-XX---
                dg XX-XX---
                dg -XXX----
                dg XX-XX---
                dg XX-XX---
                dg XX-XX---

Y:
                db 7
                dg XX--XX--
                dg XX--XX--
                dg XX--XX--
                dg -XXXX---
                dg --XX----
                dg --XX----
                dg --XX----

Z:
                db 6
                dg XXXXX---
                dg ---XX---
                dg ---XX---
                dg --XX----
                dg -XX-----
                dg XX------
                dg XXXXX---




Unknown:
                db 6
                dg x-x-x---
                dg -x-x----
                dg x-x-x---
                dg -x-x----
                dg x-x-x---
                dg -x-x----
                dg x-x-x---
                dg -x-x----


CustomComma:
                db 3
                dg --------
                dg --------
                dg --------
                dg --------
                dg --------
                dg --------
                dg -X------
                dg X-------
                endmodule

