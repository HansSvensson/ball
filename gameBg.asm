gameElframeCount .byte 0
gameElframeState .byte 0

gameBg_level .byte 0
gameBg_levelSub .byte 0
gameBg_init:
    
    lda #0
    sta gameBg_levelSub
    jsr gameBg_init_bg

    ;----------fill fg color-------
    lda #10     ;FOREGROUND COLOR
    ldx #0
gameBg_fill_foreground:
    sta $d800,x
    sta $d900,x
    sta $da00,x
    sta $db00,x
    inx
    bne gameBg_fill_foreground

    lda #6     ;FOREGROUND COLOR
    ldx #1
gameBg_fill_foreground_2:
    sta $d850,x
    sta $d878,x
    sta $d8a0,x
    sta $d8c8,x
    sta $d8f0,x
    sta $d918,x
    sta $d940,x
    sta $d968,x
    sta $d990,x
    sta $d9b8,x
    sta $d9e0,x
    sta $da08,x
    sta $da30,x
    sta $da58,x
    sta $da80,x
    sta $daa8,x
    sta $dad0,x
    sta $daf8,x
    sta $db20,x
    sta $db48,x
    sta $db70,x
    sta $db98,x
    inx
    cpx #39
    bne gameBg_fill_foreground_2

    jsr gameBg_print
        
    ;---------fill top----------
    ldx #0
gameBg_fillTop:
    lda #102
    sta $428,x
    lda #103
    sta $429,x
    lda #104
    sta $42A,x
    inx
    inx
    inx
    cpx #39
    bne gameBg_fillTop
    lda #102
    sta $44f


    ;---------fill bottom-------
    ldx #0
    lda #102    
    sta $7E7
gameBg_fillBottom:
    lda #102
    sta $7C0,x
    lda #103
    sta $7C1,x
    lda #104
    sta $7C2,x
    inx
    inx
    inx
    cpx #39
    bne gameBg_fillBottom

    ;---------fill left--------
    lda #102    
    sta $450
    sta $478
    sta $4A0
    sta $4C8
    sta $4F0
    sta $518

    sta $6a8
    sta $6D0
    sta $6F8
    sta $720
    sta $748
    sta $770
    sta $798

    ;---------fill right---------
    sta $477
    sta $49f
    sta $4C7
    sta $4ef
    sta $517
    sta $53f

    sta $6cf
    sta $6F7
    sta $71F
    sta $747
    sta $76F
    sta $797
    sta $7BF

    jsr gameBg_setMulticolor
    
    ;-----------set el color and chars------------
    lda #11
    sta $d940
    sta $d968
    sta $d990
    sta $d9b8
    sta $d9e0
    sta $da08
    sta $da30
    sta $da58
    sta $da80
    sta $d967
    sta $d98f
    sta $d9b7
    sta $d9df
    sta $da07
    sta $da2f
    sta $da57
    sta $da7f
    sta $daa7

    lda #0
    sta gameElframeCount
    jsr gameBgEl

    ;jsr gameBg_printScore
    
    rts


gameBg_printScore:
    ;---------score------------
    lda #$13
    sta $400
    sta $41F
    lda #$03
    sta $401
    sta $420
    lda #$0F
    sta $402
    sta $421
    lda #$12
    sta $403
    sta $422
    lda #$05
    sta $404
    sta $423
    lda #$3A
    sta $405
    sta $424
    sta $40b
    sta $41b
    lda #32
    sta $406
    sta $407
    sta $408
    sta $425
    sta $426
    sta $427
    lda #23
    sta $40a
    sta $41a
    ;---------TIME-------------
    lda #$14
    sta $410
    lda #$9
    sta $411
    lda #$d
    sta $412
    lda #$5
    sta $413
    lda #$3A
    sta $414

    ;---------Set color------
    lda #1
    ldx #0
gameBg_printScoreColor:
    sta $d800,x
    inx
    cpx #40
    bne gameBg_printScoreColor

    lda #15
    sta $d806
    sta $d807
    sta $d808
    sta $d825
    sta $d826
    sta $d827
    sta $d815
    sta $d816
    sta $d817

    lda #11
    sta $d80c
    sta $d80d
    sta $d81c
    sta $d81d

    lda #2
    sta $d80f
    sta $d818
    rts



gameBg_init_bg:
    ldx #$0
    lda #32
gameBg_init_bg_clearing:
    sta $400,x
    sta $500,x
    sta $600,x
    sta $700,x
    inx
    bne gameBg_init_bg_clearing
    rts

gameBg_setMulticolor:
    ;----------------set ut multicolor charset
    lda $d018
    ora #$d
    sta $d018
    lda $d016
    ora #$10
    sta $d016

; Multicolor #1 = 01   d022
; Background    = 00   d021
; foreground    = 11   color ram
; Multicolor #2 = 10   d023

    lda #9    ;MULTICOLOR 1   Light grey
    sta $d022
    lda #8     ;MULTICOLOR 2   Light RED=2
    sta $d023
    rts


