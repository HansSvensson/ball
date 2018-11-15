
;we use straight screen codes so it is easy to print 0=48 9=57
;player 1 = index 0,1,2    player 2 = index 3,4,5
score_player: .byte 48,48,48,48,48,48

score_x_temp: .byte 0


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

score_setIsr:
    lda #<Score_isr   ;Set raster interrupt position
    sta $fffe
    lda #>Score_isr
    sta $ffff
    lda #50     ;this is how to tell the VICII to generate a raster interrupt
    sta $d012
    rts


Score_isr:
    ;change to single color
    lda $d018          ;set location of charset
    and #$f1
    ora #$5
    sta $d018
    lda $d016           ;Select singlecolor
    and #%11101111
    sta $d016



    ;print text
    lda #<Score_isrEnd   ;Set raster interrupt position
    sta $fffe
    lda #>Score_isrEnd
    sta $ffff
    lda #55     ;this is how to tell the VICII to generate a raster interrupt
    sta $d012
    asl $d019

    rti


    

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
    lda #49
    rts
score_lead_p2Won:
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
    rts

score_timeEndGame     .byte 0        ; 0 = time has ended    1 = time is set
score_timeFCount      .byte 50
score_time            .byte 48,48

score_timeSet:
    clc
    adc #48
    sta score_time
    lda #48
    sta score_time+1
    sta score_timeEndGame
    lda #50
    sta score_timeFCount


score_timeDec:
    lda game_mode
    bne score_timeDecMode
    rts

score_timeDecMode
    lda score_timeFCount
    beq score_timeFCountZero
    dec score_timeFCount
    rts
score_timeFCountZero
    lda #50
    sta score_timeFCount
    lda score_time+1
    cmp #48
    beq score_timeTenth
    dec score_time+1
    rts
score_timeTenth:
    lda score_time
    cmp #48
    beq score_timeEndGameSet
    dec score_time
    lda #57
    sta score_time+1
    rts
score_timeEndGameSet:
    lda #1
    sta score_timeEndGame
    rts





Score_isrEnd:
    ;sta $400
    ;stx $401
    ;stx $402
    lda #$1B
    sta $d011
    lda #$C8
    sta $d016
    lda #$15
    sta $d018

    lda #<Score_IsrEndStable   ; low part of address of interrupt handler code
    ldx #>Score_IsrEndStable   ; high part of address of interrupt handler code
    sta $fffe                  ; store in interrupt vector
    stx $ffff
    lda #56
    sta $d012
    asl $d019                  ; ACK interrupt (to re-enable it)
    tsx                        ; store stack
    cli                        
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop



Score_IsrEndStable:
    txs
    ldx #$08
    dex
    bne *-1
    bit $00

    lda $d012
    cmp $d012
    beq *+2


;stable
    jsr game_setIsr
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    jsr gameBg_setMulticolor
    asl $d019
    rti
    
