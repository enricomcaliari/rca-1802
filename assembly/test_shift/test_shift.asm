; Testa deslocamentos de bits
; Cobre as funções SHR, SHRC, SHL e SHLC

LDI 01H
SHR          ; D = 00H, DF = 1

LDI 80H
SHRC         ; D = C0H, DF = 0
SHRC         ; D = 60H, DF = 0

LDI 80H
SHL          ; D = 00H, DF = 1

LDI 01H
SHLC         ; D = 03H, DF = 0

IDL