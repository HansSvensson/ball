
game_mode     .byte 0
game_running  .byte 0   ;0=keep running the game    1=quit game

game_init:

    jsr gameBg_init
    jsr ball_init
    jsr bat_init
    jsr score_init

    lda #0
    sta game_running
    jsr game_setIsr

    lda #$01   ;this is how to tell the VICII to generate a raster interrupt
    sta $d01a

    cli
    rts

game_setIsr:
    lda #<game_isr   ;Set raster interrupt position
    sta $fffe
    lda #>game_isr
    sta $ffff
    lda #180     ;this is how to tell the VICII to generate a raster interrupt
    sta $d012
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
   jsr score_timeDec
   jsr score_print 
   ;Check if game ended---
   jsr gameEnded
   beq gameContiniue 
   jsr game_deinit
    
gameContiniue:
   jsr score_setIsr
   dec $d020
   asl $d019
   rti


;------------------Check if game finished 0=run game, 1=Quit game----------
gameEnded:
    lda game_mode         ;game mode = 0 All bricks must be destroyes, otherwise time is used.
    bne gameEndedTime
    jsr gameBg_empty      ;Returns 0 if game should cont.
    sta game_running
    rts
gameEndedTime:
    lda score_timeEndGame ;loads zero if game should cont.
    sta game_running
    rts
