;K-MONITOR
;  PUCK & PUCK
;    K.Kuromusha
;No.11   1985/4/29 Mon.
 OFFSET $9000
 START  $0000
;
COLD  JMP START
;
CUR   DEFW $D000
PSP   DEFW 0
MODE  DEFB 0
;
RST1  JMP HOT
;
BCDAD !(00000000)
BOM   DEFB 0
;
RST2  JMP HOT
;
GD    DEFW 0
CLR   DEFB 0
SCORE DEFW 0
;
RST3  JMP HOT
;
HISC  DEFW 500
MEN   DEFB 0
MAN   DEFB 0
FLAG  DEFB 0
;
RST4  JMP HOT
;
SUB   DEFB 0
MYX   DEFB 0
MYY   DEFB 0
YX    DEFB 0
YY    DEFB 0
;
RST5  JMP HOT
;
BGMD  DEFB 0
MF    DEFB 0
 NOP
 NOP
 NOP
;
RST6  JMP HOT
;
 NOP
 NOP
 NOP
 NOP
 NOP
;
RST7  JMP HOT
;
START DO HL=IOR
 C=(HL+) A=(HL+) PORT(C)=A A+
 UNTIL Z
 GOTO HOT
;
IOR   !(E302)
 !(E734)
 !(E774)
 !(E7B4)
 !(E600)
 !(E600)
 !(E502)
 !(E402)
 !(E500)
 !(E400)
 !(E9CF)
 !(E900)
 !(EBCF)
 !(EBFF00)
;
NMI   JMP $0000
;
HOT   SP=$D000
 A=$80 PORT($E8)=A
 !CHR40
 DE=MTITL
 !CPUT
 !GRHO1
 !GCLR
 GOTO GS
;
MTITL !(06"** K-MONITOR **"00)
;
CHR40 A=0
 (MODE)=A
 A=PORT($E8)
 RES(5,A)
 PORT($E8)=A
 RET
;
CHR80 A=1
 (MODE)=A
 A=PORT($E8)
 SET(5,A)
 PORT($E8)=A
 RET
