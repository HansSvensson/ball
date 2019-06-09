movingBonus_mode: .byte 0 ;0=normal, 1=chaos

movingBonus_init:
    lda game_sixBalls
    bne movingBonus_init_end

    lda $d015    ; we set sprite 4
    ora #$10
    sta $d015

    lda #05      ; 
    sta $d02b

    lda #$ad
    sta $d008    ; set x coordinate to 40
    lda movingBonus_move_y_up_lim
    sta $d009    ; set y coordinate to 40

    lda #$e3
    sta $07fc    ; set pointer: sprite data at $2040
    
    lda $d01c
    ora #$10
    sta $d01c
    
    ;lda #12     ;sprite multicolor 1
    ;sta $D024
    
    lda #15     ;sprite 6 individual
    sta $D02b 

    lda #0
    sta movingBonus_mode
    sta movingBonus_move_x_index
    sta movingBonus_move_y_mode
    sta movingBonus_move_x_split
    
movingBonus_init_end:
    rts



;---Update function------------
movingBonus_update:
    lda movingBonus_mode
    beq movingBonus_update_end
    dec movingBonus_mode
    beq movingBonus_update_chaos_set_end
    jsr movingBonus_update_chaos    
    rts

movingBonus_update_chaos_set_end:
    jsr movingBonus_reset
    rts

movingBonus_update_end:
    jsr movingBonus_move
    jsr movingBonus_hitDetect
    rts
;-------------------------------

movingBonus_reset:
    lda $d016
    and #$f8
    sta $d016
    lda #0
    sta $d020
    sta $d021
    rts

movingBonus_hitDetect:
    txa
    pha

    ;check if ht and atleast on ball is set  
    lda ball_temp_d01e
    and #$17
    cmp #$11
    bcc movingBonus_hitDetect_end

movingBonus_hitDetect_ball1:
    lda ball_temp_d01e
    and #1
    beq movingBonus_hitDetect_ball2
    lda ball_owner
    cmp ball_player_none
    beq movingBonus_hitDetect_ball2
    jmp movingBonus_hitDetect_hit
movingBonus_hitDetect_ball2:
    lda ball_temp_d01e
    and #2
    beq movingBonus_hitDetect_ball3
    lda ball_owner+2
    cmp ball_player_none
    beq movingBonus_hitDetect_ball3
    jmp movingBonus_hitDetect_hit
movingBonus_hitDetect_ball3:
    lda ball_temp_d01e
    and #4
    beq movingBonus_hitDetect_end
    lda ball_owner+4
    cmp ball_player_none
    beq movingBonus_hitDetect_end
    jmp movingBonus_hitDetect_hit


movingBonus_hitDetect_hit:
    lda $d015    ; we set sprite close sprite
    and #$EF
    sta $d015
    lda #200
    sta movingBonus_mode
movingBonus_hitDetect_end:
    pla
    tax
    rts    



movingBonus_screen_dirX: .byte 0
movingBonus_screen_dirY: .byte 0

movingBonus_update_chaos:
    lda game_sixBalls
    bne movingBonus_update_chaos_end

    jsr moveingBonus_screenMove_X
    jsr moveingBonus_colors
    jsr movingBonus_bg

movingBonus_update_chaos_end:
    rts


movingBonus_bg:
    lda $d41B
    sta $3100
    sta $3101
    sta $3102
    sta $3103
    sta $3104
    sta $3105
    sta $3106
    sta $3107
    rts


moveingBonus_colors:
    inc $d020
    inc $d021
    rts



moveingBonus_screenMove_X:

    lda movingBonus_screen_dirX
    bne movingBonus_screen_dirX_left

movingBonus_screen_dirX_right:
    lda $d016
    and #$7
    cmp #7
    bne movingBonus_screen_dirX_rightMove
    inc movingBonus_screen_dirX
    rts
movingBonus_screen_dirX_rightMove:
    inc $d016
    rts
    
movingBonus_screen_dirX_left:
    lda $d016
    and #$7
    bne movingBonus_screen_dirX_leftMove
    lda #0
    sta movingBonus_screen_dirX
    rts
movingBonus_screen_dirX_leftMove:
    dec $d016
    rts
        





;--------Move the sprite----------
movingBonus_move_x_index .byte 0
movingBonus_move_y_mode .byte 0
movingBonus_move_x_split .byte 0
movingBonus_move_y_up_lim   = #101
movingBonus_move_y_down_lim = #190


movingBonus_move_x_sin:  .byte 173,176,179,182,185,188,190,192,194,195,196,196,196,196,195
                         .byte 193,191,189,187,184,181,177,174,171,168,164,161,158,156,154
                         .byte 152,150,149,149,149,149,150,151,153,155,157,160,163,166,169


movingBonus_move:
    jsr movingBonus_move_y
    jsr movingBonus_move_x
    rts



movingBonus_move_x:
    lda movingBonus_move_x_split
    beq movingBonus_move_x_split_end
    lda #0
    sta movingBonus_move_x_split

    txa
    pha
    ldx movingBonus_move_x_index
    cpx #45
    bne movingBonus_move_x_do
    ldx #0
    stx movingBonus_move_x_index
movingBonus_move_x_do:
    lda movingBonus_move_x_sin,x
    sta $d008
    inc movingBonus_move_x_index
    pla
    tax
    rts


movingBonus_move_x_split_end:
    lda #1
    sta movingBonus_move_x_split
    rts





movingBonus_move_y:
    lda movingBonus_move_y_mode  
    beq movingBonus_move_y_down         

movingBonus_move_y_up:
    lda $d009                           
    cmp movingBonus_move_y_up_lim
    beq movingBonus_move_y_up_change
    dec $d009
    rts
movingBonus_move_y_up_change:
    lda #0
    sta movingBonus_move_y_mode
    rts    

movingBonus_move_y_down:
    lda $d009                           
    cmp movingBonus_move_y_down_lim
    beq movingBonus_move_y_down_change
    inc $d009
    rts
movingBonus_move_y_down_change:
    lda #1
    sta movingBonus_move_y_mode
    rts    

