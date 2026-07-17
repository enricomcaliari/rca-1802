; Testa a manipulação de registradores e seletores
; Cobre as instruções GLO, GHI, PLO, PHI, INC, DEC, IRX, SEP e SEX

LDI 55H
PLO R5
LDI AAH
PHI R5       ; R5 = AA55H
LDI 00H
GLO R5       ; D = 55H
GHI R5       ; D = AAH
INC R5       ; R5 = AA56H
DEC R5
DEC R5       ; R5 = AA54H

LDI 00H
PLO R6
PHI R6
LDI 40H
PLO R6       ; R6 = 0040H
SEX R6       ; X = 6
IRX          ; R6 = 0041H

LDI 1EH
PLO R7
LDI 00H
PHI R7       ; R7 = 001EH
SEP R7       ; Chaveia PC para R7
IDL          ; Pulado
LDI 42H      ; Executado sob controle de R7 (Endereço 001EH)
SEP R0       ; Retorna PC para R0
IDL