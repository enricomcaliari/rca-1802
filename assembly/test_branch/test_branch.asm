; Testa desvios condicionais e incondicionais
; Cobre as instruções BR, BZ, BNZ, BDF, BNF, BQ, BNQ, LBR, LBNZ, SKP e LSKP

REQ          ; Q = 0
LDI 01H
SHR          ; D = 00H, DF = 1

BR 07H       ; Desvio curto para 0007H
IDL
BNF 2EH      ; Não desvia (DF = 1)
BDF 0DH      ; Desvia para 000DH
IDL
IDL
BNZ 2EH      ; Não desvia (D = 0)
BZ 13H       ; Desvia para 0013H
IDL
IDL
BNQ 17H      ; Desvia para 0017H (Q = 0)
IDL
IDL
SEQ          ; Q = 1
BQ 1CH       ; Desvia para 001CH
IDL
IDL
SKP          ; Pula LDI 55H (1 byte)
LDI 55H
LSKP         ; Pula LDI AAH (2 bytes)
LDI AAH
LBR 0025H    ; Salto longo
LDI 01H      ; D = 01H
LBNZ 002BH   ; Desvia longo condicional
IDL
LDI 99H      ; Sucesso
IDL
LDI FFH      ; Tratamento de erro alvo
IDL