; Testa todos os modos de endereçamento indireto e imediato
; Cobre as instruções LDI, LDN, LDA, STR, STXD, LDXA e LDX.

LDI 00H
PLO R3       ; R3.L = 00H
LDI 15H
PHI R3       ; R3.H = 15H (R3 aponta para 1500H)

LDI 55H      ; D = 55H
STR R3       ; M(R3) = 55H (M(1500H) = 55H)

LDI 00H      ; Limpa D
LDN R3       ; D = M(R3) -> D = 55H

LDA R3       ; D = M(R3) [55H], R3 incrementa para 1501H

SEX R3       ; X = 3 (Define R3 como registrador de índice)
LDI AAH      ; D = AAH
STXD         ; M(R3) = AAH (M(1501H) = AAH), R3 decrementa para 1500H

LDXA         ; D = M(R3) -> D = 55H, R3 incrementa para 1501H

LDX          ; D = M(R3) -> D = AAH (R3 continua 1501H)

IDL          ; Para a execução