main_temp_pointer_2 = 8
;-----------------------Check for hit between BG and sprite----------------
gameBg_hit_1:
    lda #32
    ldy #0    
    sta (main_temp_pointer),y     ;Use the pointer we just created.
  
    lda main_temp_pointer  
    sta main_temp_pointer_2  
    lda main_temp_pointer+1       ;clear background color
    clc
    adc #$d4
    sta main_temp_pointer_2+1 
    lda #6
    sta (main_temp_pointer_2),y

    lda main_temp_pointer         ;On even addresses the brick to the right should be removed.
    and #1                                  
    bne gameBg_hit_1_Uneven       ;On uneven addresses the brick to the left should be removed.
    iny
    lda #32
    sta (main_temp_pointer),y
    lda #6
    sta (main_temp_pointer_2),y
    jmp gameBg_hit_1_score
gameBg_hit_1_Uneven:       
    lda main_temp_pointer         ;On even addresses the brick to the right should be removed.
    clc
    adc #$ff
    sta main_temp_pointer
    sta main_temp_pointer_2
    lda #32
    sta (main_temp_pointer),y     ;Use the pointer we just created.
    lda #6
    sta (main_temp_pointer_2),y

gameBg_hit_1_score:
    jsr gameBg_bricksLeft
    jsr gameBg_bricksLeft
    ldx main_temp_x               ;Give score!
    lda ball_owner,x
    cmp ball_player_1
    beq gameBg_hit_1_player_1
    cmp ball_player_2
    beq gameBg_hit_1_player_2
    rts
gameBg_hit_1_player_1:
    jsr score_increase_player_1
    rts
gameBg_hit_1_player_2:
    jsr score_increase_player_2
    rts


;---------------------Blocks that handle many hits-----------------------
gameBg_hit_2:
    ldy #0    
    clc
    adc #$fe
    cmp #$49
    bcs gameBg_hit_2_do          ;if A is equal or larger then  cmp
    jmp gameBg_hit_1
    
gameBg_hit_2_do
    sta (main_temp_pointer),y     ;Use the pointer we just created.
    pha                           ;PUSH stack Acc on the stack
    lda main_temp_pointer         ;On even addresses the brick to the right should be removed.
    and #1                                  
    bne gameBg_hit_2_Uneven       ;On uneven addresses the brick to the left should be removed.
    iny
    pla                          ;POP STACK
    clc
    adc #$1                      ;We have the value for left but we want to store for right
    sta (main_temp_pointer),y
    rts
gameBg_hit_2_Uneven:
    lda main_temp_pointer         ;On even addresses the brick to the right should be removed.
    clc
    adc #$ff
    sta main_temp_pointer
    pla 
    clc                           ;POP stack
    adc #$ff                      ;We have the value for right but we want to store for left
    sta (main_temp_pointer),y     ;Use the pointer we just created. 
    rts

;------------------------Hit with bonus blocks----------------------
gameBg_hit_bonus_1:
    pha                  ;Acc has the bricknumber x has the player
    ldx ball_current
    lda ball_owner,x
    tax
    pla
    jsr bonus_activate
 
    jmp gameBg_hit_1

;------------------------Electric animation-------------------------
gameBgEl:
    lda gameElframeCount
    bne gameBgElQuit 
    lda #10
    sta gameElframeCount
    lda gameElframeState
    bne gameElframeStateOne
    lda #1
    sta gameElframeState
    lda #96
    ldx #97
    jmp gameElframeStateCopy
gameElframeStateOne:
    lda #0
    sta gameElframeState
    lda #97
    ldx #96

gameElframeStateCopy:
   ; sta $518
    stx $540
    sta $568
    stx $590
    sta $5b8
    stx $5e0
    sta $608
    stx $630
    sta $658
    stx $680
   ; sta $6a8

   ; sta $53f
    stx $567
    sta $58f
    stx $5b7
    sta $5df
    stx $607
    sta $62f
    stx $657
    sta $67f
    stx $6a7
   ; stx $6cf

gameBgElQuit:
    dec gameElframeCount
    rts     

gameBg_bricksHi .byte 0
gameBg_bricksLo .byte 0

;---------------Decrease number of bricks-----------------
gameBg_bricksLeft:
    lda gameBg_bricksLo
    beq gameBg_bricksLeftHi
    dec gameBg_bricksLo
    rts
gameBg_bricksLeftHi:
    lda gameBg_bricksLeftHi
    beq gameBg_bricksLeftEnd  ;if 0 and 0 just end
    dec gameBg_bricksHi       ;
    lda #$ff
    sta gameBg_bricksLo

gameBg_bricksLeftEnd:
    rts

;-------------Check if all bricks consumed 1=game finished 0=game still on---------------
gameBg_empty:
    lda gameBg_bricksHi
    bne gameBg_empty_not
    lda gameBg_bricksLo
    bne gameBg_empty_not
    lda #1
    rts
gameBg_empty_not:
    lda #0
    rts


;------------------------------Background generator-------------------------
;ALL INDEX START AT 0, one INDEX = 1 char.
;
;0  = Blank
;1  = Undestructable
;2  = 1-brick color 1
;3  = 1-brick color 2
;4  = 3-brick color 1
;5  = 3-brick color 2
;6  = 6-brick color 1
;7  = 6-brick color 2
;10 = psycadelic 
;11 = your bat bigger
;12 = op bat smaller
;13 = op bat reversed
;14 = you get all balls
;15 = ....

                        ;    0    1    2    3    4    5    6    7    8    9    a    b   c   d  e  f   10  11  12
