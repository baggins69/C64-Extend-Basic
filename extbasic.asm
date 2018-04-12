; ============================================================
;       SAMPLE WEDGE - ADDING FOUR NEW BASIC COMMANDS
;          6502 ASSEMBLY CODE FOR THE COMMODORE 64
; ============================================================
;                        VERSION 2
;                (c)1985 BY SCOTT JULIAN

; THIS SAMPLE SHOW YOU HOW TO ADD FOUR NEW BASIC COMMANDS. THE
; COMMANDS ARE SIMPLE AND USE SHOULD BE ABLE TO CREATE MORE
; COMMANDS OF YOUR OWN USING THIS FRAMEWORK.
;     !CLS             CLEAR SCREEN
;     !BRD             CHANGE BORDER COLOUR
;     !SCR             CHANGE SCREEN COLOUR
;     !TXT             CHANGE TEXT COLOUR
;     !HELP            DISPLAY LIST OF COMMANDS

; ============================================================
;  STARTUP
; ============================================================

* = $C000    ; START ADDRESS 49152

; ============================================================
;  KERNAL
; ============================================================

CHRGET    = $0073
TXTPTR    = $7A
IERROR    = $0300
IMAIN     = $0302
IGONE     = $0308
GONE      = $A7E4
CHKCOM    = $AEFD
FRMNUM    = $AD8A
GETADR    = $B7F7
CHROUT    = $FFD2
BORDER    = $D020
SCREEN    = $D021
TEXT      = $0286

; ============================================================
;  SETUP SCREEN DISPLAY
; ============================================================

            LDA #4            ; CHANGE BORDER COLOUR TO
            STA BORDER        ; BLACK
            LDA #147          ; PRINT CHR$(147) TO CLEAR
            JSR CHROUT        ; SCREEN

            LDY #$00
DISPLAY     LDA TITLE,Y
            JSR CHROUT
            INY
            CPY #23           ; NUMBER OF CHARACTERS TO READ
            BNE DISPLAY

; ============================================================
;  CHANGE BASIC COMMAND POINTERS
; ============================================================

INIT        LDX #<NEWBASIC
            LDY #>NEWBASIC
            STX IGONE
            STY IGONE+1
            RTS

            LDX #$83
            LDY #$A4
            STX IMAIN         ; ($0302)
            STY IMAIN+1       ; ($0303)

; ============================================================
;  CHECK FOR NEW COMMANDS, IS FIRST CHARACTER !
; ============================================================

NEWBASIC    JSR CHRGET        ; GET CHARACTER
            CMP #'!'          ; IS IT A "!" ?
            BEQ CHK           ; YES, CONTINUE
            JMP GONE+3        ; NORMAL WORD

; ============================================================
;  CHECK WHICH NEW COMMAND HAS BEEN ISSUED
; ============================================================

CHK         JSR CHRGET        ; GET NEXT CHARACTER
            CMP #'C'          ; IS IT A "C" ?
            BEQ CLS           ; YES, JUMP TO CLS
            CMP #'B'          ; IS IT A "B" ?
            BEQ BDR           ; YES, JUMP TO BRD
            CMP #'S'          ; IS IT A "S" ?
            BEQ SCR           ; YES, JUMP SCR
            CMP #'T'          ; IS IT A "T" ?
            BEQ TEX           ; YES, JUMP TEX
            CMP #'H'          ; IS IT A "H" ?
            BEQ HELP          ; YES, JUMP HELP
            JMP (IERROR)      ; JUMP TO ERROR CHECK


; ============================================================
;  NEW COMMAND TO CLEAR SCREEN
; ============================================================

CLS         JSR CHRGET        ; GET THE L
            JSR CHRGET        ; GET THE S
            LDA #$93          ; LOAD A WITH CHR$(147)
            JSR CHROUT        ; PRINT A
            JMP GONE

; ============================================================
;  NEW COMMAND TO CHANGE SCREEN COLOUR
; ============================================================

SCR        JSR CHRGET            ; GET THE C
           JSR CHRGET            ; GET THE R
           JSR CHRGET            ; GET THE ,
           JSR CHKCOM            ; SKIP THE COMMA
           JSR FRMNUM            ; EVALUATE NUMBER
           JSR GETADR            ; CONVERT TO A 2-BYTE INTEGER
                                 ; A HAS HI BYTE
                                 ; Y HAS LO BYTE
           STY SCREEN            ; PUT IN SCREEN COLOUR
           JMP END2

; ============================================================
;  NEW COMMAND TO CHANGE TEXT COLOUR
; ============================================================

TEX        JSR CHRGET             ; GET THE X
           JSR CHRGET             ; GET THE T
           JSR CHRGET             ; GET THE ,
           JSR CHKCOM             ; SKIP THE COMMA
           JSR FRMNUM             ; EVALUATE NUMBER
           JSR GETADR             ; CONVERT TO A 2-BYTE INTEGER
                                  ; A HAS HI BYTE
                                  ; Y HAS LO BYTE
           STY TEXT               ; PUT IN BORDER COLOUR
           JMP END2

; ============================================================
;  NEW COMMAND TO CHANGE BORDER COLOUR
; ============================================================

BDR        JSR CHRGET             ; GET THE D
           JSR CHRGET             ; GET THE R
           JSR CHRGET             ; GET THE ,
           JSR CHKCOM             ; SKIP THE COMMA
           JSR FRMNUM             ; EVALUATE NUMBER
           JSR GETADR             ; CONVERT TO A 2-BYTE INTEGER
                                  ; A HAS HI BYTE
                                  ; Y HAS LO BYTE
           STY BORDER             ; PUT IN BORDER COLOUR
           JMP END2

; ============================================================
;  HELP, DISPLAY ALL COMMANDS AND SYNTX
; ============================================================

HELP        JSR CHRGET             ; GET THE E
            JSR CHRGET             ; GET THE L
            JSR CHRGET             ; GET THE P

            LDY #$00
DISHELP     LDA HELPTX,Y
            JSR CHROUT
            INY
            CPY #170        ; NUMBER OF CHARACTERS TO READ
            BNE DISHELP
            JMP GONE

; ============================================================
;  RETURN TO BASIC PROMPT (READY)
; ============================================================

END2      SEC
          LDA TXTPTR
          SBC #$01
          STA TXTPTR
          LDA TXTPTR+1
          SBC #$00
          STA TXTPTR+1
          JMP GONE

; ============================================================
;  TEXT DISPLAY
; ============================================================

TITLE     .BYTE $0D
          .TEXT "SCOTTBASIC WEDGE V1.0"    ; 20 CHARACTERS LONG
          .BYTE $0D

HELPTX    .BYTE $0D
          .TEXT "!TXT,(0-15)  CHANGES COLOUR OF TEXT"
          .BYTE $0D
          .TEXT "!BRD,(0-15)  CHANGES COLOUR OF BORDER"
          .BYTE $0D
          .TEXT "!SCR,(0-15)  CHANGES COLOUR OF SCREEN"
          .BYTE $0D
          .TEXT "!CLS         CLEARS SCREEN"
          .BYTE $0D
          .TEXT "!HELP        DISPLAYS COMMANDS"
