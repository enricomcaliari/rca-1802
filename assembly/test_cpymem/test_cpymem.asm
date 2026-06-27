; Testa o programa completo: cópia de bloco de memória
; Cobre as instruções múltiplas

LDI 00H
PHI R9
LDI 60H
PLO R9       ; R9 = 0060H

LDI 00H
PHI RA
LDI 70H
PLO RA       ; RA = 0070H

LDI 04H
PLO RC       ; RC = 0004H

LDI 00H
PHI R2
LDI 60H
PLO R2
LDI DEH
STR R2
INC R2
LDI ADH
STR R2
INC R2
LDI BEH
STR R2
INC R2
LDI EFH
STR R2       ; M(0060..63) = DE, AD, BE, EF

LDA R9       ; Lê M(R9), incrementa R9
STR RA       ; Grava em M(RA)
INC RA       ; Incrementa RA
DEC RC       ; Decrementa contador
GLO RC       ; Coloca contador em D
BNZ 24H      ; Loop enquanto RC.L != 0

IDL