gamebg_field_color: .byte    0,  $6,   3,   5,   6,   7,   9,   8,   9,  $1,  13,  13, 13, 13, 13,13, 13, 13, 13
gamebg_field_char:  .byte  $20, $4e, $40, $40, $20, $40, $84, $40, $80, $82, $a0, $a2,$a4,$a6,$a8,$aa,$ac,$ae,$b0
gameBg_color: .byte 0
gameBg_char:  .byte 0
gamebg_field = 2
gamebg_screen = $450
gamebg_screen_color = $d850
gameBg_tmpX: .byte 0

gameBg_print:
    lda gameBg_level
    cmp #0
    beq gameBq_print_bashball
    cmp #1
    beq gameBq_print_iball
    cmp #2
    beq gameBq_print_tech

gameBq_print_bashball:
    lda gameBg_levelSub
    beq gameBq_print_bashball_0
    cmp #1
    beq gameBq_print_bashball_1
    cmp #2
    beq gameBq_print_bashball_2
gameBq_print_bashball_0:
    lda #<gamebg_field_bashball_0
    sta 2
    lda #>gamebg_field_bashball_0
    sta 3
    jmp gameBg_print_start
gameBq_print_bashball_1:
    lda #<gamebg_field_bashball_1
    sta 2
    lda #>gamebg_field_bashball_1
    sta 3
    jmp gameBg_print_start
gameBq_print_bashball_2:
    lda #<gamebg_field_bashball_2
    sta 2
    lda #>gamebg_field_bashball_2
    sta 3
    jmp gameBg_print_start

gameBq_print_tech:
    lda gameBg_levelSub
    beq gameBq_print_tech_0
    cmp #1
    beq gameBq_print_tech_1
    cmp #2
    beq gameBq_print_tech_2
gameBq_print_tech_0:
    lda #<gamebg_field_tech0
    sta 2
    lda #>gamebg_field_tech0
    sta 3
    jmp gameBg_print_start
gameBq_print_tech_1:
    lda #<gamebg_field_tech1
    sta 2
    lda #>gamebg_field_tech1
    sta 3
    jmp gameBg_print_start
gameBq_print_tech_2:
    lda #<gamebg_field_tech2
    sta 2
    lda #>gamebg_field_tech2
    sta 3
    jmp gameBg_print_start


gameBq_print_iball: 
    lda gameBg_levelSub
    beq gameBq_print_iball_0
    cmp #1
    beq gameBq_print_iball_1
    cmp #2
    beq gameBq_print_iball_2
gameBq_print_iball_0:       
    lda #<gamebg_field_iball
    sta 2
    lda #>gamebg_field_iball
    sta 3
    jmp gameBg_print_start
gameBq_print_iball_1:       
    lda #<gamebg_field_iball_1
    sta 2
    lda #>gamebg_field_iball_1
    sta 3
    jmp gameBg_print_start
gameBq_print_iball_2:       
    lda #<gamebg_field_iball_2
    sta 2
    lda #>gamebg_field_iball_2
    sta 3
    jmp gameBg_print_start


gameBg_print_start:
    ldy #0                    ;pick configuration
    ldx #0                    ;store on screen
    clc
gameBg_print_l1:
    lda (gamebg_field),y
    beq gameBg_print_l1_zero
    jsr gameBg_colorConvert
    jsr gameBg_charConvert
    lda gameBg_char
    sta gamebg_screen,x
    inx
    adc #1                    ;Get next char for the brick style.
    sta gamebg_screen,x
    lda gameBg_color
    sta gamebg_screen_color,x
    dex
    sta gamebg_screen_color,x
gameBg_print_l1_zero:
    inx
    iny
    inx
    bne gameBg_print_l1
gameBg_print2:
    ;sta 2
    ;ldy #0                    ;pick configuration
    ldx #0                    ;store on screen
    clc
gameBg_print_l2:
    lda (gamebg_field),y
    beq gameBg_print_l2_zero
    jsr gameBg_colorConvert
    jsr gameBg_charConvert
    lda gameBg_char
    sta gamebg_screen+256,x
    inx
    adc #1                    ;Get next char for the brick style.
    sta gamebg_screen+256,x
    lda gameBg_color
    sta gamebg_screen_color+256,x
    dex
    sta gamebg_screen_color+256,x
gameBg_print_l2_zero:
    inx
    iny
    inx
    bne gameBg_print_l2

gameBg_print3:
    lda 3
    adc #1
    sta 3
    ldy #0                    ;pick configuration
    ldx #0                    ;store on screen
    clc
gameBg_print_l3:
    lda (gamebg_field),y
    beq gameBg_print_l3_zero
    jsr gameBg_colorConvert
    jsr gameBg_charConvert
    lda gameBg_char
    sta gamebg_screen+512,x
    inx
    adc #1                    ;Get next char for the brick style.
    sta gamebg_screen+512,x
    lda gameBg_color
    sta gamebg_screen_color+512,x
    dex
    sta gamebg_screen_color+512,x
gameBg_print_l3_zero:
    inx
    iny
    inx
    bne gameBg_print_l3

gameBg_print4:
    ;lda 2
    ;adc #1
    ;sta 2
    ;ldy #0                    ;pick configuration
    ldx #0                    ;store on screen
    clc
gameBg_print_l4:
    lda (gamebg_field),y
    beq gameBg_print_l4_zero
    jsr gameBg_colorConvert
    jsr gameBg_charConvert
    lda gameBg_char
    sta gamebg_screen+768,x
    inx
    adc #1                    ;Get next char for the brick style.
    sta gamebg_screen+768,x
    lda gameBg_color
    sta gamebg_screen_color+768,x
    dex
    sta gamebg_screen_color+768,x
