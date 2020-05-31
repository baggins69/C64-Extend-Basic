// ============================================================
//       SAMPLE WEDGE - ADDING FOUR NEW BASIC COMMANDS
// ============================================================
//                        VERSION 2
//            (c)2002, (c)2004 BY SCOTT JULIAN

// THIS SAMPLE SHOWS YOU HOW TO ADD FOUR NEW BASIC COMMANDS. THE
// COMMANDS ARE SIMPLE AND YOU SHOULD BE ABLE TO CREATE MORE
// COMMANDS OF YOUR OWN USING THIS FRAMEWORK.

// 	!CLS 			CLEAR SCREEN
//	!BRD 			CHANGE BORDER COLOUR
// 	!SCR 			CHANGE SCREEN COLOUR
// 	!TXT 			CHANGE TEXT COLOUR
//	!HELP			DISPLAY LIST OF COMMANDS

// ============================================================
//  STARTUP
// ============================================================

*=$C000 "Wedge"      // SYS49152

.label CHRGET=$0073
.label TXTPTR=$7A
.label IERROR=$0300
.label IMAIN=$0302
.label IGONE=$0308
.label GONE=$A7E4
.label CHKCOM=$AEFD
.label FRMNUM=$AD8A
.label GETADR=$B7F7
.label CHROUT=$FFD2
.label BORDER=$D020
.label SCREEN=$D021
.label TEXT=$0286

// ============================================================
// SETUP SCREEN DISPLAY
// ============================================================

            lda #4	// CHANGE BORDER COLOUR TO 
	    sta BORDER	// PURPLE
	    lda #147	// PRINT CHR$(147) TO CLEAR
	    jsr CHROUT	// SCREEN

            ldy #$00
DISPLAY:    lda TITLE,Y
       	    jsr CHROUT
            iny
            cpy #23	// NUMBER OF CHARACTERS TO READ
            bne DISPLAY


// ============================================================
//  CHANGE BASIC COMMAND POINTERS
// ============================================================

INIT:   
        ldx #<NEWBASIC
        ldy #>NEWBASIC
        stx IGONE
        sty IGONE+1
        rts

        ldx #$83
        ldy #$A4
        stx IMAIN	// ($0302)
        sty IMAIN+1   	// ($0303)


// ============================================================
//  CHECK FOR NEW COMMANDS, IS FIRST CHARACTER !
// ============================================================

NEWBASIC:    
        jsr CHRGET    	// GET CHARACTER
        cmp #'!'      	// IS IT A "!" ?
        beq CHK       	// YES, CONTINUE
        jmp GONE+3    	// NORMAL WORD


// ============================================================
//  CHECK WHICH NEW COMMAND HAS BEEN ISSUED
// ============================================================

CHK:        
        jsr CHRGET    	// GET NEXT CHARACTER
        cmp #'C'      	// IS IT A "C" ?
        beq CLS       	// YES, JUMP TO CLS
        cmp #'B'      	// IS IT A "B" ?
        beq BDR       	// YES, JUMP TO BRD
        cmp #'S'      	// IS IT A "S" ?
        beq SCR		// YES, JUMP SCR
        cmp #'T' 	// IS IT A "T" ?
        beq TEX
             		// YES, JUMP TEX
	cmp #'H'	// IS IT A "H" ?
	beq HELP	// YES, JUMP HELP
        jmp (IERROR)	// JUMP TO ERROR CHECK 


// ============================================================
//  NEW COMMAND TO CLEAR SCREEN
// ============================================================

CLS:        
        jsr CHRGET    	// GET THE L
        jsr CHRGET    	// GET THE S
        lda #$93      	// LOAD A WITH CHR$(147)
        jsr CHROUT    	// PRINT A
        jmp GONE


// ============================================================
//  NEW COMMAND TO CHANGE SCREEN COLOUR 
// ============================================================

SCR:	
        jsr CHRGET  	// GET THE C
        jsr CHRGET  	// GET THE R
        jsr CHRGET  	// GET THE ,
        jsr CHKCOM  	// SKIP THE COMMA
        jsr FRMNUM 	// EVALUATE NUMBER
        jsr GETADR  	// CONVERT TO A 2-BYTE INTEGER
                        // A HAS HI BYTE
                        // Y HAS LO BYTE
        sty SCREEN   	// PUT IN SCREEN COLOUR
        jmp END2


// ============================================================
//  NEW COMMAND TO CHANGE TEXT COLOUR 
// ============================================================

TEX:    
        jsr CHRGET       // GET THE X
        jsr CHRGET       // GET THE T
        jsr CHRGET       // GET THE ,
        jsr CHKCOM       // SKIP THE COMMA
        jsr FRMNUM       // EVALUATE NUMBER
        jsr GETADR       // CONVERT TO A 2-BYTE INTEGER
                         // A HAS HI BYTE
                         // Y HAS LO BYTE
        sty TEXT         // PUT IN BORDER COLOUR
        jmp END2


// ============================================================
//  NEW COMMAND TO CHANGE BORDER COLOUR 
// ============================================================

BDR:    
        jsr CHRGET       // GET THE D
        jsr CHRGET       // GET THE R
        jsr CHRGET       // GET THE ,
        jsr CHKCOM       // SKIP THE COMMA
        jsr FRMNUM       // EVALUATE NUMBER
        jsr GETADR       // CONVERT TO A 2-BYTE INTEGER
                         // A HAS HI BYTE
                         // Y HAS LO BYTE
        sty BORDER       // PUT IN BORDER COLOUR
        jmp END2


// ============================================================
//  HELP, DISPLAY ALL COMMANDS AND SYNTX 
// ============================================================

HELP:	
        jsr CHRGET      // GET THE E
	jsr CHRGET      // GET THE L
	jsr CHRGET      // GET THE P

        ldy #$00
DISHELP:
        lda HELPTX,Y
       	jsr CHROUT
        iny
        cpy #170	// NUMBER OF CHARARTERS TO READ
        bne DISHELP
        jmp GONE


// ============================================================
//  RETURN TO BASIC PROMPT (READY) 
// ============================================================

END2:   sec
        lda TXTPTR
        sbc #$01
        sta TXTPTR
        lda TXTPTR+1
        sbc #$00
        sta TXTPTR+1
        jmp GONE

// ============================================================
//  TEXT DISPLAY 
// ============================================================

TITLE:  
        .byte $0d 
	.text "ALPHAWORKS BASIC V2.0"	// 20 CHARACTERS LONG
	.byte $0d 

HELPTX:	   
        .byte $0d
        .text "!TXT,(0-15)  CHANGES COLOUR OF TEXT"
	.byte $0d
	.text "!BRD,(0-15)  CHANGES COLOUR OF BORDER"
	.byte $0d
	.text "!SCR,(0-15)  CHANGES COLOUR OF SCREEN"
	.byte $0d
	.text "!CLS         CLEARS SCREEN"
	.byte $0d
	.text "!HELP        DISPLAYS COMMANDS"