
game_mode        .byte 0
game_running     .byte 0   ;0=keep running the game    1=quit game
game_init_state: .byte 0
game_speedCnt    .byte 0

game_init:

    jsr gameBg_init
    jsr ball_init
    jsr bat_init
    jsr score_init
    jsr bullet_init
    lda #24
    sta game_anim_delay
    jsr game_anim
    jsr sound_init_game

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
   jmp game_rest_every
   ;Update the rest-------
game_rest:
   jsr bullet_add_pl1
   jsr bullet_add_pl2
   jsr bullet_update_pl1
   jsr bullet_update_pl2
game_rest_every:
   jsr bonus_update
   jsr gameBgEl
   jsr score_timeDec
   jsr score_print    
   jsr game_anim
   ;Check if game ended---
game_isrAfterUpdate:   
   jsr gameEnded
   beq gameContiniue 
   jsr game_deinit
    
gameContiniue:
   ;dec $d020
   jsr sound_setIsr
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


;------------------------------Animate background-----------------------
game_anim_delay .byte 0
game_anim_cnt: .byte 0
game_anim:
    inc game_anim_delay
    lda game_anim_delay
    cmp #25
    bne game_anim_ret
    lda #0
    sta game_anim_delay
    inc game_anim_cnt
    lda game_anim_cnt
    cmp #5
    bne game_anim_update
    lda #1
    sta game_anim_cnt
game_anim_update:
    clc
    rol a     ; 1 -> 2   3 -> 6
    rol a     ; 2 -> 4   6 -> 12
    rol a     ; 4 -> 8  12 -> 24
    tax
    lda $3120,x    ;120 = 288 = 8*36   
    sta $3100
    lda $3121,x
    sta $3101
    lda $3122,x
    sta $3102
    lda $3123,x
    sta $3103
    lda $3124,x
    sta $3104
    lda $3125,x
    sta $3105
    lda $3126,x
    sta $3106
    lda $3127,x
    sta $3107

    ;bonus animation
    clc
    txa
    rol a
    tax
    lda $3460,x  ;8*141 = 1128 = 0x468
    sta $3400+0
    sta $3400+16
    sta $3400+32
    sta $3400+48
    sta $3400+64

    lda $3461,x
    sta $3401+0
    sta $3401+16
    sta $3401+32
    sta $3401+48
    sta $3401+64

    lda $3462,x
    sta $3402+0
    sta $3402+16
    sta $3402+32
    sta $3402+48
    sta $3402+64

    lda $3463,x
    sta $3403+0
    sta $3403+16
    sta $3403+32
    sta $3403+48
    sta $3403+64

    lda $3464,x
    sta $3404+0
    sta $3404+16
    sta $3404+32
    sta $3404+48
    sta $3404+64

    lda $3465,x
    sta $3405+0
    sta $3405+16
    sta $3405+32
    sta $3405+48
    sta $3405+64

    lda $3466,x
    sta $3406+0
    sta $3406+16
    sta $3406+32
    sta $3406+48
    sta $3406+64

    lda $3467,x
    sta $3407+0
    sta $3407+16
    sta $3407+32
    sta $3407+48
    sta $3407+64

    ;second char
    lda $3468,x  ;8*141 = 1128 = 0x468
    sta $3408+0
    sta $3408+16
    sta $3408+32
    sta $3408+48
    sta $3400+64

    lda $3469,x
    sta $3409+0  
    sta $3409+16
    sta $3409+32
    sta $3409+48
    sta $3409+64

    lda $346a,x
    sta $340a+0  
    sta $340a+16
    sta $340a+32
    sta $340a+48
    sta $340a+64

    lda $346b,x
    sta $340b+0
    sta $340b+16
    sta $340b+32
    sta $340b+48
    sta $340b+64

    lda $346c,x
    sta $340c+0
    sta $340c+16
    sta $340c+32
    sta $340c+48
    sta $340c+64

    lda $346d,x
    sta $340d+0
    sta $340d+16
    sta $340d+32
    sta $340d+48
    sta $340d+64

    lda $346e,x
    sta $340e+0
    sta $340e+16
    sta $340e+32
    sta $340e+48
    sta $340e+64

    lda $346f,x
    sta $340f+0
    sta $340f+16
    sta $340f+32
    sta $340f+48
    sta $340f+64


game_anim_ret:    
    rts


;-------------------Check if we should redraw----------------
game_levelChange_sec .byte 0
game_levelChange_frm .byte 0
game_levelChange_cnt .byte 0
game_levelChagne_lim = #30

game_levelChange:
    jsr score_lastTenSec
    beq game_levelChangeEnd        ;then the game is ending we dont chagne background!
    dec game_levelChange_frm       ;run frame counter to get seconds
    lda game_levelChange_frm
    bne game_levelChangeEnd
    lda #51
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