gameBg_print_l4_zero:
    inx
    iny
    inx
    cpx #112
    bne gameBg_print_l4

    rts

    

gameBg_charConvert:
    stx gameBg_tmpX
    tax
    pha
    lda gamebg_field_char,x
    sta gameBg_char
    pla
    ldx gameBg_tmpX
    rts

gameBg_colorConvert:
    stx gameBg_tmpX
    tax
    pha
    lda gamebg_field_color,x
    sta gameBg_color
    pla
    ldx gameBg_tmpX
    rts

;--------------------------Change background for this level-------------------------
gamebg_change:
    sta gameBg_levelSub
    jsr gameBg_print
    rts


 * = $3000
 .binary "resources/charsetBg.bin"


gamebg_field_tech0: .byte  $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0
                    .byte  $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0
                    .byte  $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0
                    .byte  $0, $0, $0, $0, $a, $b, $b, $b, $c, $0, $0, $11,$b, $b, $b, $f, $0, $0, $0, $0
                    .byte  $0, $0, $0, $0, $1, $5, $5, $5, $d, $3, $3, $12,$5, $5, $5, $1, $0, $0, $0, $0
                    .byte  $0, $0, $0, $0, $1, $5, $5, $5, $d, $3, $3, $12,$5, $5, $5, $1, $0, $0, $0, $0
                    .byte  $0, $0, $0, $0, $1, $5, $9, $5, $d, $3, $3, $12,$5, $9, $5, $1, $0, $0, $0, $0
                    .byte  $0, $0, $0, $0, $1, $5, $5, $5, $d, $3, $3, $12,$5, $5, $5, $1, $0, $0, $0, $0
                    .byte  $0, $0, $0, $0, $1, $5, $5, $5, $d, $3, $3, $12,$5, $5, $5, $1, $0, $0, $0, $0
                    .byte  $0, $0, $0, $0, $a, $b, $b, $b, $e, $3, $3, $10,$b, $b, $b, $f, $0, $0, $0, $0
                    .byte  $0, $0, $0, $0, $0, $0, $0, $0, $0, $3, $3, $0, $0, $0, $0, $0, $0, $0, $0, $0
                    .byte  $0, $0, $0, $0, $0, $0, $0, $0, $0, $1, $1, $0, $0, $0, $0, $0, $0, $0, $0, $0
                    .byte  $0, $0, $0, $0, $0, $0, $0, $0, $0, $3, $3, $0, $0, $0, $0, $0, $0, $0, $0, $0
                    .byte  $0, $0, $0, $0, $a, $b, $b, $b, $c, $3, $3, $11,$b, $b, $b, $f, $0, $0, $0, $0
                    .byte  $0, $0, $0, $0, $1, $5, $5, $5, $d, $3, $3, $12,$5, $5, $5, $1, $0, $0, $0, $0
                    .byte  $0, $0, $0, $0, $1, $5, $5, $5, $d, $3, $3, $12,$5, $5, $5, $1, $0, $0, $0, $0
                    .byte  $0, $0, $0, $0, $1, $5, $9, $5, $d, $3, $3, $12,$5, $9, $5, $1, $0, $0, $0, $0
                    .byte  $0, $0, $0, $0, $1, $5, $5, $5, $d, $3, $3, $12,$5, $5, $5, $1, $0, $0, $0, $0
                    .byte  $0, $0, $0, $0, $1, $5, $5, $5, $e, $3, $3, $12,$5, $5, $5, $1, $0, $0, $0, $0
                    .byte  $0, $0, $0, $0, $a, $b, $b, $b, $e, $0, $0, $10,$b, $b, $b, $f, $0, $0, $0, $0
                    .byte  $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0
                    .byte  $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0
                    .byte  $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0

