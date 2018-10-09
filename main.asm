*=$0801

;** 12 bytes autload: 0 SYS2086 **
.byte $0c,$08,$00,$00,$9e,$32,$30,$38,$33,$00,$00,$00,$00

;** Hello world in DOS/COM **
.byte $ba,$17,$01,$b4,$09,$cd,$21,$c3,$48,$45,$4c,$4c,$4f,$20,$57,$4f,$52,$4c,$44,$21,$24



            lda #32
            ldx #$0
clearing:
            sta $400,x
            sta $500,x
            sta $600,x
            sta $700,x
            inx
            bne clearing

;-------------------------------
            lda #102
            ldx #30
bg_tst:
            sta $607,x
            sta $da20,x
            dex
            bne bg_tst

            ldx #40
bg_tst2:
            sta $3ff,x
            sta $da20,x
            dex
            bne bg_tst2
 
            sta $410,x
            sta $438,x
            sta $460,x
            sta $488,x
            sta $4b0,x
            sta $4d8,x
            sta $500,x
            sta $41e,x
            sta $446,x
            sta $46e,x
            sta $496,x
            sta $4be,x

 
;----------------------------------


            lda #0
            sta $d021
            lda #1
            sta $d020

;interrupt init
           sei          ; turn off interrupts
           lda #$7f
           sta $dc0d    ; Turn off CIA 1 interrupts
           sta $dd0d    ; Turn off CIA 2 interrupts
           lda $dc0d    ; clear...
           lda $dd0d    ; clear...

            lda #$01   ;this is how to tell the VICII to generate a raster interrupt
            sta $d01a

            lda #$1b   ;as there are more than 256 rasterlines, the topmost bit of $d011 serves as
            sta $d011  ;the 9th bit for the rasterline we want our irq to be triggered.
                       ;here we simply set up a character screen, leaving the topmost bit 0.

           lda #$35
           sta $01      ; enable ram

           jsr ball_init
           ldx #0

           cli
 
loop:
           jmp loop


.include "ball.asm"
