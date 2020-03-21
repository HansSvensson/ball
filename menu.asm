;-------------------Does init and function blocking---------------------
menu:
    ;Clean up
    lda #0
    sta sound_songToPlay
    jsr sound_init_menu
    jsr menu_cleanChar
    lda #0
    sta menu_position
    ;init
    ;Set charset
    ;lda $d018          ;set location of charset
    ;and #$f1
    ;ora #$5
    ;sta $d018
    lda $d018
    ora #$d
    sta $d018
    lda $d016           ;Select singlecolor
    and #%11101111
    sta $d016

    jsr menu_move_color
    jsr menu_balls
    jsr menu_cleanChar
    lda #0

    jsr menu_move_color
    jsr menu_speed
    jsr menu_cleanChar
    lda #0

    sta menu_position
    jsr menu_level
    jsr menu_cleanChar
    lda #0

    sta menu_position
    jsr menu_mode
    rts



menu_clearColor:
    lda #1     ;FOREGROUND COLOR
    ldx #0
menu_cleanColorLoop:
    sta $d810,x
    inx
    bne menu_cleanColorLoop
    lda #11          ;Put grey in the selectable menus.
menu_cleanColorLoop_2:
    sta $d918,x
    sta $d9f0,x
    sta $dae8,x
    inx
    bne menu_cleanColorLoop_2
    rts

menu_cleanChar:
    ldx #0
    lda #35
menu_cleanFg:
    sta $400,x
    sta $500,x
    sta $600,x
    sta $6E8,x
    inx
    bne menu_cleanFg
    rts


menu_position .byte 1    ;starts at 0
menu_time     .byte 0    ;equals the time in x*10 seconds
menu_nr_alt   .byte 0
;------------------TIME MODE MENU--------------------- 
menu_mode_titel .enc screen
                .text "game#time"
menu_mode_item1 .enc screen
                .text "#30#seconds"
menu_mode_item2 .enc screen
                .text "#60#seconds"
menu_mode_item3 .enc screen
                .text "#90#seconds"
menu_mode_item4 .enc screen
                .text "120#seconds"

menu_item1_pos = $526+$28
menu_item2_pos = $526+$50
menu_item3_pos = $526+$78
menu_item4_pos = $526+$a0

menu_modeLong_titel .enc screen
                .text "game#time"
menu_modeLong_item1 .enc screen
                .text "120#seconds"
menu_modeLong_item2 .enc screen
                .text "240#seconds"
menu_modeLong_item3 .enc screen
                .text "480#seconds"
menu_modeLong_item4 .enc screen
                .text "960#seconds"


menu_modeLong:
    lda #3
    sta menu_nr_alt
    ldx #0
menu_modeLong_title:
    lda menu_modeLong_titel,x
    sta $4ff,x
    inx
    cpx #9
    bne menu_modeLong_title   
    ldx #0
menu_modeLong_i1:
    lda menu_modeLong_item1,x
    sta menu_item1_pos,x
    inx
    cpx #11
    bne menu_modeLong_i1   
    ldx #0
menu_modeLong_i2:
    lda menu_modeLong_item2,x
    sta menu_item2_pos,x
    inx
    cpx #11
    bne menu_modeLong_i2   
    ldx #0
menu_modeLong_i3:
    lda menu_modeLong_item3,x
    sta menu_item3_pos,x
    inx
    cpx #11
    bne menu_modeLong_i3   
    ldx #0
menu_modeLong_i4:
    lda menu_modeLong_item4,x
    sta menu_item4_pos,x
    inx
    cpx #11
    bne menu_modeLong_i4
    jmp menu_mode_loop 


menu_mode:
    jsr menu_move_color
    lda gameBg_level
;    cmp #2
;    beq menu_modeShort
    jmp menu_modeLong

menu_modeShort:
    lda #3
    sta menu_nr_alt
    ldx #0
menu_mode_title:
    lda menu_mode_titel,x
    sta $4ff,x
    inx
    cpx #9
    bne menu_mode_title   
    ldx #0
menu_mode_i1:
    lda menu_mode_item1,x
    sta menu_item1_pos,x
    inx
    cpx #11
    bne menu_mode_i1   
    ldx #0
menu_mode_i2:
    lda menu_mode_item2,x
    sta menu_item2_pos,x
    inx
    cpx #11
    bne menu_mode_i2   
    ldx #0
menu_mode_i3:
    lda menu_mode_item3,x
    sta menu_item3_pos,x
    inx
    cpx #11
    bne menu_mode_i3   
    ldx #0
menu_mode_i4:
    lda menu_mode_item4,x
    sta menu_item4_pos,x
    inx
    cpx #11
    bne menu_mode_i4   

menu_mode_loop:
    jsr menu_delay
    jsr menu_input
    cmp #1
    beq menu_mode_exit
    jsr menu_move
    lda menu_position
    sta game_mode
    jmp menu_mode_loop

