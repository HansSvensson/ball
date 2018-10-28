
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
    jsr score_print 
    rts



score_reset:
    ldx #0
    lda #48
score_reset_loop:
    sta score_player,x
    inx
    cpx #6
    bne score_reset_loop
        
    rts



score_print:
    lda score_player+2
    sta $406
    lda score_player+1
    sta $407
    lda score_player
    sta $408
    
    lda score_player+5
    sta $423
    lda score_player+4
    sta $424
    lda score_player+3
    sta $425
   
    rts