gamebg_field_tech1: .byte  $0, $0, $0, $0, $0, $1, $4, $1, $4, $1, $4, $1, $4, $1, $4, $0, $0, $0, $0, $0
                    .byte  $0, $0, $0, $0, $0, $1, $4, $1, $4, $1, $4, $1, $4, $1, $4, $0, $0, $0, $0, $0
                    .byte  $0, $0, $0, $0, $0, $1, $4, $1, $4, $1, $4, $1, $4, $1, $4, $0, $0, $0, $0, $0
                    .byte  $0, $0, $0, $0, $4, $1, $4, $1, $4, $1, $4, $1, $4, $1, $4, $4, $0, $0, $0, $0
                    .byte  $0, $0, $0, $0, $4, $1, $4, $1, $4, $1, $4, $1, $4, $1, $4, $4, $0, $0, $0, $0
                    .byte  $0, $0, $0, $0, $d, $1, $4, $1, $4, $1, $4, $1, $4, $1, $4, $d, $0, $0, $0, $0
                    .byte  $0, $0, $0, $0, $d, $1, $4, $1, $4, $1, $4, $1, $4, $1, $4, $d, $0, $0, $0, $0
                    .byte  $0, $0, $0, $0, $d, $1, $4, $1, $4, $1, $4, $1, $4, $1, $4, $d, $0, $0, $0, $0
                    .byte  $0, $0, $0, $0, $d, $1, $4, $1, $4, $1, $4, $1, $4, $1, $4, $d, $0, $0, $0, $0
                    .byte  $0, $0, $0, $0, $d, $1, $4, $1, $4, $1, $4, $1, $4, $1, $4, $d, $0, $0, $0, $0
                    .byte  $0, $0, $0, $0, $d, $1, $4, $1, $4, $1, $4, $1, $4, $1, $4, $d, $0, $0, $0, $0
                    .byte  $0, $0, $0, $0, $d, $1, $4, $1, $4, $1, $4, $1, $4, $1, $4, $d, $0, $0, $0, $0
                    .byte  $0, $0, $0, $0, $d, $1, $4, $1, $4, $1, $4, $1, $4, $1, $4, $d, $0, $0, $0, $0
                    .byte  $0, $0, $0, $0, $d, $1, $4, $1, $4, $1, $4, $1, $4, $1, $4, $d, $0, $0, $0, $0
                    .byte  $0, $0, $0, $0, $d, $1, $4, $1, $4, $1, $4, $1, $4, $1, $4, $d, $0, $0, $0, $0
                    .byte  $0, $0, $0, $0, $d, $1, $4, $1, $4, $1, $4, $1, $4, $1, $4, $d, $0, $0, $0, $0
                    .byte  $0, $0, $0, $0, $d, $1, $4, $1, $4, $1, $4, $1, $4, $1, $4, $d, $0, $0, $0, $0
                    .byte  $0, $0, $0, $0, $d, $1, $4, $1, $4, $1, $4, $1, $4, $1, $4, $d, $0, $0, $0, $0
                    .byte  $0, $0, $0, $0, $d, $1, $4, $1, $4, $1, $4, $1, $4, $1, $4, $d, $0, $0, $0, $0
                    .byte  $0, $0, $0, $0, $4, $1, $4, $1, $4, $1, $4, $1, $4, $1, $4, $4, $0, $0, $0, $0
                    .byte  $0, $0, $0, $0, $0, $1, $4, $1, $4, $1, $4, $1, $4, $1, $4, $0, $0, $0, $0, $0
                    .byte  $0, $0, $0, $0, $0, $1, $4, $1, $4, $1, $4, $1, $4, $1, $4, $0, $0, $0, $0, $0
                    .byte  $0, $0, $0, $0, $0, $1, $4, $1, $4, $1, $4, $1, $4, $1, $4, $0, $0, $0, $0, $0

gamebg_field_tech2: .byte  $0, $0, $0, $0, $0, $4, $0, $4, $0, $4, $d, $4, $0, $4, $0, $0, $0, $0, $0, $0
                    .byte  $0, $0, $0, $0, $0, $4, $0, $4, $0, $4, $d, $4, $0, $4, $0, $0, $0, $0, $0, $0
                    .byte  $0, $0, $0, $0, $0, $4, $0, $4, $0, $4, $d, $4, $0, $4, $0, $0, $0, $0, $0, $0
                    .byte  $0, $0, $0, $0, $a, $b, $b, $b, $c, $4, $0, $11,$b, $b, $b, $f, $0, $0, $0, $0
                    .byte  $0, $0, $0, $0, $1, $5, $5, $5, $d, $3, $3, $12,$5, $5, $5, $1, $0, $0, $0, $0
                    .byte  $0, $0, $0, $0, $1, $5, $5, $5, $d, $3, $3, $12,$5, $5, $5, $1, $0, $0, $0, $0
                    .byte  $0, $0, $0, $0, $1, $5, $9, $5, $d, $3, $3, $12,$5, $9, $5, $1, $0, $0, $0, $0
                    .byte  $0, $0, $0, $0, $1, $5, $5, $5, $d, $3, $3, $12,$5, $5, $5, $1, $0, $0, $0, $0
                    .byte  $0, $0, $0, $0, $1, $5, $5, $5, $d, $3, $3, $12,$5, $5, $5, $1, $0, $0, $0, $0
                    .byte  $0, $0, $0, $0, $a, $b, $b, $b, $e, $3, $3, $10,$b, $b, $b, $f, $0, $0, $0, $0
                    .byte  $0, $0, $0, $0, $4, $4, $4, $4, $4, $3, $3, $4, $4, $4, $4, $4, $0, $0, $0, $0
                    .byte  $0, $0, $0, $0, $4, $4, $4, $4, $4, $1, $1, $4, $4, $4, $4, $4, $0, $0, $0, $0
                    .byte  $0, $0, $0, $0, $4, $4, $4, $4, $4, $3, $3, $4, $4, $4, $4, $4, $0, $0, $0, $0
                    .byte  $0, $0, $0, $0, $a, $b, $b, $b, $c, $3, $3, $11,$b, $b, $b, $f, $0, $0, $0, $0
                    .byte  $0, $0, $0, $0, $1, $5, $5, $5, $d, $3, $3, $12,$5, $5, $5, $1, $0, $0, $0, $0
                    .byte  $0, $0, $0, $0, $1, $5, $5, $5, $d, $3, $3, $12,$5, $5, $5, $1, $0, $0, $0, $0
                    .byte  $0, $0, $0, $0, $1, $5, $9, $5, $d, $3, $3, $12,$5, $9, $5, $1, $0, $0, $0, $0
                    .byte  $0, $0, $0, $0, $1, $5, $5, $5, $d, $3, $3, $12,$5, $5, $5, $1, $0, $0, $0, $0
                    .byte  $0, $0, $0, $0, $1, $5, $5, $5, $e, $3, $3, $12,$5, $5, $5, $1, $0, $0, $0, $0
                    .byte  $0, $0, $0, $0, $a, $b, $b, $b, $e, $4, $0, $10,$b, $b, $b, $f, $0, $0, $0, $0
                    .byte  $0, $0, $0, $0, $0, $4, $0, $4, $0, $4, $d, $4, $0, $4, $0, $0, $0, $0, $0, $0
                    .byte  $0, $0, $0, $0, $0, $4, $0, $4, $0, $4, $d, $4, $0, $4, $0, $0, $0, $0, $0, $0
                    .byte  $0, $0, $0, $0, $0, $4, $0, $4, $0, $4, $d, $4, $0, $4, $0, $0, $0, $0, $0, $0

