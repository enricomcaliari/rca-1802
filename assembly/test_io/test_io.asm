; Testa IN e OUT, flag Q e entradas EF1–EF4
; Cobre as instruções SEQ, REQ, B1, B2, B3, B4, OUT e IN

LDI 00H
PLO R8
PHI R8
LDI 50H
PLO R8       ; R8 = 0050H
SEX R8       ; X = 8

SEQ          ; Q = 1
REQ          ; Q = 0

B1 0DH       ; Salta se EF1 = 1
SKP
B2 10H       ; Salta se EF2 = 1
SKP
B3 13H       ; Salta se EF3 = 1
SKP
B4 16H       ; Salta se EF4 = 1
SKP

LDI A5H
STR R8       ; M(0050H) = A5H
OUT 1        ; Bus = A5H, Incrementa R8 (R8=0051H)
DEC R8       ; R8 = 0050H
IN 1         ; D = Bus, M(0050H) = Bus
IDL