; Testa as operações lógicas
; Cobre as instruções OR, ORI, AND, ANI, XOR e XRI

LDI 00H
PLO R4
PHI R4
LDI 30H
PLO R4       ; R4 = 0030H
SEX R4       ; X = 4

LDI 80H
ADI 80H      ; D = 00H, DF = 1

ORI 55H      ; D = 55H
ANI 0FH      ; D = 05H
XRI 35H      ; D = 30H

LDI AAH
STR R4       ; M(0030H) = AAH
LDI 55H
OR           ; D = FFH
AND          ; D = AAH
XOR          ; D = 00H

IDL