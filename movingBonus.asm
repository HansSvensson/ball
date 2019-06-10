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
    sta movingBonus_move_x_index
    sta movingBonus_move_y_mode
    sta movingBonus_move_x_split
    sta movingBonus_mode
    lda #50
    sta movingBonus_update_insert_frame
    lda movingBonus_update_insert_lim
    sta movingBonus_update_insert_cnt
    
movingBonus_init_end:
    rts



;---Update function------------
movingBonus_update_insert_lim    = #60
movingBonus_update_insert_frame: .byte 0
movingBonus_update_insert_cnt:   .byte 0

movingBonus_update:
    lda movingBonus_mode              ; 0=Visible, 1=not visible, wait to insert,  3> Chaos mode active
    beq movingBonus_update_visible
    cmp #1
    beq movingBonus_update_insert
    cmp #2
    beq movingBonus_update_chaos_set_end

    dec movingBonus_mode                    ; movingBonus_mode > 2 => Active chaos
    jsr movingBonus_update_chaos    
    rts

movingBonus_update_chaos_set_end:
    dec movingBonus_mode                    ; make it 1, so that we can reinsert again.
    jsr movingBonus_reset
    rts

movingBonus_update_visible:
    jsr movingBonus_move
    jsr movingBonus_hitDetect
    rts




movingBonus_update_insert:
    dec movingBonus_update_insert_frame
    bne movingBonus_update_insert_end
    lda #50
    sta movingBonus_update_insert_frame
    dec movingBonus_update_insert_cnt
    bne movingBonus_update_insert_end
    lda movingBonus_update_insert_lim
    sta movingBonus_update_insert_cnt

    lda $d015    ; we set sprite close sprite
    ora #$10
    sta $d015
    lda #0
    sta movingBonus_mode
    sta movingBonus_move_x_index
    sta movingBonus_move_y_mode
    sta movingBonus_move_x_split

movingBonus_update_insert_end:    
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
    ldx #0
    lda ball_owner
    cmp ball_player_none
    beq movingBonus_hitDetect_ball2
    jmp movingBonus_hitDetect_hit
movingBonus_hitDetect_ball2:
    lda ball_temp_d01e
    and #2
    beq movingBonus_hitDetect_ball3
    ldx #2
    lda ball_owner+2
    cmp ball_player_none
    beq movingBonus_hitDetect_ball3
    jmp movingBonus_hitDetect_hit
movingBonus_hitDetect_ball3:
    lda ball_temp_d01e
    and #4
    beq movingBonus_hitDetect_end
    ldx #4
    lda ball_owner+4
    cmp ball_player_none
    beq movingBonus_hitDetect_end
    jmp movingBonus_hitDetect_hit


movingBonus_hitDetect_hit:
    jsr movingBonus_hitbox
    beq movingBonus_hitDetect_end
    jsr movingBonus_incScore
    lda $d015    ; we set sprite close sprite
    and #$EF
    sta $d015
    lda #200
    sta movingBonus_mode
movingBonus_hitDetect_end:
    pla
    tax
    rts    

movingBonus_hitbox:
    lda $d000,x
    cmp movingBonus_move_x_min
    bcs movingBonus_hitbox_x_max
    jmp movingBonus_hitbox_end
movingBonus_hitbox_x_max:    
    cmp movingBonus_move_x_max
    bcc movingBonus_hitbox_y
    jmp movingBonus_hitbox_end
movingBonus_hitbox_y:
    lda $d009
    clc
    adc #$dc
    cmp $d001,x
    bcc movingBonus_hitbox_y_max
    jmp movingBonus_hitbox_end
movingBonus_hitbox_y_max:
    lda $d009
    clc
    adc #24
    cmp $d001,x
    bcs movingBonus_hitbox_fin

movingBonus_hitbox_end:
    lda #0
    rts

movingBonus_hitbox_fin:
    lda #1
    rts



movingBonus_incScore:
    cmp ball_player_1
    beq movingBonus_incScore_pl1
    ldx #4
    jmp movingBonus_incScore_do

movingBonus_incScore_pl1:
    ldx #0
movingBonus_incScore_do:
    jsr score_increase
    jsr score_increase
    jsr score_increase
    jsr score_increase
    jsr score_increase
    jsr score_increase
    jsr score_increase
    jsr score_increase
    jsr score_increase
    jsr score_increase
    jsr score_increase
    jsr score_increase
    jsr score_increase
    jsr score_increase
    jsr score_increase
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
    lda sound_random_value
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
movingBonus_move_x_min = #125    ; 149 - 24 because of sprite left down corner
movingBonus_move_x_max = #220    ; 196 + 24 becase of sprite width

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

