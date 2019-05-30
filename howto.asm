howto_joy_ctrl   .enc screen
                 .text "controls"
howto_joy_up     .enc screen
                 .text "joystick up     ########move#bat#up"
howto_joy_down   .enc screen
                 .text "joystick#down     ######move#bat#down"
howto_joy_left   .enc screen
                 .text "joystick#left     ######activate wall"
howto_joy_button .enc screen
                 .text "joystick#button     ####bash and shoot"

howto_rules_cap  .enc screen
                 .text "hints"
howto_rules_bash .enc screen
                 .text "* claim oponents balls by bashing them"
howto_rules_pnt  .enc screen
                 .text "* one point for bricks and bonuses"
howto_rules_bonus .enc screen
                 .text "* annoy oponent with a wall"
howto_rules_time .enc screen
                 .text "* control balls y direction by moving"
howto_rules_shoot .enc screen
                 .text "  bat against or with the balls dir."
howto_quit       .enc screen
                 .text "press fire"
howto_bonuses_cap .enc screen
                  .text "bonuses by color"
howto_bonuses_small .enc screen
                    .text "oponent gets a smaller bat"
howto_bonuses_large .enc screen
                    .text "you get a larger bat"
howto_bonuses_all   .enc screen
                    .text "you own all balls"
howto_bonuses_bullet .enc screen
                     .text "you can shoot bullets"
howto_bonuses_unstop .enc screen
                     .text "your balls can go through many bricks"


row1start = $410
row2start = row1start + $19 + $28
row3start = row2start + $28 
row4start = row3start + $28
row5start = row4start + $28
row6start = row5start + $28 + $28 + 16
row7start = row6start + $18 + $28
row8start = row7start + $28
row9start = row8start + $28
row10start = row9start + $28
row11start = row10start + $28

row12start = row11start + $28 + $28 + 11

row13start = row12start + $28 + $28 -5
row14start = row13start + $28 +3
row15start = row14start + $28 +1
row16start = row15start + $28 -2
row17start = row16start + $28 -8

row18start = row17start + $28 + $28 + $28 + 14



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
    cpy #35
    bne howto_up
    
    ldy #0
    
howto_down:
    lda howto_joy_down,y
    sta row3start,y
    iny
    cpy #37
    bne howto_down
    
    ldy #0

howto_left:
    lda howto_joy_left,y
    sta row4start,y
    iny
    cpy #37
    bne howto_left

    ldy #0

howto_button:
    lda howto_joy_button,y
    sta row5start,y
    iny
    cpy #38
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
    cpy #34
    bne howto_pnt

    ldy #0

howto_bonus:
    lda howto_rules_bonus,y
    sta row9start,y
    iny
    cpy #27
    bne howto_bonus
    
    ldy #0

howto_time:
    lda howto_rules_time,y
    sta row10start,y
    iny
    cpy #37
    bne howto_time

    ldy #0

howto_shoot:
    lda howto_rules_shoot,y
    sta row11start,y
    iny
    cpy #36
    bne howto_shoot

    ldy #0

howto_bonuses:
    lda howto_bonuses_cap,y
    sta row12start,y
    lda #1
    sta row12start+$d400,y
    iny
    cpy #16
    bne howto_bonuses

    ldy #0

howto_small:
    lda howto_bonuses_small,y
    sta row13start,y
    lda #2
    sta row13start+$d400,y
    iny
    cpy #26
    bne howto_small

    ldy #0

howto_large:
    lda howto_bonuses_large,y
    sta row14start,y
    lda #5
    sta row14start+$d400,y
    iny
    cpy #20
    bne howto_large

    ldy #0

howto_all:
    lda howto_bonuses_all,y
    sta row15start,y
    lda #7
    sta row15start+$d400,y
    iny
    cpy #17
    bne howto_all

    ldy #0

howto_bullet:
    lda howto_bonuses_bullet,y
    sta row16start,y
    lda #4
    sta row16start+$d400,y
    iny
    cpy #21
    bne howto_bullet

    ldy #0

howto_unstop:
    lda howto_bonuses_unstop,y
    sta row17start,y
    lda #3
    sta row17start+$d400,y
    iny
    cpy #37
    bne howto_unstop

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
    sta row18start,y
    lda howto_quitColor
    sta $d400+row18start,y
    iny
    cpy #10
    bne howto_quit_print_doLoop
    rts
