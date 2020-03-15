howto_row1       .enc screen
                 .text "////////////////////////////////////////"
howto_row2       .enc screen
                 .text "/////////  welcome to the game  ////////"
howto_row3       .enc screen
                 .text "////////////////////////////////////////"

howto_row4       .enc screen
                 .text "1. use two certified joysticks          "
howto_row5       .enc screen
                 .text "2. claim balls, hit bricks, get points  "
howto_row6       .enc screen
                 .text "3. get bonuses for mega powers          "

howto_row7       .enc screen
                 .text "when you hit the ball:                  "
howto_row8       .enc screen
                 .text " * claim it with fire button (bash)     "
howto_row9       .enc screen
                 .text " * change its course by moving the bat  "

howto_row10       .enc screen
                 .text "bonuses                                 "
howto_row11       .enc screen
                 .text " * green   your bat is so big            "
howto_row12       .enc screen
                 .text " * red     opponent's bat is so small      "
howto_row13       .enc screen
                 .text " * yellow  claim all the balls          "
howto_row14       .enc screen
                 .text " * cyan    shotgun (use with fire)        "
howto_row15       .enc screen
                 .text " * purple  bazooka balls                "
howto_row16       .enc screen
                 .text " * ht      15 points & eternal glory        "
howto_row17       .enc screen
                 .text "dont stare at the screen for too long ! "
howto_row18       .enc screen
                 .text "aro(code,gfx)  goto80(sfx)  vinzi(font) "
howto_quit       .enc screen
                 .text "             press fire                 "

row1 = $400
row2 = row1 + 40
row3 = row2 + 40
row4 = row3 + 40 + 40
row5 = row4 + 40
row6 = row5 + 40
row7 = row6 + 40 + 40
row8 = row7 + 40
row9 = row8 + 40
row10 = row9 + 40 + 40
row11 = row10 + 40
row12 = row11 + 40
row13 = row12 + 40
row14 = row13 + 40
row15 = row14 + 40
row16 = row15 + 40
row17 = row16 + 40 + 40
row18 = row17 + 40 + 40
row19 = row18 + 40 + 40 

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
howto_row1_loop:
    lda howto_row1,y
    sta row1,y
    lda #1
    sta row1+$d400,y
    iny
    cpy #40
    bne howto_row1_loop

    ldy #0
howto_row2_loop:
    lda howto_row2,y
    sta row2,y
    lda #1
    sta row2+$d400,y
    iny
    cpy #40
    bne howto_row2_loop

    ldy #0   
howto_row3_loop:
    lda howto_row3,y
    sta row3,y
    lda #1
    sta row3+$d400,y
    iny
    cpy #40
    bne howto_row3_loop

    ldy #0    
howto_row4_loop:
    lda howto_row4,y
    sta row4,y
    iny
    cpy #40
    bne howto_row4_loop

    ldy #0

howto_row5_loop:
    lda howto_row5,y
    sta row5,y
    iny
    cpy #40
    bne howto_row5_loop

    ldy #0
howto_row6_loop:
    lda howto_row6,y
    sta row6,y
    iny
    cpy #40
    bne howto_row6_loop

    ldy #0
howto_row7_loop:
    lda howto_row7,y
    sta row7,y
    lda #1
    sta row7+$d400,y
    iny
    cpy #40
    bne howto_row7_loop

    ldy #0
howto_row8_loop:
    lda howto_row8,y
    sta row8,y
    iny
    cpy #40
    bne howto_row8_loop

    ldy #0
howto_row9_loop:
    lda howto_row9,y
    sta row9,y
    iny
    cpy #40
    bne howto_row9_loop


   ldy #0    
howto_row10_loop:
    lda howto_row10,y
    sta row10,y
    lda #1
    sta row10+$d400,y
    iny
    cpy #40
    bne howto_row10_loop

   ldy #0    
howto_row11_loop:
    lda howto_row11,y
    sta row11,y
    lda #5
    sta row11+$d400,y
    iny
    cpy #40
    bne howto_row11_loop

   ldy #0    
howto_row12_loop:
    lda howto_row12,y
    sta row12,y
    lda #2
    sta row12+$d400,y
    iny
    cpy #40
    bne howto_row12_loop

   ldy #0    
howto_row13_loop:
    lda howto_row13,y
    sta row13,y
    lda #7
    sta row13+$d400,y
    iny
    cpy #40
    bne howto_row13_loop


   ldy #0    
howto_row14_loop:
    lda howto_row14,y
    sta row14,y
    lda #3
    sta row14+$d400,y
    iny
    cpy #40
    bne howto_row14_loop

   ldy #0    
howto_row15_loop:
    lda howto_row15,y
    sta row15,y
    lda #4
    sta row15+$d400,y
    iny
    cpy #40
    bne howto_row15_loop

   ldy #0    
howto_row16_loop:
    lda howto_row16,y
    sta row16,y
    lda #6
    sta row16+$d400,y
    iny
    cpy #40
    bne howto_row16_loop

   ldy #0    
howto_row17_loop:
    lda howto_row17,y
    sta row18,y
    iny
    cpy #40
    bne howto_row17_loop
   
   ldy #0    
howto_row18_loop:
    lda howto_row18,y
    sta row17,y
    iny
    cpy #40
    bne howto_row18_loop

    



    ldy #0
 




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
    sta row19,y
    lda howto_quitColor
    sta $d400+row19,y
    iny
    cpy #40
    bne howto_quit_print_doLoop
    rts
