# Testbench � Unidade de Controle do RCA CDP1802
**Grupo 4 — Unidade de Controle + µROM | Arquitetura e Organização de Computadores 2026/1**

Referências: `RCA_1802_microROM.pdf` — `Mapeamento de Microoperações e Especificação da µROM.pdf`

---

## 1. Formato da Microinstru��o (32 bits)

| Bits    | Campo          | Largura | Descri��o |
|---------|----------------|---------|-----------|
| [31:28] | `ALU_OP`       | 4       | Opera��o da ULA |
| [27:25] | `SRC_A`        | 3       | Fonte do operando A |
| [24:22] | `SRC_B`        | 3       | Fonte do operando B |
| [21:18] | `DST`          | 4       | Destino do resultado |
| [17:15] | `ADDR_SRC`     | 3       | Fonte do endere�o de mem�ria |
| [14:11] | `REG_SEL_SRC`  | 4       | Registrador selecionado |
| [10]    | `MEM_RD`       | 1       | Leitura de mem�ria |
| [9]     | `MEM_WR`       | 1       | Escrita em mem�ria |
| [8]     | `IR_LOAD`      | 1       | Carrega IR com opcode |
| [7]     | `REG_INC`      | 1       | Incrementa registrador |
| [6]     | `REG_DEC`      | 1       | Decrementa registrador |
| [5]     | `DF_LOAD`      | 1       | Atualiza flag DF |
| [4]     | `Q_LOAD`       | 1       | Atualiza flag Q |
| [3]     | `COND_EN`      | 1       | Habilita avalia��o condicional |
| [2:0]   | `NEXT_STATE`   | 3       | Pr�ximo estado da FSM |

**Codifica��es:**

| Campo | C�digo | Valor |
|-------|--------|-------|
| ALU_OP | 0=NOP, 1=PASS_A, 2=PASS_B, 3=ADD, 4=ADC, 5=SM, 6=SMB | |
| | 7=SD, 8=SDB, 9=OR, A=AND, B=XOR, C=SHR, D=SHRC, E=SHL, F=SHLC | |
| SRC_A | 0=0, 1=D, 2=MEM, 3=RN.L, 4=RN.H, 5=RX.L, 6=RX.H, 7=T | |
| SRC_B | 0=0, 1=D, 2=MEM, 3=LIT1, 4=N_EXP, 5=DF_EXP, 6=T | |
| DST | 0=none, 1=D, 2=MEM, 3=RN.L, 4=RN.H, 5=RP.L, 6=RP.H | |
| | 7=P, 8=X, 9=T, A=IE, B=Q, C=TMPH, D=TMPL, E=OUT_BUS | |
| ADDR_SRC | 0=none, 1=R(P), 2=R(N), 3=R(X), 4=R0 | |
| REG_SEL | 0=none, 1=N, 2=P, 3=X, 4=R0, 5=R1, 6=R2 | |
| NEXT_STATE | 0=FETCH, 1=EXECUTE1, 2=EXECUTE2 | |

---

## 2. Endere�amento da �ROM

```
?ADDR[8:0] = { STATE[2:0], INSTR_CLASS[5:0] }
```

| Estado | STATE | Faixa de endere�os |
|--------|-------|-------------------|
| FETCH    | 000 | 0x000�0x03F |
| EXECUTE1 | 001 | 0x040�0x07F |
| EXECUTE2 | 010 | 0x080�0x0BF |

**INSTR_CLASS � gerado pela PLA** a partir do opcode completo:

| Classe | C�digo | Instru��o(�es) |
|--------|--------|----------------|
| IDL  | 0x00 | 0x00 |
| LDN  | 0x01 | 0x01�0x0F |
| INC  | 0x02 | 0x10�0x1F |
| DEC  | 0x03 | 0x20�0x2F |
| BR   | 0x04 | 0x30�0x3F (todos os branches curtos) |
| LDA  | 0x05 | 0x40�0x4F |
| STR  | 0x06 | 0x50�0x5F |
| IRX  | 0x07 | 0x60 |
| OUT  | 0x08 | 0x61�0x67 |
| IN   | 0x09 | 0x69�0x6F |
| ... | ... | (ver documentação do grupo para lista completa) |
| LDX  | 0x21 | 0xF0 |
| OR   | 0x22 | 0xF1 |
| ADD  | 0x25 | 0xF4 |
| LDI  | 0x29 | 0xF8 |
| ADI  | 0x2D | 0xFC |
| SMI  | 0x30 | 0xFF |

