bullet_active:  .byte 0,0
bullet_pos_hi:  .byte 0,0
bullet_pos_lo:  .byte 0,0
bullet_cnt      .byte 0,0
 
bullet_init:
    lda #0
    sta bullet_active
    sta bullet_active+1
    sta bullet_pos_hi
    sta bullet_pos_hi+1
    sta bullet_pos_lo
    sta bullet_pos_lo+1
    sta bullet_cnt
    sta bullet_cnt+1
    rts

bullet_bonusActive: .byte 0,0,0

bullet_activate:
    lda #1
    sta bullet_bonusActive,x
    rts

bullet_deactivate:
    lda #0
    sta bullet_bonusActive,x
    rts

;player must be in X-register
bullet_add_pl1:
    lda bullet_bonusActive+1
    beq bullet_add_end
    lda $dc01
    and #4               ;left
    bne bullet_add_end
    lda bullet_active    ;Check if bullet already active
    bne bullet_add_end
    inc bullet_active

    tya
    pha            ;store x on stack
    txa
    pha            ;store x on stack
    lda $d00d      ;bat 1 y-cord
    clc
    adc #$d8       ;offset becasue sprite starts no at 0.
    clc
    shr a
    shr a
    shr a          ; divide by 8 to get the row
    tay            ; we
    lda ball_hit_cord_Hi,y
;    sta 3
    sta bullet_pos_hi
    lda ball_hit_cord_Lo,y
;    sta 2
    clc
    adc #3
    sta bullet_pos_lo
;    lda #70
;    ldy #2
;    sta (2),y
    lda #37
    sta bullet_cnt
    pla
    tax
    pla
    tay 
    rts

bullet_add_pl2:
    lda bullet_bonusActive+2
    beq bullet_add_end
    lda $dc00
    and #4               ;left
    bne bullet_add_end
    lda bullet_active+1    ;Check if bullet already active
    bne bullet_add_end
    inc bullet_active+1

    tya
    pha            ;store x on stack
    txa
    pha            ;store x on stack
    lda $d00f      ;bat 1 y-cord
    clc
    adc #$d8       ;offset becasue sprite starts no at 0.
    clc
    shr a
    shr a
    shr a          ; divide by 8 to get the row
    tay            ; we
    lda ball_hit_cord_Lo,y
    clc
    adc #38       ; offset for bullet 
    sta bullet_pos_lo+1
    lda ball_hit_cord_Hi,y
    adc #0
    sta bullet_pos_hi+1
    lda #39
    sta bullet_cnt+1
    pla
    tax
    pla
    tay 
    rts


   ; jsr bat_bulletNewPos   ;get the position in y cord

bullet_add_end:
    rts

bullet_update_pl1:
    lda bullet_active
    bne bullet_update_do_pl1
    rts


bullet_update_do_pl1:
    tya
    pha
    dec bullet_cnt
    beq bullet_update_pl1_end
    ldy #0
    lda bullet_pos_hi            ;Clear old character
    sta 3
    lda bullet_pos_lo
    sta 2
    lda #32
    sta (2),y 
    clc
    lda 3                        ;add background color
    adc #$d4
    sta 3
    lda #6
    sta (2),y   
    
    lda bullet_cnt
    beq bullet_update_pl1_end    ;if counter is zero we don't print more bullet on screen

    inc bullet_pos_lo            ;if over 255 we should update hi 
    bne bullet_update_pl1_print
    inc bullet_pos_hi

bullet_update_pl1_print:
    lda bullet_pos_hi            ;Clear old character
    sta 3
    lda bullet_pos_lo
    sta 2    
    lda (2),y                ;check if next character is a brick
    jsr ball_hit_char_adc
    bne bullet_update_pl1_end

    lda #70                 ;no hit move the bullet
    sta (2),y 
    clc
    lda 3
    adc #$d4                ;add color
    sta 3
    lda #3
    sta (2),y   
    pla
    tay
    rts

bullet_update_pl1_end:
    lda #0
    sta bullet_active
    pla
    tay
    rts



bullet_update_pl2:
    lda bullet_active+1
    bne bullet_update_do_pl2
    rts


bullet_update_do_pl2:
    tya
    pha
    dec bullet_cnt+1
    beq bullet_update_pl2_end
    ldy #0
    lda bullet_pos_hi+1            ;Clear old character
    sta 3
    lda bullet_pos_lo+1
    sta 2
    lda #32
    sta (2),y 
    clc
    lda 3                        ;add background color
    adc #$d4
    sta 3
    lda #6
    sta (2),y   

    lda bullet_cnt+1
    beq bullet_update_pl2_end    ;if counter is zero we don't print more bullet on screen

    dec bullet_pos_lo+1           ;if over 255 we should update hi 
    cmp #$ff
    bne bullet_update_pl2_print
    dec bullet_pos_hi+1

bullet_update_pl2_print:
    lda bullet_pos_hi+1            ;Clear old character
    sta 3
    lda bullet_pos_lo+1
    sta 2    
    lda (2),y                ;check if next character is a brick
    jsr ball_hit_char_adc
    bne bullet_update_pl2_end

    lda #71                 ;no hit move the bullet
    sta (2),y 
    clc
    lda 3
    adc #$d4                ;add color
    sta 3
    lda #3
    sta (2),y   
    pla
    tay
    rts

bullet_update_pl2_end:
    lda #0
    sta bullet_active+1
    pla
    tay
    rts

