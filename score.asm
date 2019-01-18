
;we use straight screen codes so it is easy to print 0=48 9=57
;player 1 = index 0,1,2    player 2 = index 3,4,5
score_player: .byte 48,48,48,48,48,48
score_wins_player: .byte 48,48,48,48
score_x_temp: .byte 0



;---------------------Increase score-------------------
score_increase_player_1:
    stx score_x_temp
    ldx #0
    jsr score_increase
    ldx score_x_temp
    rts
score_increase_player_2:
    stx score_x_temp
    ldx #3
    jsr score_increase
    ldx score_x_temp
    rts

score_increase:
    lda score_player,x
    cmp #57
    beq score_increase_ten
    inc score_player,x
    jmp score_increase_end
score_increase_ten:
    lda #48
    sta score_player,x
    lda score_player+1,x
    cmp #57
    beq score_increase_hundred 
    inc score_player+1,x
    jmp score_increase_end
score_increase_hundred:
    lda #48
    sta score_player+1,x
    inc score_player+2,x

score_increase_end:
    rts


;----------------------Increase wins-------------------
score_increase_wins_player_1:
    ldx #0
    jsr score_wins_increase
    rts
score_increase_wins_player_2:
    ldx #2
    jsr score_wins_increase
    rts

score_wins_increase:
    lda score_wins_player,x
    cmp #57
    beq score_wins_increase_ten
    inc score_wins_player,x
    jmp score_wins_increase_end
score_wins_increase_ten:
    lda #48
    sta score_wins_player,x
    inc score_wins_player+1,x

score_wins_increase_end:
    rts






score_init:
    ldx #0
    lda #48
score_reset_loop:
    sta score_player,x
    inx
    cpx #6
    bne score_reset_loop
    lda #50
    sta score_timeFCount
    lda #0
    sta score_timeEndGame
    rts


;     YES                             NO
;             p1_100 < p2_100
;    P2_WON                    p1_100 == p2_100
;                         p1_10 < p2_10        P1_WON
;                       P2_WON      p1_10 
;
;


score_lead:
    lda score_player+2
    cmp score_player+5
    bcc score_lead_p2Won  ; p1 < p2
    beq score_lead_10     ; p2 == p1
    jmp score_lead_p1Won  ; p1 >  p2
score_lead_10:
    lda score_player+1
    cmp score_player+4
    bcc score_lead_p2Won  ; p1 < p2
    beq score_lead_1      ; p2 == p1
    jmp score_lead_p1Won  ; p1 >  p2
score_lead_1:
    lda score_player
    cmp score_player+3
    bcc score_lead_p2Won  ; p1 < p2
    beq score_lead_equal  ; p2 == p1
    jmp score_lead_p1Won  ; p1 >  p2
score_lead_p1Won:
    jsr score_increase_wins_player_1
    lda #49
    rts
score_lead_p2Won:
    jsr score_increase_wins_player_2
    lda #50
    rts
score_lead_equal:
    lda #0
    rts


score_print:
    lda score_player+2
    sta $406
    lda score_player+1
    sta $407
    lda score_player
    sta $408
    
    lda score_wins_player+1
    sta $40c
    lda score_wins_player
    sta $40d

    lda score_wins_player+3
    sta $41c
    lda score_wins_player+2
    sta $41d

    lda score_player+5
    sta $425
    lda score_player+4
    sta $426
    lda score_player+3
    sta $427
   
    lda score_time
    sta $415
    lda score_time+1
    sta $416
    lda score_time+2
    sta $417
    rts

score_timeEndGame     .byte 0        ; 0 = time has ended    1 = time is set
score_timeFCount      .byte 50
score_time            .byte 48,48, 48

score_timeSet:
    bne score_timeSetLow
    lda #49
    sta score_time
    lda #50
    sta score_time+1
    lda #48
    sta score_time+2
    lda #0
    sta score_timeEndGame
    rts
score_timeSetLow:
    clc
    adc #48
    sta score_time+1
    lda #48
    sta score_time
    sta score_time+2
    lda #50
    sta score_timeFCount
    lda #0
    sta score_timeEndGame
    rts

score_timeDec:
    clc
    lda score_time
    adc score_time+1
    adc score_time+2
    cmp #144   ;48*3
    beq score_timeEndGameSet
    
    lda score_timeFCount
    beq score_timeFCountZero
    dec score_timeFCount
    rts
score_timeFCountZero
    lda #50
    sta score_timeFCount
    lda score_time+2
    cmp #48
    beq score_timeTenth
    dec score_time+2
    rts
score_timeTenth:
    lda #57
    sta score_time+2    
    lda score_time+1
    cmp #48
    beq score_timeHundred
    dec score_time+1
    rts
score_timeHundred:
    lda score_time
    cmp #48
    beq score_timeEndGameSet
    lda #57
    sta score_time+1    
    sta score_time+2    
    dec score_time
    rts

score_timeEndGameSet:
    lda #1
    sta score_timeEndGame
    rts


score_lastTenSec:
    lda score_time+1
    cmp #48
    rts



;-------------------------Code for printing ready,steady,go---------------------------
score_clean:
    ldx #0
    ldy #0
score_clean_loop:
    lda #35
    sta $400,x
    lda #0
    sta $d800,x
    inx
    cpx #40
    bne score_clean_loop
    rts

score_text_ready .enc screen
                 .text "ready"
score_print_ready:
    jsr score_clean
    ldx #0
score_print_ready_loop:
    lda score_text_ready,x
    sta $412,x
    lda #2
    sta $d812,x
    inx
    cpx #5
    bne score_print_ready_loop
    rts   
    
score_text_steady .enc screen
                 .text "steady"
score_print_steady:
    jsr score_clean
    ldx #0
score_print_steady_loop:
    lda score_text_steady,x
    sta $411,x
    lda #7
    sta $d811,x
    inx
    cpx #6
    bne score_print_steady_loop
    rts         

score_text_go .enc screen
              .text "go"
score_print_go:
    jsr score_clean
    ldx #0
score_print_go_loop:
    lda score_text_go,x
    sta $413,x
    lda #5
    sta $d813,x
    inx
    cpx #2
    bne score_print_go_loop
    rts         
    