;
CLEAR (PSP)=SP
 HL=0 SP=$D7D0
 DO B=100
 [HL [HL [HL [HL [HL
 [HL [HL [HL [HL [HL
 UNTIL DEC(B)=0
 SP=(PSP)
 RET
;
PUT   HL=(CUR)
PUT1  A=(DE) IF A=0 THEN (CUR)=HL RET
 (HL)=A HL+ DE+
 GOTO PUT1
;
APUT  HL=(CUR) (HL)=A
APUT0 HL+ (CUR)=HL
 RET
;
ACPUT IF A>=7 GOTO APUT
 IF A=6 THEN !CLEAR HL=$CFFF GOTO APUT0
 IF A=5 THEN HL=$CFFF GOTO APUT0
 IF A=4 THEN !CONT4 GOTO APUT0
 IF A=3 THEN HL=(CUR) GOTO APUT0
 IF A=2 THEN !CONT2 GOTO APUT0
 IF A=1 THEN !CONT1 GOTO APUT0
 RET
;
CONT4 HL=(CUR)
 [HL DE=$D000
 HL=HL-DE ]HL
 IF Z THEN HL=$D001
 HL--
 RET
;
CONT1 A=(MODE)
 DE=40 IF A<>0 THEN DE=80
 HL=(CUR) HL=HL+DE
 HL-
 RET
;
CONT2 A=(MODE)
 DE=40 IF A<>0 THEN DE=80
 HL=(CUR) HL=HL-DE
 [HL DE=$D000
 CY=0 HL=HL-DE ]HL
 IF CY THEN HL=$D000
 HL-
 RET
;
CPUT  HL=(CUR)
CPUT1 A=(DE+) IF A=0 RET
 IF A<7 THEN [DE !ACPUT ]DE GOTO CPUT2
 (HL+)=A
CPUT2 (CUR)=HL
 GOTO CPUT1
;
IX  EQU $DD
IY  EQU $FD
n   EQU $00
;
MUSIC
 A=(HL+) .IX L=A
 A=(HL+) .IX H=A IF A=0 RET
;
 A=(HL+) IF A=1 THEN A=0 GOTO MLOP1
 (T1)=A A=1
MLOP1
 (S1)=A
 A=(HL+) IF A=1 THEN A=0 GOTO MLOP2
 (T2)=A A=1
MLOP2
 (S2)=A
 A=(HL+) IF A=1 THEN A=0 GOTO MLOP3
 (T3)=A A=1
MLOP3
 (S3)=A
 A=(HL+) IF A=1 THEN A=0 GOTO MLOP4
 (T4)=A A=1
MLOP4
 (S4)=A
 A=(HL+) IF A=1 THEN A=0 GOTO MLOP5
 (T5)=A A=1
MLOP5
 (S5)=A
 A=(HL+) IF A=1 THEN A=0 GOTO MLOP6
 (T6)=A A=1
MLOP6
 (S6)=A
 [HL
;
TONE
 HL=$0404 DE=$0404 BC=$04E3 EXX
 HL=$0404 DE=$0404 BC=$04E3
 IY=$0404
;
MLOOP
;
A1
        DJNZ A1+8         B=n A=L A=A.XOR.n L=A
 PORT(C)=L
A2
     IF DEC(D)=0 THEN     D=n A=E A=A.XOR.n E=A
 PORT(C)=E
A3
 .IY IF DEC(H)=0 THEN .IY H=n A=H A=A.XOR.n H=A
 PORT(C)=H EXX
A4
 .IY IF DEC(L)=0 THEN .IY L=n A=H A=A.XOR.n H=A
 PORT(C)=H
A5
     IF DEC(D)=0 THEN     D=n A=E A=A.XOR.n E=A
 PORT(C)=E
A6
     DJNZ A6+8            B=n A=L A=A.XOR.n L=A
 PORT(C)=L EXX
;
 .IX IF DEC(L)<>0 GOTO MLOOP
 .IX IF DEC(H)<>0 GOTO MLOOP
 ]HL
 JMP MUSIC
;
HLSAVE  EQU TONE+1
DESAVE  EQU TONE+4
BCSAVE  EQU TONE+7
xHLSAVE EQU TONE+11
xDESAVE EQU TONE+14
xBCSAVE EQU TONE+17
IYSAVE  EQU TONE+21
;
T1 EQU A1+3
S1 EQU A1+6
T2 EQU A2+4
S2 EQU A2+7
T3 EQU A3+6
S3 EQU A3+9
T4 EQU A4+6
S4 EQU A4+9
T5 EQU A5+4
S5 EQU A5+7
T6 EQU A6+3
S6 EQU A6+6
;
P1    EQU 40000
P2    EQU 20000
P4    EQU 10000
P8    EQU 5000
P16   EQU 2500
P32   EQU 1250
P8F   EQU 7500
END   EQU 0
;
R     EQU 1
C     EQU 227
SC    EQU 214
D     EQU 202
SD    EQU 191
E     EQU 180
SE    EQU 170
F     EQU SE
SF    EQU 160
G     EQU 152
SG    EQU 143
A     EQU 135
SA    EQU 128
B     EQU 120
SB    EQU 113
 ;
UC    EQU SB
USC   EQU SC/2
UD    EQU D/2
USD   EQU SD/2
UE    EQU E/2
USE   EQU SE/2
UF    EQU F/2
USF   EQU SF/2
UG    EQU G/2
USG   EQU SG/2
UA    EQU A/2
USA   EQU SA/2
UB    EQU B/2
USB   EQU SB/2
 ;
TC    EQU UC/2
TSC   EQU USC/2
TD    EQU UD/2
TSD   EQU USD/2
TE    EQU UE/2
TSE   EQU USE/2
TF    EQU UF/2
TSF   EQU USF/2
TG    EQU UG/2
TSG   EQU USG/2
TA    EQU UA/2
TSA   EQU USA/2
TB    EQU UB/2
TSB   EQU USB/2
 ;
ZC    EQU TC/2
ZSC   EQU TSC/2
ZD    EQU TD/2
ZSD   EQU TSD/2
ZE    EQU TE/2
ZSE   EQU TSE/2
ZF    EQU TF/2
ZSF   EQU TSF/2
ZG    EQU TG/2
ZSG   EQU TSG/2
ZA    EQU TA/2
ZSA   EQU TSA/2
ZB    EQU TB/2
ZSB   EQU TSB/2
 ;
XC    EQU ZC/2
XSC   EQU ZSC/2
XD    EQU ZD/2
XSD   EQU ZSD/2
XE    EQU ZE/2
XSE   EQU ZSE/2
XF    EQU ZF/2
XSF   EQU ZSF/2
XG    EQU ZG/2
XSG   EQU ZSG/2
XA    EQU ZA/2
XSA   EQU ZSA/2
XB    EQU ZB/2
XSB   EQU ZSB/2
 ;
KEY   HL=KEYD
 DE=KEYD+1
 BC=7
 (HL)=0
 LDIR
 HL=KEYD
 A=PORT($E8) A=A.AND.$F0
 A=A.OR.$12 PORT($E8)=A
 A=PORT($EA)
 BIT(2,A) IF Z THEN (HL)=1
 HL+
 BIT(4,A) IF Z THEN (HL)=1
 HL+
 BIT(6,A) IF Z THEN (HL)=1
 HL+
 A=PORT($E8) A=A.AND.$F0
 A=A.OR.$11 PORT($E8)=A
 A=PORT($EA)
 BIT(2,A) IF Z THEN (HL)=1
 HL+
 A=PORT($E8) A=A.AND.$F0
 A=A.OR.$13 PORT($E8)=A
 A=PORT($EA)
 BIT(1,A) IF Z THEN (HL)=1
 HL+
 BIT(0,A) IF Z THEN (HL)=1
 HL+
 BIT(2,A) IF Z THEN (HL)=1
 HL+
 BIT(7,A) IF Z THEN (HL)=1
 RET
;
KEYD  DEFS 8
;
CHL   A=(MODE)
 DE=40 IF A<>0 THEN DE=80
 B=L C=H
 HL=$D000
 IF B=0 GOTO CHL0
 DO
 HL=HL+DE
 UNTIL DEC(B)=0
CHL0  HL=HL+BC
 (CUR)=HL
 RET
;
BCDA  C=10 D=$FF B=$30
 DO CY=0
 A=A-C D+
 UNTIL CY
 A=A+C HL=BCDAD+2
 A=A+B (HL-)=A A=D
 DO D=$FF
 A=A-C D+
 UNTIL CY
 A=A+C A=A+B
 (HL-)=A A=D
 A=A+B (HL)=A
 IF A<>"0" RET
 A=" " (HL)=A
 RET
;
BCDHL DE=BCDHD BC=10000
 A=$FF DO CY=0
 HL=HL-BC A+
 UNTIL CY
 HL=HL+BC A=A+$30
 (DE+)=A A=$FF
 DO BC=1000
 HL=HL-BC A+
 UNTIL CY
 HL=HL+BC A=A+$30
 (DE+)=A A=$FF
 DO BC=100
 HL=HL-BC A+
 UNTIL CY
 HL=HL+BC A=A+$30
 (DE+)=A A=$FF
 DO BC=10
 HL=HL-BC A+
 UNTIL CY
 HL=HL+BC A=A+$30
 (DE+)=A A=L
 A=A+$30 (DE)=A
 DE=BCDHD
 DO B=5
 A=(DE)
 IF A<>"0" RET
 A=" " (DE+)=A
 UNTIL DEC(B)=0
 RET
;
BCDHD DEFS 6
;
GPUT8 HL=(GD)
 DO B=8
 A=(DE+) (HL)=A
 [BC BC=40
 HL=HL+BC
 ]BC
 UNTIL DEC(B)=0
 (GD)=HL
 RET
;
GPUT6 HL=(GD)
 [HL
 !GPUT8 !GPUT8
 ]HL HL+
 (GD)=HL
 !GPUT8 !GPUT8
 RET
;
GCLR  (PSP)=SP
 HL=0 SP=$FF40
 DO B=200
 [HL [HL [HL [HL [HL
 [HL [HL [HL [HL [HL
 [HL [HL [HL [HL [HL
 [HL [HL [HL [HL [HL
 UNTIL DEC(B)=0
 SP=(PSP)
 RET
;
SCRR  A=PORT($E0)
 RES(4,A)
 PORT($E0)=A
 RET
;
SCRN  A=PORT($E0)
 SET(4,A)
 PORT($E0)=A
 RET
;
GRHO0 A=0 PORT($F4)=A
 RET
;
GRHO1 A=2 PORT($F4)=A
 RET
;
GGHL  D=0 E=H
 IF L=0 THEN DE<>HL GOTO GGHL0
 B=L HL=320
 DO HL<>DE
 HL=HL+DE
 UNTIL DEC(B)=0
GGHL0 DE=$E000 HL=HL+DE
 (GD)=HL RET
;
GS    !DEMO !SK1
L0    !SK2
LOOP  !IMOVE !CLR? !BGM
 A=(BOM) IF A<>0 GOTO BOMY
 A=(CLR) IF A=0 GOTO CLRY
 !SSC !YMOVE
 A=(BOM) IF A<>0 GOTO BOMY
 GOTO LOOP
;
SK1   HL=0 (SCORE)=HL
 A=3 (MAN)=A
 A=1 (MEN)=A (SUB)=A
 A=0 (FLAG)=A !GRHO1
 RET
;
GDT0  !(FF55FF55FF55FF55)
GDT1  !(7CAA7C38EE386C82)
GDT2  !(C37E185AE77E24E7)
GDT3  !(0000000000000000)
;
SK2   A=0 (CLR)=A
 (BOM)=A A+ (BGMD)=A
 !CLEAR !GCLR
 DO H=40
 [HL H-
 L=0 !GGHL
 DE=GDT0 !GPUT8 ]HL
 [HL H-
 L=2 !GGHL
 DE=GDT0 !GPUT8 ]HL
 [HL H-
 L=24 !GGHL
 DE=GDT0 !GPUT8 ]HL
 UNTIL DEC(H)=0
 DO L=25
 [HL L- H=0
 !GGHL DE=GDT0
 !GPUT8 ]HL [HL L-
 H=39 !GGHL
 DE=GDT0 !GPUT8 ]HL
 UNTIL DEC(L)=0
SK20  A=(MAN) A- IF A=0 GOTO SK2S
 DO B=A
 L=1 H=31 A=B
 A=A+H H=A [BC !GGHL
 DE=GDT1 !GPUT8 ]BC
 UNTIL DEC(B)=0
SK2S  A=(SUB) IF A=0 RET
 DE=Жовн !CPUT !SSC
 A=(MEN) HL=MD-798 DE=798
 DO B=A
 HL=HL+DE
 UNTIL DEC(B)=0
 BC=0
SK21  A=(HL+) IF A=" " GOTO SK22
 IF A="." THEN [BC [HL A=1 A=A+B H=A A=3 A=A+C L=A !CHL A="." !APUT A=(CLR) A+ (CLR)=A ]HL ]BC GOTO SK22
 IF A="" THEN [BC [HL A=1 A=A+B H=A A=3 A=A+C L=A !CHL A="" !APUT ]HL ]BC GOTO SK22
 IF A="A" THEN A=1 A=A+B (MYX)=A A=3 A=A+C (MYY)=A GOTO SK22
 A=1 A=A+B (YX)=A A=3 A=A+C (YY)=A
SK22  B+ A=B IF A=38 THEN B=0 C+
 A=C IF A<>21 GOTO SK21
 A=(MYX) H=A A=(MYY) L=A !GGHL DE=GDT1 !GPUT8
 A=(YX) H=A A=(YY) L=A !GGHL DE=GDT2 !GPUT8
 RET
;
Жовн  !("SCORE      0  HI-SCORE      0       00"00)
;
SSC   HL=(SCORE) [HL A=(FLAG)
 CY=0 DE=1000 HL=HL-DE
 IF CY GOTO SSC0
 IF A=0 THEN (SUB)=A A=(MAN) A+ (MAN)=A !SK20 !SSCM A=1 (SUB)=A (FLAG)=A
SSC0  ]HL [HL DE=$D02F (CUR)=DE
 !BCDHL DE=BCDHD !PUT
 ]HL DE=(HISC) [DE
 CY=0 HL=HL-DE
 IF NC THEN HL=(SCORE) (HISC)=HL
 ]HL DE=$D040 (CUR)=DE
 !BCDHL DE=BCDHD !PUT
 A=(MEN) !BCDA
 DE=$D04C (CUR)=DE
 DE=BCDAD !PUT RET
;
SSCM  HL=SSCMD !MUSIC RET
;
SSCMD 'P16 .ZG .ZB .ZG .ZB .ZG .ZB
 'P32 .R  .R  .R  .R  .R  .R
 'P16 .ZB .ZG .ZB .ZG .ZB .ZG
 'P32 .R  .R  .R  .R  .R  .R
 'P16 .ZG .ZB .ZG .ZB .ZG .ZB
 'P32 .R  .R  .R  .R  .R  .R
 'P16 .ZB .ZG .ZB .ZG .ZB .ZG
 'P32 .R  .R  .R  .R  .R  .R
 'END
;
DEMO  !GCLR DE=DEMO1 !CPUT
DEMO0 !KEY A=(KEYD+6) IF A=0 GOTO DEMO0
 RET
;
DEMO1 !("** PUCK & PUCK **by K.KuromushaPUSH [CR] KEY"00)
;
CLRY  HL=(SCORE) DE=100 HL=HL+DE (SCORE)=HL
 !SSC HL=CLRMU !MUSIC A=(MEN) A+ (MEN)=A
 IF A<>11 GOTO L0
 A=(CLR) A- (CLR)=A !CLEAR DE=Жовн
 !CPUT !SSC HL=$0D0D !CHL DE=CLRY0
 !PUT DO B=7 DO HL=0
 UNTIL DEC(HL)=0 UNTIL DEC(B)=0
 GOTO GS
;
CLRY0 !("GIVE UP !!"00)
BOMY0 !("GAME OVER"00)
;
CLRMU 'P8 .ZC .ZC .TC .ZC .ZC .ZC
 'P8 .TD .ZD .ZD .ZD .ZD .ZD
 'P8 .R  .R  .R  .R  .R  .R
 'P8 .ZD .ZD .ZD .TD .ZD .ZD
 'P8 .R  .R  .R  .R  .R  .R
 'P8 .ZD .TD .ZD .ZD .ZD .ZD
 'P8 .R  .R  .R  .R  .R  .R
 'P8 .ZD .ZD .ZD .TD .ZD .ZD
 'P4 .ZA .ZA .ZB .ZB .ZA .ZA
 'END
;
BOMY  HL=BOMMU !MUSIC A=(MAN) A- (MAN)=A
 IF A<>0 GOTO L0
 !CLEAR DE=Жовн !CPUT !SSC HL=$0D0D
 !CHL DE=BOMY0 !PUT DO B=7 DO HL=0
 UNTIL DEC(HL)=0 UNTIL DEC(B)=0
 GOTO GS
;
BOMMU
 'P32 .TC .TD .TE .TF .TG .TA
 'P32 .TD .TE .TF .TG .TA .TB
 'P32 .TC .TD .TE .TF .TG .TA
 'P32 .TD .TE .TF .TG .TA .TB
 'P32 .TC .TD .TE .TF .TG .TA
 'P32 .TD .TE .TF .TG .TA .TB
 'P32 .TC .TD .TE .TF .TG .TA
 'P32 .TD .TE .TF .TG .TA .TB
 'P32 .TC .TD .TE .TF .TG .TA
 'P32 .TD .TE .TF .TG .TA .TB
 'P32 .TC .TD .TE .TF .TG .TA
 'P32 .TD .TE .TF .TG .TA .TB
 'P32 .TC .TD .TE .TF .TG .TA
 'P32 .TD .TE .TF .TG .TA .TB
 'P32 .TC .TD .TE .TF .TG .TA
 'P32 .TD .TE .TF .TG .TA .TB
 'END
;
IMOVE !KEY HL=KEYD
 A=(HL+) IF A=1 GOTO I2
 A=(HL+) IF A=1 GOTO I4
 A=(HL+) IF A=1 GOTO I6
 A=(HL) IF A=1 GOTO I8
 RET
I2    HL=(MYX) A=H IF A=23 RET
 E=H D=L DE<>HL !CHL HL=(CUR)
 DE=40 HL=HL+DE A=(HL) IF A="" RET
 IF A="." THEN A=(CLR) A- (CLR)=A HL=(SCORE) HL+ (SCORE)=HL
 !ICLR A=(MYY) A+ (MYY)=A GOTO IM0
I8    HL=(MYX) A=H IF A=3 RET
 E=H D=L DE<>HL !CHL HL=(CUR)
 DE=40 HL=HL-DE A=(HL) IF A="" RET
 IF A="." THEN A=(CLR) A- (CLR)=A HL=(SCORE) HL+ (SCORE)=HL
 !ICLR A=(MYY) A- (MYY)=A
IM0   A=(MYX) H=A A=(MYY) L=A [HL !CHL A=" " !APUT
 ]HL !GGHL DE=GDT1 !GPUT8
 HL=(MYX) DE<>HL HL=(YX)
 HL=HL-DE IF Z THEN A=1 (BOM)=A
 RET
ICLR  A=(MYX) H=A A=(MYY) L=A !GGHL
 DE=GDT3 !GPUT8 RET
I4    HL=(MYX) A=L IF A=1 RET
 E=H D=L DE<>HL !CHL HL=(CUR)
 HL- A=(HL) IF A="" RET
 IF A="." THEN A=(CLR) A- (CLR)=A HL=(SCORE) HL+ (SCORE)=HL
 !ICLR A=(MYX) A- (MYX)=A GOTO IM0
I6    HL=(MYX) A=L IF A=38 RET
 E=H D=L DE<>HL !CHL HL=(CUR)
 HL+ A=(HL) IF A="" RET
 IF A="." THEN A=(CLR) A- (CLR)=A HL=(SCORE) HL+ (SCORE)=HL
 !ICLR A=(MYX) A+ (MYX)=A GOTO IM0
;
CLR?  !KEY HL=KEYD C=0
 DO B=8
 A=(HL+) IF A=1 THEN C+
 UNTIL DEC(B)=0
 A=C IF A=8 THEN A=0 (CLR)=A
 RET
;
YMOVE A=(MF)
 IF A=0 THEN A+ (MF)=A !(ED5F) A=A.&.3 GOTO YM0
 A- (MF)=A A=(MYY) B=A A=(YY)
 IF A=B GOTO YMX
 A=(MYX) B=A A=(YX)
 IF A=B GOTO YMY
YMX   A=(MYX) B=A A=(YX)
 IF A<B THEN A=1 GOTO YM0
 A=0 GOTO YM0
YMY   A=(MYY) B=A A=(YY)
 IF A<B THEN A=2 GOTO YM0
 A=3
YM0   IF A=0 GOTO Y4
 IF A=1 GOTO Y6
 IF A=2 GOTO Y2
 HL=(YX) A=H IF A=3 RET
 E=H D=L DE<>HL !CHL HL=(CUR)
 DE=40 HL=HL-DE A=(HL) IF A="" RET
 !YCLR A=(YY) A- (YY)=A GOTO YMO
Y2    HL=(YX) A=H IF A=23 RET
 E=H D=L DE<>HL !CHL HL=(CUR)
 DE=40 HL=HL+DE A=(HL) IF A="" RET
 !YCLR A=(YY) A+ (YY)=A
YMO   A=(YX) H=A A=(YY) L=A
 !GGHL DE=GDT2 !GPUT8
 HL=(MYX) DE<>HL HL=(YX)
 HL=HL-DE IF Z THEN A=1 (BOM)=A
 RET
YCLR  A=(YX) H=A A=(YY) L=A !GGHL
 DE=GDT3 !GPUT8 RET
Y4    HL=(YX) A=L IF A=1 RET
 E=H D=L DE<>HL !CHL HL=(CUR)
 HL- A=(HL) IF A="" RET
 !YCLR A=(YX) A- (YX)=A GOTO YMO
Y6    HL=(YX) A=L IF A=38 RET
 E=H D=L DE<>HL !CHL HL=(CUR)
 HL+ A=(HL) IF A="" RET
 !YCLR A=(YX) A+ (YX)=A GOTO YMO
;
BGM   A=(BGMD) HL=BGMMU-10 DE=10
 DO B=A
 HL=HL+DE
 UNTIL DEC(B)=0
 !MUSIC
 A=(BGMD) A+ IF A=45 THEN A=1
 (BGMD)=A RET
;
BGMMU
 'P16 .ZC .ZC .ZC .ZC .ZC .ZC 'END
 'P16 .ZC .ZC .ZC .ZC .ZC .R  'END
 'P16 .ZC .ZC .ZC .ZC .ZC .ZC 'END
 'P16 .ZD .ZD .ZD .ZD .ZD .R  'END
 'P16 .ZE .ZE .ZE .ZE .ZE .ZC 'END
 'P16 .ZE .ZE .ZE .ZE .ZE .R  'END
 'P16 .ZE .ZE .ZE .ZE .ZE .ZC 'END
 'P16 .ZD .ZD .ZD .ZD .ZD .R  'END
 'P16 .ZD .ZD .ZD .ZD .ZD .ZE 'END
 'P16 .ZG .ZG .ZG .ZG .ZG .R  'END
 'P16 .ZD .ZD .ZD .ZD .ZD .ZE 'END
 'P16 .ZG .ZG .ZG .ZG .ZG .R  'END
 'P16 .ZD .ZD .ZD .ZD .ZD .ZE 'END
 'P16 .R  .R  .R  .R  .R  .R  'END
 'P16 .ZC .ZC .ZC .ZC .ZC .ZC 'END
 'P16 .ZC .ZC .ZC .ZC .ZC .R  'END
 'P16 .ZC .ZC .ZC .ZC .ZC .ZC 'END
 'P16 .ZD .ZD .ZD .ZD .ZD .R  'END
 'P16 .ZE .ZE .ZE .ZE .ZE .ZC 'END
 'P16 .ZE .ZE .ZE .ZE .ZE .R  'END
 'P16 .ZE .ZE .ZE .ZE .ZE .ZC 'END
 'P16 .ZD .ZD .ZD .ZD .ZD .R  'END
 'P16 .ZD .ZD .ZD .ZD .ZD .ZE 'END
 'P16 .ZG .ZG .ZG .ZG .ZG .R  'END
 'P16 .ZD .ZD .ZD .ZD .ZD .ZE 'END
 'P16 .ZG .ZG .ZG .ZG .ZG .R  'END
 'P16 .ZD .ZD .ZD .ZD .ZD .ZE 'END
 'P16 .R  .R  .R  .R  .R  .R  'END
 'P16 .ZG .ZG .ZG .ZG .ZG .ZC 'END
 'P16 .ZF .ZF .ZF .ZF .ZF .ZD 'END
 'P16 .ZE .ZE .ZE .ZE .ZE .ZC 'END
 'P16 .ZD .ZD .ZD .ZD .ZD .ZD 'END
 'P16 .ZC .ZC .ZC .ZC .ZC .ZC 'END
 'P16 .ZC .ZC .ZC .ZC .ZC .ZC 'END
 'P16 .ZC .ZC .ZC .ZC .ZC .ZC 'END
 'P16 .R  .R  .R  .R  .R  .R  'END
 'P16 .ZG .ZG .ZG .ZG .ZG .ZC 'END
 'P16 .ZF .ZF .ZF .ZF .ZF .ZD 'END
 'P16 .ZE .ZE .ZE .ZE .ZE .ZC 'END
 'P16 .ZD .ZD .ZD .ZD .ZD .ZD 'END
 'P16 .ZC .ZC .ZC .ZC .ZC .ZC 'END
 'P16 .ZC .ZC .ZC .ZC .ZC .ZC 'END
 'P16 .ZC .ZC .ZC .ZC .ZC .ZC 'END
 'P16 .R  .R  .R  .R  .R  .R  'END
;
MD
;1
 !("A                                     ")
 !(" .................. ")
 !("                                      ")
 !(" .................. ")
 !("                                      ")
 !(" .................. ")
 !("                                      ")
 !(" .................. ")
 !("                                      ")
 !(" .................. ")
 !("                                      ")
 !(" .................. ")
 !("                                      ")
 !(" .................. ")
 !("                                      ")
 !(" .................. ")
 !("                                      ")
 !(" .................. ")
 !("                                      ")
 !(" .................. ")
 !("                                     B")
;2
 !("A                                     ")
 !(" .. ")
 !(" .................................... ")
 !(" .. ")
 !("                  ..                  ")
 !(" .. ")
 !(" .................................... ")
 !(" .. ")
 !("                  ..                  ")
 !(" .. ")
 !(" .................................... ")
 !(" .. ")
 !("                  ..                  ")
 !(" .. ")
 !(" .................................... ")
 !(" .. ")
 !("                  ..                  ")
 !(" .. ")
 !(" .................................... ")
 !(" .. ")
 !("                                     B")
;3
 !("A                                     ")
 !(" .................. ")
 !(" .................. ")
 !(" .................. ")
 !("                                      ")
 !("                    ")
 !("                    ")
 !("                    ")
 !("                                      ")
 !(" .................. ")
 !(" .................. ")
 !(" .................. ")
 !("                                      ")
 !("                    ")
 !("                    ")
 !("                    ")
 !("                                      ")
 !(" .................. ")
 !(" .................. ")
 !(" .................. ")
 !("                                     B")
;4
 !("A                                     ")
 !(" ")
 !("                                     ")
 !("   ")
 !("                                B  ")
 !("                    ")
 !("   . . . . . . . .. . . . . . .    ")
 !("                    ")
 !("   . . . . . . . .. . . . . . .    ")
 !("                    ")
 !("   . . . . . . . .. . . . . . .    ")
 !("                    ")
 !("   . . . . . . . .. . . . . . .    ")
 !("                    ")
 !("   . . . . . . . .. . . . . . .    ")
 !("                    ")
 !("                                   ")
 !("    ")
 !("                                    ")
 !("  ")
 !("                                      ")
;5
 !("A                                     ")
 !("      ")
 !("                                      ")
 !("      ")
 !("                                      ")
 !("    ")
 !("                                    ")
 !(" .................. ")
 !(" .................................. ")
 !(" .................. ")
 !(" .................................. ")
 !(" .................. ")
 !(" .................................. ")
 !(" .................. ")
 !("                                  B ")
 !("    ")
 !("                                      ")
 !("      ")
 !("                                      ")
 !("      ")
 !("                                      ")
;6
 !("A                  .                  ")
 !("  ")
 !("                  .                   ")
 !("  ")
 !("                   .                  ")
 !("  ")
 !("                  .                   ")
 !("  ")
 !("                   .                  ")
 !("  ")
 !("                  .                   ")
 !("  ")
 !("                   .                  ")
 !("  ")
 !("                  .                   ")
 !("  ")
 !("                   .                  ")
 !("  ")
 !("                  .                   ")
 !("  ")
 !("                   B                  ")
;7
 !("                                      ")
 !(" .................. ")
 !("                    ")
 !(" .................. ")
 !("                    ")
 !(" .................. ")
 !("                    ")
 !(" .................. ")
 !("                    ")
 !(" .................. ")
 !("                                      ")
 !(" .................. ")
 !("                    ")
 !(" .................. ")
 !("                    ")
 !(" .................. ")
 !("                    ")
 !(" .................. ")
 !("                    ")
 !(" .................. ")
 !("                                     B")
;8
 !("A                                     ")
 !("                          ")
 !(" ........................ ")
 !("                          ")
 !("                          ")
 !(" ........................ ")
 !("                          ")
 !("                          ")
 !(" ........................ ")
 !("                          ")
 !("                          ")
 !(" ........................ ")
 !("                          ")
 !("                          ")
 !(" ........................ ")
 !("                          ")
 !("                          ")
 !(" ........................ ")
 !("                          ")
 !("                          ")
 !("                                     B")
;9
 !("A                                     ")
 !(" .......... ")
 !(" .           . . . . . . . . ")
 !(" .......... ")
 !(" . .           . . . . . . . ")
 !(" .......... ")
 !(" . . .           . . . . . . ")
 !(" .......... ")
 !(" . . . .           . . . . . ")
 !(" .......... ")
 !(" . . . . .           . . . . ")
 !(" .......... ")
 !(" . . . . . .           . . . ")
 !(" .......... ")
 !(" . . . . . . .           . . ")
 !(" .......... ")
 !(" . . . . . . . .           . ")
 !(" .......... ")
 !("                   B                  ")
 !("  ")
 !(" . . . . . . . . .  . . . . . . . . . ")
;10
 !(".     .     .     .     .     .     . ")
 !(" ")
 !(" .     .     .     .     .     .     .")
 !(" ")
 !(".     .     .     .     .     .     . ")
 !(" ")
 !("                                      ")
 !("                          ")
 !(" .......................... ")
 !("                          ")
 !("                          ")
 !(" .......................... ")
 !("           A  B           ")
 !("           .  .           ")
 !("                                      ")
 !(" ")
 !(" .     .     .     .     .     .     .")
 !(" ")
 !(".     .     .     .     .     .     . ")
 !(" ")
 !(" .     .     .     .     .     .     .")

PROGRAMEND