---

## 3. Configura��o no Logisim

### 3.1 Carregar a �ROM

1. Abra `controle.circ` no Logisim Evolution.
2. **Bot�o direito** no componente `uROM` ? **Load Image...**
3. Selecione `uROM.mem` (mesma pasta).
4. Confirme: 512 palavras de 32 bits carregadas.

### 3.2 Conex�es necess�rias

| De | Para | Barramento |
|----|------|-----------|
| `INSTR_CLASS[5:0]` (pino entrada) | `ADDR_COMBINER` porta inferior (grupo 0) | 6 bits |
| `REG_ESTADO` sa�da Q | `ADDR_COMBINER` porta superior (grupo 1) | 3 bits |
| `ADDR_COMBINER` sa�da | `uROM` pino A | 9 bits |
| `uROM` pino D | `MW_SPLITTER` entrada | 32 bits |
| `MW_SPLITTER` grupo 14 (NEXT_STATE) | `REG_ESTADO` pino D | 3 bits |
| `CLK` pino | `REG_ESTADO` pino CK | 1 bit |
| `RESET` pino | `REG_ESTADO` pino CLR | 1 bit |
| `MW_SPLITTER` grupos 0�13 | Pinos de sa�da correspondentes | v�rios |

---

## 4. Casos de Teste

### T01 � Ciclo FETCH (universal)

**Configura��o:**
- `INSTR_CLASS[5:0]` = qualquer (ex: `0x29` para LDI)
- `STATE` = `000` (FETCH)
- `?ADDR` = `000_101001` = `0x029`

**Micropalavra esperada: `0x00009581`**

| Sinal | Valor | Decodifica��o |
|-------|-------|---------------|
| `ALU_OP` | `0000` | NOP |
| `ADDR_SRC` | `001` | R(P) |
| `REG_SEL_SRC` | `0010` | P |
| `MEM_RD` | `1` | L� opcode |
| `IR_LOAD` | `1` | Carrega IR |
| `REG_INC` | `1` | R(P)++ |
| `NEXT_STATE` | `001` | ? EXECUTE1 |

**Verifica��o:** ap�s CLK, `ESTADO` = `001` (EXECUTE1).

---

### T02 � LDI imediato (CLS=0x29, EXECUTE1)

**Configura��o:**
- `INSTR_CLASS` = `0x29` (LDI)
- `STATE` = `001` (EXECUTE1)
- `?ADDR` = `001_101001` = `0x069`

**Micropalavra esperada: `0x20849480`**

| Sinal | Valor | Significado |
|-------|-------|-------------|
| `ALU_OP` | `0010` | PASS_B |
| `SRC_B` | `010` | MEM (byte imediato) |
| `DST` | `0001` | D |
| `ADDR_SRC` | `001` | R(P) |
| `REG_SEL_SRC` | `0010` | P |
| `MEM_RD` | `1` | L� imediato |
| `REG_INC` | `1` | R(P)++ |
| `NEXT_STATE` | `000` | ? FETCH |

**Verifica��o:** ap�s CLK, `ESTADO` = `000` (FETCH).

---

### T03 � ADD (CLS=0x25, EXECUTE1)

**Configura��o:**
- `INSTR_CLASS` = `0x25` (ADD)
- `STATE` = `001`
- `?ADDR` = `0x065`

**Micropalavra esperada: `0x32859C20`**

