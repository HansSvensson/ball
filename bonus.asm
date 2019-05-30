bonus_timer:  .byte 0,0,0
bonus_active: .byte 0,0,0
bonus_time_doubler .byte 0
bonus_flash_cnt    .byte 0

bonus_init:
    lda #0
    ldx #0
    sta bonus_timer,x
    sta bonus_active,x
    sta bonus_time_doubler
    sta bonus_flash_cnt
    ldx #1
    sta bonus_timer,x
    sta bonus_active,x
    lda #1
    sta bonus_insert_frameCnt
    sta bonus_insert_secCnt
    
    rts


;-------------------Timeout a Bonus--------------------
bonus_update:
    jsr bonus_flash_update
    lda bonus_time_doubler          ;Make the counter last for 10s by only exec every 2:nd frame
    beq bonus_update_end
    dec bonus_time_doubler
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


;-----------------Insert bonuses each 30 sec-----------------
bonus_insert_frameCnt: .byte 1
bonus_insert_secCnt:   .byte 1
bonus_insert_pos       .byte 0,0,0,0
bonus_insertlist       .byte 20,16,17,18,19
bonus_insertlist_len   = #5
bonus_insertlist_cnt   .byte 0
bonus_insert_current   .byte 0
bonus_insert:
    dec bonus_insert_frameCnt
    bne bonus_insert_quit
    lda #49
    sta bonus_insert_frameCnt
    dec bonus_insert_secCnt
    bne bonus_insert_quit
    lda #29
    sta bonus_insert_secCnt

    jsr bonus_insert_getBonus
    lda bonus_insert_pos          ;Insret new bonus
    sta 2
    lda bonus_insert_pos+1
    sta 3
    lda bonus_insert_current
    jsr gameBg_colorConvert
    jsr gameBg_charConvert
    lda gameBg_char
    ldy #0
    sta (2),y
    lda bonus_insert_pos+1
    clc
    adc #$d4
    sta 3
    lda gameBg_color
    sta (2),y

    lda bonus_insert_pos+2          ;Insret new bonus
    sta 2
    lda bonus_insert_pos+3
    sta 3
    lda bonus_insert_current
    jsr gameBg_colorConvert
    jsr gameBg_charConvert
    lda gameBg_char
    sta (2),y
    lda bonus_insert_pos+3
    clc
    adc #$d4
    sta 3
    lda gameBg_color
    sta (2),y

bonus_insert_quit:
    rts    

bonus_insert_getBonus:
    lda bonus_insertlist_cnt
    cmp bonus_insertlist_len
    bne bonus_insert_getBonus_end
    lda #0
    sta bonus_insertlist_cnt
bonus_insert_getBonus_end:
    tay
    inc bonus_insertlist_cnt
    lda bonus_insertlist,y
    sta bonus_insert_current
    rts

;-----------------Activate Bonus, x-hold owner--------------------
bonus_activate:
    pha
    lda bonus_active,x
    bne bonus_activate_end
    pla    
    sta bonus_active,x
    cmp #$80                  ;Make smaller
    beq bonus_op_smaller
    cmp #$81
    beq bonus_op_smaller
    cmp #$82                  ;Make larger
    beq bonus_op_larger
    cmp #$83
    beq bonus_op_larger
    cmp #$84                  ;Own all
    beq bonus_op_ownAll
    cmp #$85
    beq bonus_op_ownAll
    cmp #$86                  ;Send bullets
    beq bonus_bullet
    cmp #$87
    beq bonus_bullet
    cmp #$88                  ;Unstopable
    beq bonus_unStopable
    cmp #$89
    beq bonus_unStopable

bonus_activate_end:
    pla    
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
bonus_bullet:
    lda #255
    sta bonus_timer,x
    jsr bullet_activate
    rts
bonus_unStopable:
    lda #255
    sta bonus_timer,x
    jsr ball_unStopableActivate
    rts

bonus_op_ownAll:
    lda #0
    sta bonus_active,x
    jsr ball_changeOwnerAll
    lda #5
    sta bonus_flash_cnt
    rts


;-----------------DeActivate Bonus--------------------
bonus_deactivate:
    lda bonus_active,x
    cmp #$80                   ;Make smaller
    beq bonus_smaller_end
    cmp #$81
    beq bonus_smaller_end
    cmp #$82                   ;Make Larger
    beq bonus_larger_end
    cmp #$83
    beq bonus_larger_end
    cmp #$86                   ;Send Bullets
    beq bonus_bullet_end
    cmp #$87
    beq bonus_bullet_end
    cmp #$88                   ;Unstopable
    beq bonus_unStopable_end
    cmp #$89
    beq bonus_unStopable_end
    rts

bonus_smaller_end:
    jsr bat_bonus_smaller_end
    rts
bonus_larger_end:
    jsr bat_bonus_larger_end    
    rts
bonus_bullet_end:
    jsr bullet_deactivate
    rts
bonus_unStopable_end:
    jsr ball_unStopableDeactivate
    rts

;--------------Draw timer text-----------------------
bonus_print:
    ldx ball_player_1
    jsr bonus_print_eval
    sta $411
    ldx ball_player_2
    jsr bonus_print_eval
    sta $427
    lda #2
    sta $d811
    sta $d827
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
    lda #35
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

;----------A little flash effect-------------
bonus_flash_update:
    lda bonus_flash_cnt
    beq bonus_flash_update_end
    cmp #1
    beq bonus_flash_update_off

    lda #1
    jmp bonus_flash_update_c

bonus_flash_update_off:
    lda #0

bonus_flash_update_c:        
    dec bonus_flash_cnt
    sta $d020
    sta $d021
bonus_flash_update_end:
    rts    