gamebg_field_bashball_0: .byte 0,0,0,0,0,1,0,3,0,2,2,0,3,0,1,0,0,0,0,0
                         .byte 0,0,0,0,0,2,0,3,0,2,2,0,3,0,2,0,0,0,0,0
                         .byte 0,0,0,0,0,1,0,3,0,2,2,0,3,0,1,0,0,0,0,0
                         .byte 0,0,0,0,0,2,0,3,0,2,2,0,3,0,2,0,0,0,0,0
                         .byte 0,0,0,0,0,1,0,3,0,2,2,0,3,0,1,0,0,0,0,0
                         .byte 0,0,0,0,0,2,0,3,0,2,2,0,3,0,2,0,0,0,0,0
                         .byte 0,0,0,0,0,1,0,3,0,2,2,0,3,0,1,0,0,0,0,0
                         .byte 0,0,0,0,0,2,0,3,0,2,2,0,3,0,2,0,0,0,0,0
                         .byte 0,0,0,0,0,1,0,3,0,2,2,0,3,0,1,0,0,0,0,0
                         .byte 0,0,0,0,0,2,0,3,0,2,2,0,3,0,2,0,0,0,0,0
                         .byte 0,0,0,0,0,1,0,3,0,2,2,0,3,0,1,0,0,0,0,0
                         .byte 0,0,0,0,0,2,0,3,0,2,2,0,3,0,2,0,0,0,0,0
                         .byte 0,0,0,0,0,1,0,3,0,2,2,0,3,0,1,0,0,0,0,0
                         .byte 0,0,0,0,0,2,0,3,0,2,2,0,3,0,2,0,0,0,0,0
                         .byte 0,0,0,0,0,1,0,3,0,2,2,0,3,0,1,0,0,0,0,0
                         .byte 0,0,0,0,0,2,0,3,0,2,2,0,3,0,2,0,0,0,0,0
                         .byte 0,0,0,0,0,1,0,3,0,2,2,0,3,0,1,0,0,0,0,0
                         .byte 0,0,0,0,0,2,0,3,0,2,2,0,3,0,2,0,0,0,0,0
                         .byte 0,0,0,0,0,1,0,3,0,2,2,0,3,0,1,0,0,0,0,0
                         .byte 0,0,0,0,0,2,0,3,0,2,2,0,3,0,2,0,0,0,0,0
                         .byte 0,0,0,0,0,1,0,3,0,2,2,0,3,0,1,0,0,0,0,0
                         .byte 0,0,0,0,0,2,0,3,0,2,2,0,3,0,2,0,0,0,0,0
                         .byte 0,0,0,0,0,1,0,3,0,2,2,0,3,0,1,0,0,0,0,0

gamebg_field_bashball_1: .byte 0,0,0,0,0,1,0,3,0,2,2,0,3,0,1,0,0,0,0,0
                         .byte 0,0,0,0,0,1,0,3,0,2,2,0,3,0,1,0,0,0,0,0
                         .byte 0,0,0,1,0,2,0,3,0,2,2,0,3,0,2,0,1,0,0,0
                         .byte 0,0,0,1,0,2,0,3,0,2,2,0,3,0,2,0,1,0,0,0
                         .byte 0,0,0,0,0,2,0,3,0,2,2,0,3,0,2,0,0,0,0,0
                         .byte 0,0,0,0,0,2,0,3,0,2,2,0,3,0,2,0,0,0,0,0
                         .byte 0,0,0,0,0,1,0,3,0,2,2,0,3,0,1,0,0,0,0,0
                         .byte 0,0,0,0,0,1,0,3,0,2,2,0,3,0,1,0,0,0,0,0
                         .byte 0,0,0,0,0,1,0,3,0,2,2,0,3,0,1,0,0,0,0,0
                         .byte 0,0,0,0,0,1,0,3,0,2,2,0,3,0,1,0,0,0,0,0
                         .byte 0,0,0,0,0,1,0,3,0,2,2,0,3,0,1,0,0,0,0,0
                         .byte 0,0,0,0,0,1,0,3,0,2,2,0,3,0,1,0,0,0,0,0
                         .byte 0,0,0,0,0,1,0,3,0,2,2,0,3,0,1,0,0,0,0,0
                         .byte 0,0,0,0,0,1,0,3,0,2,2,0,3,0,1,0,0,0,0,0
                         .byte 0,0,0,0,0,1,0,3,0,2,2,0,3,0,1,0,0,0,0,0
                         .byte 0,0,0,0,0,1,0,3,0,2,2,0,3,0,1,0,0,0,0,0
                         .byte 0,0,0,0,0,1,0,3,0,2,2,0,3,0,1,0,0,0,0,0
                         .byte 0,0,0,0,0,1,0,3,0,2,2,0,3,0,1,0,0,0,0,0
                         .byte 0,0,0,0,0,1,0,3,0,2,2,0,3,0,1,0,0,0,0,0
                         .byte 0,0,0,0,0,1,0,3,0,2,2,0,3,0,1,0,0,0,0,0
                         .byte 0,0,0,0,0,1,0,3,0,2,2,0,3,0,1,0,0,0,0,0
                         .byte 0,0,0,0,0,1,0,3,0,2,2,0,3,0,1,0,0,0,0,0
                         .byte 0,0,0,0,0,1,0,3,0,2,2,0,3,0,1,0,0,0,0,0

