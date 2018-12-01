bonus_timer:  .byte 0,0,0
bonus_active: .byte 0,0,0
bonus_time_doubler .byte 0

bonus_init:
    lda #0
    ldx #0
    sta bonus_timer,x
    sta bonus_active,x
    sta bonus_time_doubler
    ldx #1
    sta bonus_timer,x
    sta bonus_active,x
    
    rts


;-------------------Timeout a Bonus--------------------
bonus_update:
    lda bonus_time_doubler          ;Make the counter last for 10s by only exec every 2:nd frame
    beq bonus_update_end
    dec bonus_time_doubler
    jsr bonus_print
    ldx ball_player_1
    lda bonus_timer,x
    beq bonus_update_p2
    dec bonus_timer,x
    beq bonus_update_pl_end
    rts
bonus_update_pl_end:
    jsr bonus_deactivate
    lda #0
    sta bonus_active,x
    rts

bonus_update_p2:
    ldx ball_player_2
    lda bonus_timer,x
    beq bonus_update_end       
    dec bonus_timer,x
    beq bonus_update_p2_end
    rts
bonus_update_p2_end:
    jsr bonus_deactivate
    lda #0
    sta bonus_active,x
    rts

bonus_update_end:
    lda #1
    sta bonus_time_doubler
    rts




;-----------------Activate Bonus--------------------
bonus_activate:
    sta bonus_active,x
    cmp #$80
    beq bonus_op_smaller
    cmp #$81
    beq bonus_op_smaller
    cmp #$82
    beq bonus_op_larger
    cmp #$83
    beq bonus_op_larger
    rts

bonus_op_smaller:
    lda #255
    sta bonus_timer,x
    jsr bat_bonus_smaller
    rts
bonus_op_larger:
    lda #255
    sta bonus_timer,x
    jsr bat_bonus_larger
    rts



;-----------------DeActivate Bonus--------------------
bonus_deactivate:
    lda bonus_active,x
    cmp #$80
    beq bonus_smaller_end
    cmp #$81
    beq bonus_smaller_end
    cmp #$82
    beq bonus_larger_end
    cmp #$83
    beq bonus_larger_end
    rts

bonus_smaller_end:
    jsr bat_bonus_smaller_end
    rts
bonus_larger_end:
    jsr bat_bonus_larger_end    
    rts
;--------------Draw timer text-----------------------
bonus_print:
    ldx ball_player_1
    jsr bonus_print_eval
    sta $40f
    ldx ball_player_2
    jsr bonus_print_eval
    sta $417
    rts

bonus_print_eval:
    lda bonus_timer,x
    cmp #200
    bcs bonus_print_5    ;if time larger than 200
    cmp #150
    bcs bonus_print_4
    cmp #100
    bcs bonus_print_3
    cmp #50
    bcs bonus_print_2
    cmp #1
    bcs bonus_print_1
    lda #32
    rts

bonus_print_5:
    lda #53
    rts
bonus_print_4:
    lda #52
    rts
bonus_print_3:
    lda #51
    rts
bonus_print_2:
    lda #50
    rts
bonus_print_1:
    lda #49
    rts



