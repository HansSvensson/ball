;-------------------Does init and function blocking---------------------
menu:
    
    ;Clean up
    jsr menu_cleanChar
    ;init
    ;Set charset
    lda $d018          ;set location of charset
    and #$f1
    ora #$5
    sta $d018
    lda $d016           ;Select singlecolor
    and #%11101111
    sta $d016

    jsr menu_move_color
    jsr menu_mode
    jsr menu_level
    jsr menu_cleanChar
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
    lda #32
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
                .text "game modes"
menu_mode_item1 .enc screen
                .text "unlimited time"
menu_mode_item2 .enc screen
                .text "30 seconds"
menu_mode_item3 .enc screen
                .text "60 seconds"
menu_mode_item4 .enc screen
                .text "90 seconds"

menu_item1_pos = $525+$28
menu_item2_pos = $525+$50
menu_item3_pos = $525+$78
menu_item4_pos = $525+$a0

menu_mode:
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
    cpx #14
    bne menu_mode_i1   
    ldx #0
menu_mode_i2:
    lda menu_mode_item2,x
    sta menu_item2_pos,x
    inx
    cpx #10
    bne menu_mode_i2   
    ldx #0
menu_mode_i3:
    lda menu_mode_item3,x
    sta menu_item3_pos,x
    inx
    cpx #10
    bne menu_mode_i3   
    ldx #0
menu_mode_i4:
    lda menu_mode_item4,x
    sta menu_item4_pos,x
    inx
    cpx #10
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
    lda menu_position
    bne menu_mode_exitSetTime
    rts
menu_mode_exitSetTime:
    lda menu_time
    jsr score_timeSet
    rts


;------------------LEVEL SELECT--------------------- 
menu_level_titel .enc screen
                .text "select level"
menu_level_item1 .enc screen
                .text "hack n trade"
menu_level_item2 .enc screen
                .text "iball"
menu_level_item3 .enc screen
                .text "random"
;540 start char
menu_level_item1_pos = $54e
menu_level_item2_pos = $54e+$28
menu_level_item3_pos = $54e+$50

menu_level:
    lda #2
    sta menu_nr_alt
    jsr menu_cleanChar
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
    cpx #12
    bne menu_level_i1   
    ldx #0
menu_level_i2:
    lda menu_level_item2,x
    sta menu_level_item2_pos,x
    inx
    cpx #5
    bne menu_level_i2   
    ldx #0
menu_level_i3:
    lda menu_level_item3,x
    sta menu_level_item3_pos,x
    inx
    cpx #6
    bne menu_level_i3   
    ldx #0

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







menu_delay:
    ldx #50
menu_delay_loop:
    lda $d012
    cmp #1
    bne menu_delay_loop
    dex
    cpx #0
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
    lda #3
    sta menu_time    
    rts    

menu_move_color_i3:
    lda #5      
menu_move_color_i3_loop:
    sta $d400+menu_item3_pos,x
    inx
    cpx #40
    bne menu_move_color_i3_loop    
    lda #6
    sta menu_time    
    rts    

menu_move_color_i4:
    lda #5      
menu_move_color_i4_loop:
    sta $d400+menu_item4_pos,x
    inx
    cpx #40
    bne menu_move_color_i4_loop    
    lda #9
    sta menu_time    
    rts    

menu_move_not:
    rts

