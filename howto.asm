howto_joy_ctrl   .enc screen
                 .text "controls"
howto_joy_up     .enc screen
                 .text "joystick up########move#bat#up"
howto_joy_down   .enc screen
                 .text "joystick#down######move#bat#down"
howto_joy_left   .enc screen
                 .text "joystick#left######shoot#bullets"
howto_joy_button .enc screen
                 .text "joystick#button####bash#"

howto_rules_cap  .enc screen
                 .text "rules"
howto_rules_bash .enc screen
                 .text "* claim oponents balls by bashing them"
howto_rules_pnt  .enc screen
                 .text "* one point for bricks"
howto_rules_bonus .enc screen
                 .text "* ten points for bonuses"
howto_rules_time .enc screen
                 .text "* most bonuses lasts for 5 seconds"
howto_rules_shoot .enc screen
                 .text "* no score for shoting bricks"
howto_quit       .enc screen
                 .text "press fire"


row1start = $436
row2start = row1start + $1c + $28+ $28
row3start = row2start + $28 
row4start = row3start + $28
row5start = row4start + $28
row6start = row5start + $28+ $28 + $28 + 14
row7start = row6start + $1a + $28 + $28
row8start = row7start + $28
row9start = row8start + $28
row10start = row9start + $28
row11start = row10start + $28
row12start = row11start + $28 + $28 + $28 + $28 + 12



howto_init:
    
    lda $d018
    ora #$d
    sta $d018
    lda $d016           ;Select singlecolor
    and #%11101111
    sta $d016

    ldy #0
    lda #11
howto_fillGrey:
    sta $d800,y
    sta $d900,y
    sta $da00,y
    sta $dae0,y
    iny
    bne howto_fillGrey

    ldy #0
    
howto_ctrl:
    lda howto_joy_ctrl,y
    sta row1start,y
    lda #1
    sta row1start+$d400,y
    iny
    cpy #8
    bne howto_ctrl


    ldy #0

howto_up:
    lda howto_joy_up,y
    sta row2start,y
    iny
    cpy #30
    bne howto_up
    
    ldy #0
    
howto_down:
    lda howto_joy_down,y
    sta row3start,y
    iny
    cpy #32
    bne howto_down
    
    ldy #0

howto_left:
    lda howto_joy_left,y
    sta row4start,y
    iny
    cpy #32
    bne howto_left

    ldy #0

howto_button:
    lda howto_joy_button,y
    sta row5start,y
    iny
    cpy #24
    bne howto_button
    
    ldy #0

howto_rules:
    lda howto_rules_cap,y
    sta row6start,y
    lda #1
    sta row6start+$d400,y
    iny
    cpy #5
    bne howto_rules

    ldy #0

howto_bash:
    lda howto_rules_bash,y
    sta row7start,y
    iny
    cpy #38
    bne howto_bash

    ldy #0

howto_pnt:
    lda howto_rules_pnt,y
    sta row8start,y
    iny
    cpy #22
    bne howto_pnt

    ldy #0

howto_bonus:
    lda howto_rules_bonus,y
    sta row9start,y
    iny
    cpy #24
    bne howto_bonus
    
    ldy #0

howto_time:
    lda howto_rules_time,y
    sta row10start,y
    iny
    cpy #34
    bne howto_time

    ldy #0

howto_shoot:
    lda howto_rules_shoot,y
    sta row11start,y
    iny
    cpy #29
    bne howto_shoot

    ldy #0

    ;jsr gameOverWaitJoy

howto_WaitJoy: 
    jsr howto_quit_print  
    lda $DC00
    and $DC01
    and #%00010000               ;Zero flag=0 if joystick pressed
    bne howto_WaitJoy
howto_WaitJoyUp:    
    jsr howto_quit_print  
    lda $DC00
    and $DC01
    and #%00010000               ;Zero flag=0 if joystick pressed
    beq howto_WaitJoyUp

    rts





howto_quitCnt:   .byte 0
howto_quitColor: .byte 0

howto_quit_print:
    lda $d012
    bne howto_quit_print
    dec howto_quitCnt
    beq howto_quit_print_color
    rts

howto_quit_print_color:
    lda howto_quitColor
    beq howto_quitColor_green
    lda #0
    sta howto_quitColor
    jmp howto_quit_print_do
howto_quitColor_green:
    lda #5
    sta howto_quitColor
howto_quit_print_do:
    ldy #0
howto_quit_print_doLoop:
    lda howto_quit,y
    sta row12start,y
    lda howto_quitColor
    sta $d400+row12start,y
    iny
    cpy #10
    bne howto_quit_print_doLoop
    rts
