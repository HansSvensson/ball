
game_mode        .byte 0
game_running     .byte 0   ;0=keep running the game    1=quit game
game_init_state: .byte 0
game_speedCnt    .byte 0

game_init:

    jsr gameBg_init
    jsr ball_init
    jsr bat_init
    jsr score_init

    lda #0
    sta game_running
    jsr game_setIsr
   
    lda #2
    sta game_speedCnt
    
    lda #190
    sta game_init_state

    lda #50
    sta game_levelChange_frm
    lda game_levelChagne_lim
    sta game_levelChange_sec
    lda #0
    sta game_levelChange_cnt

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
   ;inc $d020
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

   jsr game_levelChange         ;check if bg should be updated, if jump over other updates
   bne game_isrAfterUpdate
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
   lda $d01f
   sta ball_temp_d01f   ;Every one has moved once, dont remember the old moves!

   ;Round 2---------------
   dec game_speedCnt
   bne game_rest
   lda #2
   sta game_speedCnt
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
game_rest:
   jsr bonus_update
   jsr gameBgEl
   jsr score_timeDec
   jsr score_print    
   ;Check if game ended---
game_isrAfterUpdate:   
   jsr gameEnded
   beq gameContiniue 
   jsr game_deinit
    
gameContiniue:
   jsr score_setIsr
   ;dec $d020
   asl $d019
   rti


;------------------Check if game finished 0=run game, 1=Quit game----------
gameEnded:
   ; lda game_mode         ;game mode = 0 All bricks must be destroyes, otherwise time is used.
   ; bne gameEndedTime
   ; jsr gameBg_empty      ;Returns 0 if game should cont.
   ; sta game_running
   ; rts
;gameEndedTime:
    lda score_timeEndGame ;loads zero if game should cont.
    sta game_running
    rts



;-------------------Check if we should redraw----------------
game_levelChange_sec .byte 0
game_levelChange_frm .byte 0
game_levelChange_cnt .byte 0
game_levelChagne_lim = #20

game_levelChange:
    dec game_levelChange_frm       ;run frame counter to get seconds
    lda game_levelChange_frm
    bne game_levelChangeEnd
    lda #50
    sta game_levelChange_frm
    dec game_levelChange_sec       ;One second has elapsed
    lda game_levelChange_sec
    bne game_levelChangeEnd
    lda game_levelChagne_lim
    sta game_levelChange_sec       ;20sec has elapsed change level
    
    inc game_levelChange_cnt       ;Put the level to change to in the ACC
    lda game_levelChange_cnt
    cmp #3
    bne game_levelChangeDo
    lda #0
    sta game_levelChange_cnt
game_levelChangeDo:
    jsr gamebg_change
    jsr ball_resetCord
    lda #1
    rts

game_levelChangeEnd:
    jsr game_levelChangeBg
    lda #0
    rts


;------------------------This function changes bg color to alert players--------------------------
game_levelChangeBg:
    lda game_levelChange_sec
    cmp #1
    bne game_levelChangeBgEnd    
    lda game_levelChange_frm
    cmp #25
    beq game_levelChangeBgDarkGrey
    cmp #10
    beq game_levelChangeBgMMidGrey
    cmp #1
    beq game_levelChangeBgReset
    rts

game_levelChangeBgReset
    lda #0
    jmp game_levelChangeCommon
game_levelChangeBgDarkGrey:
    lda #11
    jmp game_levelChangeCommon
game_levelChangeBgMMidGrey:
    lda #12
    jmp game_levelChangeCommon
game_levelChangeBgMLightGrey:
    lda #15
    jmp game_levelChangeCommon

game_levelChangeCommon:
    sta $d020
    sta $d021
game_levelChangeBgEnd: 
    rts