menu_mode_exit:
;    lda gameBg_level
;    cmp #2
;    bne menu_mode_exit_setTimeLong
;    jsr menu_setTimeShort  
;    jsr score_timeSet
;    rts
;menu_mode_exit_setTimeLong:
    jsr menu_setTimeLong  
    jsr score_timeSet
    rts

;30 60 90 120 fill the stack with low mid high
menu_setTimeShort:
    lda #48               ;zero
    sta score_time+2
    sta score_time+1
    lda menu_position
    beq menu_setTimeShort0
    cmp #1
    beq menu_setTimeShort1
    cmp #2
    beq menu_setTimeShort2
    cmp #3
    beq menu_setTimeShort3
    
menu_setTimeShort0:
    lda #51               ;three
    sta score_time+1
    rts
menu_setTimeShort1:
    lda #54               ;six
    sta score_time+1
    rts
menu_setTimeShort2:
    lda #57               ;nine
    sta score_time+1
    rts
menu_setTimeShort3:
    lda #50               ;two
    sta score_time+1
    lda #49               ;one
    sta score_time
    rts
    
menu_setTimeLong:  
    lda #48               ;zero
    sta score_time+2
    sta score_time+1
    lda menu_position
    beq menu_setTimeLong0
    cmp #1
    beq menu_setTimeLong1
    cmp #2
    beq menu_setTimeLong2
    cmp #3
    beq menu_setTimeLong3
menu_setTimeLong0:
    lda #50               ;two
    sta score_time+1
    lda #49               ;one
    sta score_time
    rts
menu_setTimeLong1:  ;240
    lda #52               ;four
    sta score_time+1
    lda #50               ;two
    sta score_time
    rts
menu_setTimeLong2: ;480
    lda #56               ;eight
    sta score_time+1
    lda #52               ;four
    sta score_time
    rts
menu_setTimeLong3: ;960
    lda #54               ;six
    sta score_time+1
    lda #57               ;nine
    sta score_time
    rts

;------------------LEVEL SELECT--------------------- 
menu_level_titel .enc screen
                .text "select#level"
menu_level_item1 .enc screen
                .text "five#lanes"
menu_level_item2 .enc screen
                .text "seven#lanes"
menu_level_item3 .enc screen
                .text "ballevel2"
menu_level_item4 .enc screen
                .text "ballevel6"

;540 start char
menu_level_item1_pos = $54f
menu_level_item2_pos = $54f+$28
menu_level_item3_pos = $54f+$50
menu_level_item4_pos = $54f+$78

menu_level:
    lda #3
    sta menu_nr_alt
    jsr menu_cleanChar
    jsr menu_move_color
    ldx #0
menu_level_title:
    lda menu_level_titel,x
    sta $4fe,x                ;4f0 0 baseline
    inx
    cpx #12
    bne menu_level_title   
    ldx #0
menu_level_i1:
    lda menu_level_item1,x
    sta menu_level_item1_pos,x
    inx
    cpx #9
    bne menu_level_i1   
    ldx #0
menu_level_i2:
    lda menu_level_item2,x
    sta menu_level_item2_pos,x
    inx
    cpx #9
    bne menu_level_i2   
    ldx #0
menu_level_i3:
    lda menu_level_item3,x
    sta menu_level_item3_pos,x
    inx
    cpx #9
    bne menu_level_i3   
    ldx #0
menu_level_i4:
    lda menu_level_item4,x
    sta menu_level_item4_pos,x
    inx
    cpx #9
    bne menu_level_i4   
    ldx #0

    ldx menu_position
    jsr menu_move_color

menu_level_loop:
    jsr menu_delay
    jsr menu_input
    cmp #1
    beq menu_level_exit
    jsr menu_move
    lda menu_position
    sta gameBg_level
    jmp menu_level_loop

menu_level_exit:
    rts


;------------------BALLS SELECT--------------------- 
menu_balls_titel .enc screen
                .text "select#number#of#balls"
menu_balls_item1 .enc screen
                .text "3#balls"
menu_balls_item2 .enc screen
                .text "6#balls"

;540 start char
menu_balls_item1_pos = $54f
menu_balls_item2_pos = $54f+$28

menu_balls:
    lda #1
    sta menu_nr_alt
    jsr menu_cleanChar
    jsr menu_move_color
    ldx #0
menu_balls_title:
    lda menu_balls_titel,x
    sta $4f8,x                ;4f0 0 baseline
    inx
    cpx #22
    bne menu_balls_title   
    ldx #0
menu_balls_i1:
    lda menu_balls_item1,x
    sta menu_balls_item1_pos,x
    inx
    cpx #7
    bne menu_balls_i1   
    ldx #0
menu_balls_i2:
    lda menu_balls_item2,x
    sta menu_balls_item2_pos,x
    inx
    cpx #7
    bne menu_balls_i2   
    ldx #0

    ldx menu_position
    jsr menu_move_color

menu_balls_loop:
    jsr menu_delay
    jsr menu_input
    cmp #1
    beq menu_balls_exit
    jsr menu_move
    lda menu_position
    sta game_sixBalls
    jmp menu_balls_loop

