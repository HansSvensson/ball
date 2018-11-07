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

            lda #0
            sta $d021
            lda #0
            sta $d020

;interrupt init
           sei          ; turn off interrupts
           lda #$7f
           sta $dc0d    ; Turn off CIA 1 interrupts
           sta $dd0d    ; Turn off CIA 2 interrupts
           lda $dc0d    ; clear...
           lda $dd0d    ; clear...

            lda #$1b   ;as there are more than 256 rasterlines, the topmost bit of $d011 serves as
            sta $d011  ;the 9th bit for the rasterline we want our irq to be triggered.
                       ;here we simply set up a character screen, leaving the topmost bit 0.

           lda #$35
           sta $01      ; enable ram

           ldx #0

           ;cli
 
           ;jsr intro

loop:
           jsr menu
           jsr game_init
loopGameRunning:           
           lda game_running
           beq loopGameRunning    ;If zero keep on playing the game
           
           jsr gameOver
           jmp loop


.include "game.asm"
.include "bat.asm"
.include "ball.asm"
.include "score.asm"
.include "gameBg.asm"
.include "gameOver.asm"
.include "menu.asm"
