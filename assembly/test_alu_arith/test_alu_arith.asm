; Testa a aritmética com e sem carry e borrow
; Cobre as instruções ADD, ADI, ADC, ADCI, SM, SMI, SMB, SMBI, SD, SDI, SDB e SDBI

LDI 00H
PLO R2       
PHI R2       
LDI 20H
PLO R2       ; R2 = 0020H

LDI 80H
ADI 90H      ; D = 80H + 90H = 10H (DF = 1)
LDI 05H
ADCI 02H     ; D = 05H + 02H + DF(1) = 08H (DF = 0)

LDI FFH
STR R2       ; M(0020H) = FFH
LDI 01H
ADD          ; D = 01H + FFH = 00H (DF = 1)
LDI 00H
ADC          ; D = 00H + FFH + DF(1) = 00H (DF = 1)

LDI 05H
SMI 03H      ; D = 05H - 03H = 02H (DF = 1, sem borrow)
SMI 05H      ; D = 02H - 05H = FDH (DF = 0, com borrow)
LDI 0AH
SMBI 03H     ; D = 0AH - 03H - NOT DF(1) = 06H (DF = 1)

LDI 02H
SDI 05H      ; D = 05H - 02H = 03H (DF = 1)
LDI 04H
SDBI 04H     ; D = 04H - 04H - NOT DF(0) = 00H (DF = 1)

SEX R2       ; X = 2
LDI 10H
STR R2       ; M(0020H) = 10H
LDI 15H
SM           ; D = 15H - 10H = 05H (DF = 1)
SMB          ; D = 05H - 10H - NOT DF(0) = F5H (DF = 0)
LDI 20H
SD           ; D = 10H - 20H = F0H (DF = 0)
SDB          ; D = 10H - F0H - NOT DF(1) = 1FH (DF = 0)

IDL