| Sinal | Valor | Significado |
|-------|-------|-------------|
| `ALU_OP` | `0011` | ADD |
| `SRC_A` | `001` | D |
| `SRC_B` | `010` | MEM |
| `DST` | `0001` | D |
| `ADDR_SRC` | `011` | R(X) |
| `REG_SEL_SRC` | `0011` | X |
| `MEM_RD` | `1` | L� M[R(X)] |
| `DF_LOAD` | `1` | Atualiza DF |
| `NEXT_STATE` | `000` | ? FETCH |

---

### T04 � INC n (CLS=0x02, EXECUTE1)

**Configura��o:**
- `?ADDR` = `0x042`

**Micropalavra esperada: `0x00000880`**

| Sinal | Valor | Significado |
|-------|-------|-------------|
| `ALU_OP` | `0000` | NOP |
| `REG_SEL_SRC` | `0001` | N |
| `REG_INC` | `1` | R(N)++ |
| `NEXT_STATE` | `000` | ? FETCH |

---

### T05 � LDA n em 2 ciclos (CLS=0x05)

**EXECUTE1** (`?ADDR=0x045`): `0x20850C02`

| Sinal | Valor |
|-------|-------|
| `ALU_OP` | PASS_B |
| `SRC_B` | MEM |
| `DST` | D |
| `ADDR_SRC` | R(N) |
| `REG_SEL_SRC` | N |
| `MEM_RD` | 1 |
| `NEXT_STATE` | `010` (? **EXECUTE2**) |

**EXECUTE2** (`?ADDR=0x085`): `0x00000880`

| Sinal | Valor |
|-------|-------|
| `REG_SEL_SRC` | N |
| `REG_INC` | 1 |
| `NEXT_STATE` | `000` (? FETCH) |

**Sequ�ncia de estados:** FETCH ? EXECUTE1 ? EXECUTE2 ? FETCH (3 ciclos de clock)

---

### T06 � SEQ (CLS=0x15, EXECUTE1)

**`?ADDR=0x055`**: `0x20EC0010`

| Sinal | Valor |
|-------|-------|
| `ALU_OP` | PASS_B |
| `SRC_B` | LIT1 (=1) |
| `DST` | Q (=0xB) |
| `Q_LOAD` | 1 |
| `NEXT_STATE` | FETCH |

---

### T07 � REQ (CLS=0x14, EXECUTE1)

**`?ADDR=0x054`**: `0x202C0010`

| Sinal | Valor |
|-------|-------|
| `ALU_OP` | PASS_B |
| `SRC_B` | ZERO (=0) |
| `DST` | Q |
| `Q_LOAD` | 1 |
| `NEXT_STATE` | FETCH |

---

### T08 � Branch curto BR/BZ (CLS=0x04, EXECUTE1)

**`?ADDR=0x044`**: `0x20949408`

| Sinal | Valor |
|-------|-------|
| `ALU_OP` | PASS_B |
| `SRC_B` | MEM |
| `DST` | RP.L (=5) |
| `ADDR_SRC` | R(P) |
| `REG_SEL_SRC` | P |
| `MEM_RD` | 1 |
| `COND_EN` | **1** � hardware avalia condi��o via PLA |
| `NEXT_STATE` | FETCH |

---

### T09 � LBR/LBSK em 3 ciclos (CLS=0x1E)

**EXECUTE1** (`?ADDR=0x05E`): `0x20B0948A`

| Sinal | Valor |
|-------|-------|
| `DST` | TMPH |
| `MEM_RD` | 1 |
| `REG_INC` | 1 |
| `COND_EN` | 1 |
| `NEXT_STATE` | `010` (? EXECUTE2) |

**EXECUTE2** (`?ADDR=0x09E`): `0x20B49408`

| Sinal | Valor |
|-------|-------|
| `DST` | TMPL |
| `MEM_RD` | 1 |
| `COND_EN` | 1 |
| `NEXT_STATE` | FETCH |

---

## 5. Tabela Resumo de Micropalavras

