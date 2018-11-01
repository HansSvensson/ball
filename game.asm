
game_mode     .byte 0
game_running  .byte 0

game_init:
    lda #0
    sta game_mode
    lda #<game_isr   ;Set raster interrupt position
    sta $fffe
    lda #>game_isr
    sta $ffff

    jsr gameBg_init
    jsr ball_init
    jsr bat_init
    jsr score_init

    lda #0
    sta game_running
    lda #1     ;this is how to tell the VICII to generate a raster interrupt
    sta $d012
    
    lda #$01   ;this is how to tell the VICII to generate a raster interrupt
    sta $d01a

    cli
    rts

game_deinit:
    lda #$00   
    sta $d01a
    rts


game_isr
   inc $d020
   lda $d01f
   sta ball_temp_d01f
   lda $d01e
   sta ball_temp_d01e
   ;Round 1-----------------
   jsr bat_update
   ldx #2
   jsr ball_update
   ldx #0
   jsr ball_update
   ldx #4
   jsr ball_update
   ldx #6
   jsr ball_update
   ldx #8
   jsr ball_update
   ldx #10
   jsr ball_update
   ;Round 2---------------
   jsr bat_update
   ldx #2
   jsr ball_update
   ldx #0
   jsr ball_update
   ldx #4
   jsr ball_update
   ldx #6
   jsr ball_update
   ldx #8
   jsr ball_update
   ldx #10
   jsr ball_update
   ;Update the rest-------
   jsr gameBgEl
   ;Check if game ended---
   jsr gameEnded
   beq gameContiniue 
   jsr game_deinit
    
gameContiniue:
   dec $d020
   asl $d019
   rti


;------------------Check if game finished 0=run game, 1=Quit game----------
gameEnded:
    lda game_mode
    bne gameEndedQuit
    jsr gameBg_empty      ;game mode 0 = all bricks must be destroyed
    sta game_running
gameEndedQuit:
    rts
