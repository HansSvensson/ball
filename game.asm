
game_mode        .byte 0
game_running     .byte 0   ;0=keep running the game    1=quit game
game_init_state: .byte 0
game_init:

    jsr gameBg_init
    jsr ball_init
    jsr bat_init
    jsr score_init

    lda #0
    sta game_running
    jsr game_setIsr
    
    lda #190
    sta game_init_state

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


game_isr:
   inc $d020
   jsr game_isr_prepare
   bne game_isr_ret
   jmp game_isr_game
game_isr_ret:
    jmp gameContiniue



;-------------------print the ready steady go messages-----------------
game_isr_prepare:
   lda game_init_state
   beq game_isr_prepare_cont
   dec game_init_state

   lda game_init_state
   cmp #180
   beq game_isr_ready 
   cmp #120
   beq game_isr_steady 
   cmp #60
   beq game_isr_go
   cmp #0
   beq game_init_score
   lda #1
   rts

game_isr_ready:
   jsr score_print_ready
   lda #1
   rts
game_isr_steady:
   jsr score_print_steady
   lda #1
   rts
game_isr_go:
   jsr score_print_go
   lda #1
   rts
game_init_score:
   jsr score_clean
   jsr gameBg_printScore
   lda #0
   
game_isr_prepare_cont:
   rts    



game_isr_game:
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