| ?ADDR | Classe | Instru��o | Hex (32 bits) | ? Estado |
|-------|--------|-----------|---------------|----------|
| 0x029 | FETCH | (qualquer) | `00009581` | EXECUTE1 |
| 0x040 | IDL | IDL | `00000000` | FETCH |
| 0x041 | LDN | LDN n | `20850c00` | FETCH |
| 0x042 | INC | INC n | `00000880` | FETCH |
| 0x043 | DEC | DEC n | `00000840` | FETCH |
| 0x044 | BR | BR/BZ/BQ | `20949408` | FETCH |
| 0x045 | LDA | LDA n (EX1) | `20850c02` | EXECUTE2 |
| 0x085 | LDA | LDA n (EX2) | `00000880` | FETCH |
| 0x046 | STR | STR n | `12090a00` | FETCH |
| 0x047 | IRX | IRX | `00001880` | FETCH |
| 0x04c | LDXA | LDXA | `20859c80` | FETCH |
| 0x04d | STXD | STXD | `12099a40` | FETCH |
| 0x04e | ADC | ADC | `42859c20` | FETCH |
| 0x04f | SDB | SDB | `82859c20` | FETCH |
| 0x050 | SHRC | SHRC | `d2040020` | FETCH |
| 0x051 | SMB | SMB | `62859c20` | FETCH |
| 0x052 | SAV | SAV | `1e099a00` | FETCH |
| 0x053 | MARK | MARK (EX1) | `00000002` | **EXECUTE2** |
| 0x093 | MARK | MARK (EX2) | `00000000` | FETCH (hw especial) |
| 0x054 | REQ | REQ | `202c0010` | FETCH |
| 0x055 | SEQ | SEQ | `20ec0010` | FETCH |
| 0x056 | ADCI | ADCI | `428494a0` | FETCH |
| 0x05a | GLO | GLO n | `16040800` | FETCH |
| 0x05b | GHI | GHI n | `18040800` | FETCH |
| 0x05c | PLO | PLO n | `120c0800` | FETCH |
| 0x05d | PHI | PHI n | `12100800` | FETCH |
| 0x05e | LBSK | LBR/LSKP(EX1) | `20b0948a` | EXECUTE2 |
| 0x09e | LBSK | LBR/LSKP(EX2) | `20b49408` | FETCH |
| 0x05f | SEP | SEP n | `211c0000` | FETCH |
| 0x060 | SEX | SEX n | `21200000` | FETCH |
| 0x061 | LDX | LDX | `20859c00` | FETCH |
| 0x062 | OR | OR | `92859c00` | FETCH |
| 0x065 | ADD | ADD | `32859c20` | FETCH |
| 0x067 | SHR | SHR | `c2040020` | FETCH |
| 0x069 | LDI | LDI | `20849480` | FETCH |
| 0x06d | ADI | ADI | `328494a0` | FETCH |
| 0x06f | SHL | SHL | `e2040020` | FETCH |
| 0x070 | SMI | SMI | `528494a0` | FETCH |

---

## 6. Procedimento de Teste no Logisim

```
Para cada instru��o:
1. Defina INSTR_CLASS[5:0] com o valor da tabela
2. Pressione RESET (RESET=1 por um ciclo) para for�ar STATE=000
3. Avance 1 ciclo de clock ? observe sa�das do FETCH
4. Avance mais 1 ciclo ? observe sa�das do EXECUTE1
5. Se NEXT_STATE=010 (EXECUTE2), avance mais 1 ciclo
6. Compare as sa�das com as colunas da tabela acima
```

---

## 7. Depura��o R�pida

| Sintoma | Causa | Solu��o |
|---------|-------|---------|
| Todos sinais = 0 | �ROM n�o carregada | Right-click uROM ? Load Image ? uROM.mem |
| ESTADO n�o avan�a | CLK desconectado | Verificar fio CLK ? REG_ESTADO CK |
| Micropalavra errada | INSTR_CLASS incorreto | Verificar PLA ou usar valor manual na entrada |
| NEXT_STATE n�o realimenta | Fio grupo 14 ausente | MW_SPLITTER grupo 14 ? REG_ESTADO.D |
| Sa�das misturadas | Bit assignments do splitter errados | Conferir mapeamento bit0�bit31 no MW_SPLITTER |