menu_balls_exit:
    rts
;----------------------------



;------------------BALLS SPEED--------------------- 
menu_speed_titel .enc screen
                .text "select#speed"
menu_speed_item1 .enc screen
                .text "cool"
menu_speed_item2 .enc screen
                .text "sporty"
menu_speed_item3 .enc screen
                .text "turbo"

;540 start char
menu_speed_item1_pos = $54f
menu_speed_item2_pos = $54f+$28
menu_speed_item3_pos = $54f+$50

menu_speed:
    lda #2
    sta menu_nr_alt
    jsr menu_cleanChar
    jsr menu_move_color
    ldx #0
menu_speed_title:
    lda menu_speed_titel,x
    sta $4fc,x                ;4f0 0 baseline
    inx
    cpx #12
    bne menu_speed_title   
    ldx #0
menu_speed_i1:
    lda menu_speed_item1,x
    sta menu_speed_item1_pos,x
    inx
    cpx #4
    bne menu_speed_i1   
    ldx #0
menu_speed_i2:
    lda menu_speed_item2,x
    sta menu_speed_item2_pos,x
    inx
    cpx #6
    bne menu_speed_i2   
    ldx #0
menu_speed_i3:
    lda menu_speed_item3,x
    sta menu_speed_item3_pos,x
    inx
    cpx #5
    bne menu_speed_i3   
    ldx #0

    ldx menu_position
    jsr menu_move_color

menu_speed_loop:
    jsr menu_delay
    jsr menu_input
    cmp #1
    beq menu_speed_exit
    jsr menu_move
    lda menu_position
    
menu_speed_loop_cool:
    cmp #0
    bne menu_speed_loop_sporty
    lda #2
    sta game_BallSpeedRound1
    lda #0
    sta game_BallSpeedRound2
    jmp menu_speed_loop
menu_speed_loop_sporty:
    cmp #1
    bne menu_speed_loop_turbo
    lda #1
    sta game_BallSpeedRound1
    lda #0
    sta game_BallSpeedRound2
    jmp menu_speed_loop
menu_speed_loop_turbo:
    cmp #2
    bne menu_speed_loop
    lda #1
    sta game_BallSpeedRound1
    lda #1
    sta game_BallSpeedRound2

    jmp menu_speed_loop

menu_speed_exit:
    rts
;----------------------------




menu_delay:
    lda #0
    sta sound_delay_cnt
menu_delay_loop:
    lda sound_delay_cnt
    cmp sound_delay_lim
    bne menu_delay_loop
    rts

;-------------------Check input 0=none 1=fire, 2=up, 3=down-----------------------
menu_iput_fire .byte 0
menu_input:
    lda $dC00
    and $dC01
    and #%00010000
    beq menu_waitInput_fire
    lda $dC00
    and $dC01
    and #%00000001
    beq menu_waitInput_up
    lda $dC00
    and $dC01
    and #%00000010
    beq menu_waitInput_down
    lda menu_iput_fire
    bne menu_waitInput_fireDep
    lda #0
    rts
menu_waitInput_fireDep:
    lda #0
    sta menu_iput_fire
    lda #1
    rts
menu_waitInput_fire:
    lda #1
    sta menu_iput_fire
    lda #0
    rts 
menu_waitInput_up:
    lda #2
    rts 
menu_waitInput_down:
    lda #3
    rts 


;------------------------
menu_move:
    beq menu_move_not
    cmp #2
    beq menu_move_up
    cmp #3
    beq menu_move_down
    rts

menu_move_down:
    lda menu_position
    cmp menu_nr_alt
    beq menu_move_not
    inc menu_position
    jmp menu_move_color

menu_move_up:
    lda menu_position
    cmp #0
    beq menu_move_not
    dec menu_position

menu_move_color:
    jsr menu_clearColor
    ldx #0
    lda menu_position
    cmp #0
    beq menu_move_color_i1
    cmp #1
    beq menu_move_color_i2
    cmp #2
    beq menu_move_color_i3
    cmp #3
    beq menu_move_color_i4
    rts

menu_move_color_i1:
    lda #5      
menu_move_color_i1_loop:
    sta $d400+menu_item1_pos,x
    inx
    cpx #40
    bne menu_move_color_i1_loop
    rts    

menu_move_color_i2:
    lda #5      
menu_move_color_i2_loop:
    sta $d400+menu_item2_pos,x
    inx
    cpx #40
    bne menu_move_color_i2_loop
    rts    

menu_move_color_i3:
    lda #5      
menu_move_color_i3_loop:
    sta $d400+menu_item3_pos,x
    inx
    cpx #40
    bne menu_move_color_i3_loop    
    rts    

menu_move_color_i4:
    lda #5      
menu_move_color_i4_loop:
    sta $d400+menu_item4_pos,x
    inx
    cpx #40
    bne menu_move_color_i4_loop    
    rts    

menu_move_not:
    rts