gamebg_field_bashball_2: .byte 0,0,0,0,0,1,0,3,0,2,2,0,3,0,1,0,0,0,0,0
                         .byte 0,0,0,0,0,1,0,3,0,2,2,0,3,0,1,0,0,0,0,0
                         .byte 0,0,0,0,0,1,0,3,0,2,2,0,3,0,1,0,0,0,0,0
                         .byte 0,0,0,0,0,1,0,3,0,2,2,0,3,0,1,0,0,0,0,0
                         .byte 0,0,0,0,0,1,0,3,0,2,2,0,3,0,1,0,0,0,0,0
                         .byte 0,0,0,0,0,1,0,3,0,2,2,0,3,0,1,0,0,0,0,0
                         .byte 0,0,0,0,0,1,0,3,0,2,2,0,3,0,1,0,0,0,0,0
                         .byte 0,0,0,0,0,1,0,3,0,2,2,0,3,0,1,0,0,0,0,0
                         .byte 0,0,0,0,0,1,0,3,0,2,2,0,3,0,1,0,0,0,0,0
                         .byte 0,0,0,0,0,1,0,3,0,2,2,0,3,0,1,0,0,0,0,0
                         .byte 0,0,0,0,0,1,0,3,0,2,2,0,3,0,1,0,0,0,0,0
                         .byte 0,0,0,0,0,1,0,3,0,2,2,0,3,0,1,0,0,0,0,0
                         .byte 0,0,0,0,0,1,0,3,0,2,2,0,3,0,1,0,0,0,0,0
                         .byte 0,0,0,0,0,1,0,3,0,2,2,0,3,0,1,0,0,0,0,0
                         .byte 0,0,0,0,0,1,0,3,0,2,2,0,3,0,1,0,0,0,0,0
                         .byte 0,0,0,0,0,1,0,3,0,2,2,0,3,0,1,0,0,0,0,0
                         .byte 0,0,0,0,0,1,0,3,0,2,2,0,3,0,1,0,0,0,0,0
                         .byte 0,0,0,0,0,1,0,3,0,2,2,0,3,0,1,0,0,0,0,0
                         .byte 0,0,0,0,0,1,0,3,0,2,2,0,3,0,1,0,0,0,0,0
                         .byte 0,0,0,0,0,1,0,3,0,2,2,0,3,0,1,0,0,0,0,0
                         .byte 0,0,0,0,0,1,0,3,0,2,2,0,3,0,1,0,0,0,0,0
                         .byte 0,0,0,0,0,1,0,3,0,2,2,0,3,0,1,0,0,0,0,0
                         .byte 0,0,0,0,0,1,0,3,0,2,2,0,3,0,1,0,0,0,0,0

gamebg_field_iball:  .byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
                     .byte 0,0,0,0,0,0,0,0,0,5,5,0,0,0,0,0,0,0,0,0
                     .byte 0,0,0,0,0,0,0,0,5,5,5,5,0,0,0,0,0,0,0,0
                     .byte 0,0,0,0,0,0,0,5,5,5,5,5,5,0,0,0,0,0,0,0
                     .byte 0,0,0,0,0,0,0,5,5,5,5,5,5,0,0,0,0,0,0,0
                     .byte 0,0,0,0,0,0,5,5,5,5,5,5,5,5,0,0,0,0,0,0
                     .byte 0,0,0,0,0,0,5,1,1,5,5,1,1,5,0,0,0,0,0,0
                     .byte 0,0,0,0,0,0,5,1,1,5,5,1,1,5,0,0,0,0,0,0
                     .byte 0,0,0,0,0,5,5,1,1,5,5,1,1,5,6,0,0,0,0,0
                     .byte 0,0,0,0,0,5,5,1,9,5,5,9,1,5,5,0,0,0,0,0
                     .byte 0,0,0,0,0,5,5,5,5,5,5,5,5,5,5,0,0,0,0,0
                     .byte 0,0,0,0,0,5,5,5,5,5,5,5,5,5,5,0,0,0,0,0
                     .byte 0,0,0,0,0,5,5,5,5,5,5,5,5,5,5,0,0,0,0,0
                     .byte 0,0,0,0,0,5,5,1,5,5,5,5,1,5,5,0,0,0,0,0
                     .byte 0,0,0,0,0,0,5,1,5,5,5,5,1,5,0,0,0,0,0,0
                     .byte 0,0,0,0,0,0,5,5,1,5,5,1,5,5,0,0,0,0,0,0
                     .byte 0,0,0,0,0,0,5,5,5,1,1,5,5,5,0,0,0,0,0,0
                     .byte 0,0,0,0,0,0,0,5,5,5,5,5,5,0,0,0,0,0,0,0
                     .byte 0,0,0,0,0,0,0,5,5,5,5,5,5,0,0,0,0,0,0,0
                     .byte 0,0,0,0,0,0,0,0,5,5,5,5,0,0,0,0,0,0,0,0
                     .byte 0,0,0,0,0,0,0,0,0,5,5,0,0,0,0,0,0,0,0,0
                     .byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
                     .byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

gamebg_field_iball_1:.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
                     .byte 0,0,0,0,0,0,0,0,0,5,5,0,0,0,0,0,0,0,0,0
                     .byte 0,0,0,0,0,0,0,0,5,5,5,5,0,0,0,0,0,0,0,0
                     .byte 0,0,0,0,0,0,0,5,5,5,5,5,5,0,0,0,0,0,0,0
                     .byte 0,0,0,0,0,0,0,5,5,5,1,1,5,0,0,0,0,0,0,0
                     .byte 0,0,0,0,0,0,5,5,5,5,1,1,5,5,0,0,0,0,0,0
                     .byte 0,0,0,0,0,0,5,5,5,5,1,8,5,5,0,0,0,0,0,0
                     .byte 0,0,0,0,0,5,5,5,5,5,5,5,5,1,0,0,0,0,0,0
                     .byte 0,0,0,0,0,0,5,5,5,5,5,5,1,1,0,0,0,0,0,0
                     .byte 0,0,0,0,0,5,5,5,5,5,5,1,1,1,0,0,0,0,0,0
                     .byte 0,0,0,0,0,5,5,5,5,5,1,1,1,1,0,0,0,0,0,0
                     .byte 0,0,0,0,0,5,5,5,5,1,1,1,1,1,0,0,0,0,0,0
                     .byte 0,0,0,0,0,5,5,5,5,5,1,1,1,1,0,0,0,0,0,0
                     .byte 0,0,0,0,0,5,5,5,5,5,5,1,1,1,0,0,0,0,0,0
                     .byte 0,0,0,0,0,0,5,5,5,5,5,5,5,1,0,0,0,0,0,0
                     .byte 0,0,0,0,0,0,5,5,5,5,5,5,5,5,0,0,0,0,0,0
                     .byte 0,0,0,0,0,0,5,5,5,5,5,5,5,5,0,0,0,0,0,0
                     .byte 0,0,0,0,0,0,0,5,5,5,5,5,5,0,0,0,0,0,0,0
                     .byte 0,0,0,0,0,0,0,5,5,5,5,5,5,0,0,0,0,0,0,0
                     .byte 0,0,0,0,0,0,0,0,5,5,5,5,0,0,0,0,0,0,0,0
                     .byte 0,0,0,0,0,0,0,0,0,5,5,0,0,0,0,0,0,0,0,0
                     .byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
                     .byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

gamebg_field_iball_2:.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
                     .byte 0,0,0,0,0,0,0,0,0,5,5,0,0,0,0,0,0,0,0,0
                     .byte 0,0,0,0,0,0,0,0,5,5,5,5,0,0,0,0,0,0,0,0
                     .byte 0,0,0,0,0,0,0,5,5,5,5,5,5,0,0,0,0,0,0,0
                     .byte 0,0,0,0,0,0,0,5,5,5,5,5,5,0,0,0,0,0,0,0
                     .byte 0,0,0,0,0,0,5,5,5,5,5,5,5,5,0,0,0,0,0,0
                     .byte 0,0,0,0,0,0,5,5,5,5,5,5,5,5,0,0,0,0,0,0
                     .byte 0,0,0,0,0,0,5,5,5,5,5,5,5,5,0,0,0,0,0,0
                     .byte 0,0,0,0,0,5,5,5,5,5,5,5,5,5,5,0,0,0,0,0
                     .byte 0,0,0,0,0,5,5,5,5,5,5,5,5,5,5,0,0,0,0,0
                     .byte 0,0,0,0,0,5,5,5,5,5,5,5,5,5,5,0,0,0,0,0
                     .byte 0,0,0,0,0,5,5,5,5,5,5,5,5,5,5,0,0,0,0,0
                     .byte 0,0,0,0,0,5,5,5,5,5,5,5,5,5,5,0,0,0,0,0
                     .byte 0,0,0,0,0,5,5,5,5,5,5,5,5,5,5,0,0,0,0,0
                     .byte 0,0,0,0,0,0,5,5,5,5,5,5,5,5,0,0,0,0,0,0
                     .byte 0,0,0,0,0,0,5,5,5,5,5,5,5,5,0,0,0,0,0,0
                     .byte 0,0,0,0,0,0,5,5,5,5,5,5,5,5,0,0,0,0,0,0
                     .byte 0,0,0,0,0,0,0,5,5,5,5,5,5,0,0,0,0,0,0,0
                     .byte 0,0,0,0,0,0,0,5,5,5,5,5,5,0,0,0,0,0,0,0
                     .byte 0,0,0,0,0,0,0,0,5,5,5,5,0,0,0,0,0,0,0,0
                     .byte 0,0,0,0,0,0,0,0,0,5,5,0,0,0,0,0,0,0,0,0
                     .byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
                     .byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0


