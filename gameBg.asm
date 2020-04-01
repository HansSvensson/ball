gameElframeCount .byte 0
gameElframeState .byte 0
gameBg_level .byte 0
gameBg_levelSub .byte 0
gameBg_init:
    
    lda #0
    sta gameBg_levelSub
    jsr gameBg_init_bg

    ;----------fill fg color-------
    lda #11     ;FOREGROUND COLOR
    ldx #0
gameBg_fill_foreground:
    sta $d800,x
    sta $d900,x
    sta $da00,x
    sta $db00,x
    inx
    bne gameBg_fill_foreground

    lda #6    ;FOREGROUND COLOR
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
    ;lda #103
    sta $429,x
    ;lda #104
    sta $42A,x
    inx
    inx
    inx
    cpx #39
    bne gameBg_fillTop
    lda #102
    sta $44f

    lda #103
    sta $428
    lda #104
    sta $44f

    ;---------fill bottom-------
    ldx #0
    lda #102    
    sta $7E7
gameBg_fillBottom:
    lda #102
    sta $7C0,x
    ;lda #103
    sta $7C1,x
    ;lda #104
    sta $7C2,x
    inx
    inx
    inx
    cpx #39
    bne gameBg_fillBottom

    ;---------Add Wall---------
    lda #105
    sta $7d2
    lda #106
    sta $7d3
    lda #107
    sta $7d4
    lda #108
    sta $7d5
    lda #9
    sta $dbd2
    sta $dbd3
    sta $dbd4
    sta $dbd5
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
    
    lda #100
    sta $7c0
    lda #101
    sta $7e7

    ;jsr gameBg_setMulticolor
    
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
    sta $41e
    lda #$03
    sta $401
    sta $41f
    lda #$0F
    sta $402
    sta $420
    lda #$12
    sta $403
    sta $421
    lda #$05
    sta $404
    sta $422
    lda #$3A
    sta $405
    sta $423
    sta $40c
    sta $41a
    lda #35
    sta $406
    sta $407
    sta $408
    sta $425
    sta $426
    sta $427
    lda #23
    sta $40b
    sta $419
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

    lda #7
    sta $d806
    sta $d807
    sta $d808
    sta $d809
    sta $d824
    sta $d825
    sta $d826
    sta $d827
    sta $d814
    sta $d815
    sta $d816
    sta $d817

    lda #3
    sta $d80d
    sta $d80e
    sta $d81b
    sta $d81c
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

;----------------
gameBg_getOwner:
    lda bullet_owner
    cmp ball_player_none
    bne gameBg_getOwner_end
    ldx main_temp_x
    lda ball_owner,x    
gameBg_getOwner_end:    
    rts
;----------------

main_temp_pointer_2 = 8
;------------Check for hit between BG and sprite, returnes 0=no owner, 1=hit----------------
gameBg_hit_1:
    bne gameBg_hit_1_c
    jsr gameBg_getOwner
    cmp ball_player_none
    bne gameBg_hit_1_c
    lda #0
    rts
gameBg_hit_1_c:
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

gameBg_hit_1_score:
    jsr sound_playBrick
    jsr gameBg_bricksLeft
    jsr gameBg_bricksLeft
    jsr gameBg_getOwner
    cmp ball_player_1
    beq gameBg_hit_1_player_1
    cmp ball_player_2
    beq gameBg_hit_1_player_2
    lda #1
    rts
gameBg_hit_1_player_1:
    jsr score_increase_player_1
    lda #1
    rts
gameBg_hit_1_player_2:
    jsr score_increase_player_2
    lda #1
    rts


;---------------------Blocks that handle many hits-----------------------
gameBg_hit_2:
    pha
    tya
    pha
    ldx main_temp_x               ;If no player ownes the ball quit
    lda ball_owner,x
    cmp ball_player_none
    bne gameBg_hit_2_c
    pla
    pla
    lda #0
    rts

gameBg_hit_2_c:
    pla
    tay
    pla
    ldy #0    
    clc
    adc #$fe
    cmp #$4a                     ;How hard a brick should be
    bcs gameBg_hit_2_do          ;if A is equal or larger then  cmp
    jmp gameBg_hit_1
    
gameBg_hit_2_do
 ;   clc
 ;   adc #$1                      ;We have the value for left but we want to store for right
    sta (main_temp_pointer),y
    lda #1
    rts

;------------------------Hit with bonus blocks----------------------
gameBg_hit_bonus_1:
    pha                  ;Acc has the bricknumber x has the player
    ;ldx ball_current
    ;lda ball_owner,x
    jsr gameBg_getOwner
    cmp ball_player_none
    beq gameBg_hit_bonus_1_end
    tax
    pla
    jsr bonus_activate
    jmp gameBg_hit_1
 gameBg_hit_bonus_1_end:
    pla
    tax
    rts
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
;gamebg_dubble_brick:.byte    0,   0,   0,   0,   1,   0,   0,   0,   0,   0,   0,   0,   1,   1,   1,   0,   2,   2,   2
;gamebg_field_color: .byte    0,  $2,   3,   5,   6,   7,   9,   8,   9,  $9,  15,  15,  15,  15,  15,  15,  15,  15,  15
;gamebg_field_char:  .byte  $20, $4e, $40, $40, $20, $40, $84, $40, $80, $82, $a0, $a2, $a4, $a6, $a8, $aa, $ad, $af, $b1



;first set 0x02 - 0x11
;second    0x12 - 0x21
; third    0x12 - 0x31
;                                        NORMAL BRICKS SET 1                                                                NORMAL BRICKS SET 2                                                                NORMAL BRICKS SET 3                                                           
;                          ++++++++      -------------------------------------------------------------------------------    ------------------------------------------------------------------------------     -------------------------------------------------------------------------------
                        ;    0    1        2    3   4    5    6    7    8    9    A    B    C    D    E    F   10   11       12   13   14   15   16   17   18   19   1a   1b   1c   1d   1e   1f   20   21       22   23   24   25   26   27   28   29   2a   2b   2c   2d   2e   2f   30   31                         
gamebg_dubble_brick:.byte    0,   1,       0,   0,  0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,       0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,       0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0      
gamebg_field_color: .byte    0,   6,       0,   1,  2,   3,   4,   5,   6,   7,   8,   9,  $a,  $b,  $c,  $d,  $e,  $f,       0,   1,   2,   3,   4,   5,   6,   7,   8,   9,  $a,  $b,  $c,  $d,  $e,  $f,       0,   1,   2,   3,   4,   5,   6,   7,   8,   9,  $a,  $b,  $c,  $d,  $e,  $f      
gamebg_field_char:  .byte  $20, $20,     $C0, $C1,$C2, $C3, $C4, $C5, $C6, $C7, $C8, $C9, $Ca, $Cb, $Cc, $Cd, $Ce, $Cf,     $d0, $d1, $d2, $d3, $d4, $d5, $d6, $d7, $d8, $d9, $da, $db, $dc, $dd, $de, $df,     $e0, $e1, $e2, $e3, $e4, $e5, $e6, $e7, $e8, $e9, $ea, $eb, $ec, $ed, $ee, $ef      

;C64 färger:              CHARS
;-----------              -----
;0 = svart                20 = Tom
;1 = vit                  4e = hård bricka
;2 = röd                  80 = bonus smaller
;3 = ljus blå             82 = bonus bigger
;4 = rosa                 84 = own all
;5 = grön                 86 = bullets
;6 = bakgrunds blå        88 = unstoppable
;7 = gul


;Brickor nr in table
;-------------------
;
;2  -> vit               
;3  -> ljus blå   
;4  -> rosa
;5  -> grön
;6  -> gul
; NEW COLORS!!!
;7 -> vit 2
;8 -> ljus blå 2
;9 -> rosa

;Hårda Brickor nr in table
;-------------------------
;12 -> röda

;Bonusar
;--------
;16 -> oposition smaller
;17 -> own bigger
;15 -> get all balls

gameBg_redPaintColors_2  = 0
gameBg_redPaintColors_3  = 1
gameBg_redPaintColors_4  = 2
gameBg_redPaintColors_5  = 3
gameBg_redPaintColors_6  = 4
gameBg_redPaintColors_7  = 5
gameBg_redPaintColors_12 = 6
gameBg_redPaintColors_8  = 7
gameBg_redPaintColors_9  = 8
gameBg_redPaintColors_10 = 9
                           ;2 3 4 5 6 7 12  8 9 10
gameBg_redPaintColors .byte 0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0

gameBg_color:  .byte 0
gameBg_color_2:.byte 0
gameBg_char:   .byte 0
gameBg_char_2: .byte 0
gamebg_field = 2
gamebg_screen = $450
gamebg_screen_color = $d850
gameBg_tmpX: .byte 0
gameBg_activeBg: .byte 0,0
gamebg_colorCounterPnt: .byte 0,0

gameBg_print:
    lda gameBg_level
    cmp #0
    beq gameBq_print_bashball
    cmp #1
    beq gameBq_print_iball
    cmp #2
    beq gameBq_print_ball2
    cmp #3
    beq gameBq_print_ball3

gameBq_print_bashball:
    lda gameBg_levelSub
    beq gameBq_print_bashball_1
    cmp #1
    beq gameBq_print_bashball_1
gameBq_print_bashball_1:
    lda #<gamebg_field_bashball_1
    sta 2
    lda #>gamebg_field_bashball_1
    sta 3
    lda gamebg_field_bashball_1_bonus
    sta bonus_insert_pos
    lda gamebg_field_bashball_1_bonus+1
    sta bonus_insert_pos+1
    lda gamebg_field_bashball_1_bonus+2
    sta bonus_insert_pos+2
    lda gamebg_field_bashball_1_bonus+3
    sta bonus_insert_pos+3

    jmp gameBg_print_start

gameBq_print_tech:
;    lda gameBg_levelSub
;    beq gameBq_print_tech_0
;    cmp #1
;    beq gameBq_print_tech_1
;    cmp #2
;    beq gameBq_print_tech_2
gameBq_print_tech_0:
    lda #<gamebg_field_bashball_1
    sta 2
    lda #>gamebg_field_bashball_1
    sta 3
    lda gamebg_field_bashball_1_bonus
    sta bonus_insert_pos
    lda gamebg_field_bashball_1_bonus+1
    sta bonus_insert_pos+1
    lda gamebg_field_bashball_1_bonus+2
    sta bonus_insert_pos+2
    lda gamebg_field_bashball_1_bonus+3
    sta bonus_insert_pos+3
    jmp gameBg_print_start
;gameBq_print_tech_1:
;    lda #<gamebg_field_tech1
;    sta 2
;    lda #>gamebg_field_tech1
;    sta 3
;    lda gamebg_field_tech1_bonus
;    sta bonus_insert_pos
;    lda gamebg_field_tech1_bonus+1
;    sta bonus_insert_pos+1
;    lda gamebg_field_tech1_bonus+2
;    sta bonus_insert_pos+2
;    lda gamebg_field_tech1_bonus+3
;    sta bonus_insert_pos+3
;    jmp gameBg_print_start
;gameBq_print_tech_2:
;    lda #<gamebg_field_tech2
;    sta 2
;    lda #>gamebg_field_tech2
;    sta 3
;    lda gamebg_field_tech2_bonus
;    sta bonus_insert_pos
;    lda gamebg_field_tech2_bonus+1
;    sta bonus_insert_pos+1
;    lda gamebg_field_tech2_bonus+2
;    sta bonus_insert_pos+2
;    lda gamebg_field_tech2_bonus+3
;    sta bonus_insert_pos+3
;    jmp gameBg_print_start


gameBq_print_iball: 
    lda #<gamebg_field_iball
    sta 2
    lda #>gamebg_field_iball
    sta 3
    lda gamebg_field_iball_bonus
    sta bonus_insert_pos
    lda gamebg_field_iball_bonus+1
    sta bonus_insert_pos+1
    lda gamebg_field_iball_bonus+2
    sta bonus_insert_pos+2
    lda gamebg_field_iball_bonus+3
    sta bonus_insert_pos+3
    jmp gameBg_print_start

gameBq_print_ball2: 
    lda #<gamebg_field_ball2
    sta 2
    lda #>gamebg_field_ball2
    sta 3
    lda gamebg_field_ball2_bonus
    sta bonus_insert_pos
    lda gamebg_field_ball2_bonus+1
    sta bonus_insert_pos+1
    lda gamebg_field_ball2_bonus+2
    sta bonus_insert_pos+2
    lda gamebg_field_ball2_bonus+3
    sta bonus_insert_pos+3
    jmp gameBg_print_start

gameBq_print_ball3: 
    lda #<gamebg_field_ball3
    sta 2
    lda #>gamebg_field_ball3
    sta 3
    lda gamebg_field_ball3_bonus
    sta bonus_insert_pos
    lda gamebg_field_ball3_bonus+1
    sta bonus_insert_pos+1
    lda gamebg_field_ball3_bonus+2
    sta bonus_insert_pos+2
    lda gamebg_field_ball3_bonus+3
    sta bonus_insert_pos+3
    jmp gameBg_print_start


gameBg_print_start:
    lda 2
    sta gameBg_activeBg
    lda 3
    sta gameBg_activeBg+1
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
    lda gameBg_color
    sta gamebg_screen_color,x
gameBg_print_l1_zero:
    iny
    inx
    bne gameBg_print_l1
gameBg_print2:
    clc
    lda 3
    adc #1
    sta 3
    ldx #0                    ;store on screen
    ldy #0                    ;store on screen
gameBg_print_l2:
    lda (gamebg_field),y
    beq gameBg_print_l2_zero
    jsr gameBg_colorConvert
    jsr gameBg_charConvert
    lda gameBg_char
    sta gamebg_screen+256,x
    lda gameBg_color
    sta gamebg_screen_color+256,x
gameBg_print_l2_zero:
    iny
    inx
    bne gameBg_print_l2

gameBg_print3:
    clc
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
    lda gameBg_color
    sta gamebg_screen_color+512,x
gameBg_print_l3_zero:
    iny
    inx
    bne gameBg_print_l3

gameBg_print4:
    clc
    lda 3
    adc #1
    sta 3
    ldy #0                    ;pick configuration
    ldx #0                    ;store on screen
    clc
gameBg_print_l4:
    lda (gamebg_field),y
    beq gameBg_print_l4_zero
    jsr gameBg_colorConvert
    jsr gameBg_charConvert
    lda gameBg_char
    sta gamebg_screen+768,x
    lda gameBg_color
    sta gamebg_screen_color+768,x
gameBg_print_l4_zero:
    iny
    inx
    cpx #112
    bne gameBg_print_l4

    ;---------copy counters-----------
gameBg_createPnt:    
    lda gamebg_field+1               ;get the pointer to the counters
    sta gamebg_colorCounterPnt+1
    lda gamebg_field
    sta gamebg_colorCounterPnt
    tya
    adc gamebg_colorCounterPnt
    sta gamebg_colorCounterPnt
    lda #0
    adc gamebg_colorCounterPnt+1
    sta gamebg_colorCounterPnt+1
    clc
    
    ldx #0
    ;ldy #0
gameBg_print_copyCounter:
    lda (gamebg_field),y
    sta gameBg_redPaintColors,x
    inx
    iny
    cpx #48
    bne gameBg_print_copyCounter
    rts

    

gameBg_charConvert:
    stx gameBg_tmpX
    tax
    pha
    lda gamebg_dubble_brick,x
    beq gameBg_charConvert_double        ;True double brick
    cmp #1
    beq gameBg_charConvert_single_left   ;Single brick empty right side

    lda #32                                     ;Signle brick empty left side
    sta gameBg_char    
    lda gamebg_field_char,x
    sta gameBg_char_2
    jmp gameBg_charConver_end

gameBg_charConvert_single_left:
    lda #32                                     ;Signle brick empty left side
    sta gameBg_char_2    
    lda gamebg_field_char,x
    sta gameBg_char
    jmp gameBg_charConver_end
    
gameBg_charConvert_double:
    lda gamebg_field_char,x
    sta gameBg_char
    clc
    adc #1
    sta gameBg_char_2
   
gameBg_charConver_end:
    pla
    ldx gameBg_tmpX
    rts



gameBg_colorConvert:
    stx gameBg_tmpX
    tax
    pha

    lda gamebg_dubble_brick,x
    beq gameBg_colorConvert_double        ;True double brick
    cmp #1
    beq gameBg_colorConvert_single_left   ;Single brick empty right side
    
    ;Signle brick empty left side
    lda #6
    sta gameBg_color
    lda gamebg_field_color,x
    sta gameBg_color_2
    jmp gameBg_colorConver_end

gameBg_colorConvert_single_left:
    lda #6
    sta gameBg_color_2
    lda gamebg_field_color,x
    sta gameBg_color
    jmp gameBg_colorConver_end

gameBg_colorConvert_double:
    lda gamebg_field_color,x
    sta gameBg_color
    sta gameBg_color_2

gameBg_colorConver_end:
    pla
    ldx gameBg_tmpX
    rts



;------------Draw single color block--------------
;y = pekare matris
;x = pekare minne
;gameBg_colorRePaint = color to repaint
gameBg_colorRePaint: .byte 0

gameBg_drawSingleColor:

    jsr sound_playBricksReappear
    ;----test-----

    lda gameBg_activeBg
    sta 2
    lda gameBg_activeBg+1
    sta 3
    
    clc
    ldy #0
    ldx #0
gameBg_drawSingleColor1:
    lda (2),y
    cmp gameBg_colorRePaint
    bne gameBg_drawSingleColor1_cont
    jsr gameBg_colorConvert
    jsr gameBg_charConvert
    lda gameBg_char
    sta gamebg_screen+0,x
    lda gameBg_color
    sta gamebg_screen_color+0,x    
gameBg_drawSingleColor1_cont:
    iny
    inx
    bne gameBg_drawSingleColor1

    clc
    lda 3
    adc #1
    sta 3
    ldy #0
    ldx #0
    clc
gameBg_drawSingleColor2:
    lda (2),y
    cmp gameBg_colorRePaint
    bne gameBg_drawSingleColor2_cont
    jsr gameBg_colorConvert
    jsr gameBg_charConvert
    lda gameBg_char
    sta gamebg_screen+256,x
    lda gameBg_color
    sta gamebg_screen_color+256,x    
gameBg_drawSingleColor2_cont:
    iny
    inx
    bne gameBg_drawSingleColor2

    clc
    lda 3
    adc #1
    sta 3
    ldy #0                    ;pick configuration
    ldx #0                    ;store on screen
    clc
gameBg_drawSingleColor3_loop:
    lda (2),y
    cmp gameBg_colorRePaint
    bne gameBg_drawSingleColor3_cont
    jsr gameBg_colorConvert
    jsr gameBg_charConvert
    lda gameBg_char
    sta gamebg_screen+512,x
    lda gameBg_color
    sta gamebg_screen_color+512,x    
gameBg_drawSingleColor3_cont:
    iny
    inx
    bne gameBg_drawSingleColor3_loop

    clc
    lda 3
    adc #1
    sta 3
    ldy #0                    ;pick configuration
    ldx #0                    ;store on screen
    clc
gameBg_drawSingleColor4:
    lda (2),y
    cmp gameBg_colorRePaint
    bne gameBg_drawSingleColor4_cont
    jsr gameBg_colorConvert
    jsr gameBg_charConvert
    lda gameBg_char
    sta gamebg_screen+768,x
    lda gameBg_color
    sta gamebg_screen_color+768,x    
gameBg_drawSingleColor4_cont:
    iny
    inx
    cpx #112
    bne gameBg_drawSingleColor4

    rts


;-------Check repaint, HERE WE MAP INDEX TO BRICKS------
gameBg_checkRepaint:
    lda gameBg_redPaintColors
    bne gameBg_checkRepaint_1
    lda #2
    sta gameBg_colorRePaint
    jsr gameBg_drawSingleColor

gameBg_checkRepaint_1:
    lda gameBg_redPaintColors+1
    bne gameBg_checkRepaint_2
    lda #3
    sta gameBg_colorRePaint
    jsr gameBg_drawSingleColor

gameBg_checkRepaint_2:
    lda gameBg_redPaintColors+2
    bne gameBg_checkRepaint_3
    lda #4
    sta gameBg_colorRePaint
    jsr gameBg_drawSingleColor

gameBg_checkRepaint_3:
    lda gameBg_redPaintColors+3
    bne gameBg_checkRepaint_4
    lda #5
    sta gameBg_colorRePaint
    jsr gameBg_drawSingleColor

gameBg_checkRepaint_4:
    lda gameBg_redPaintColors+4
    bne gameBg_checkRepaint_5
    lda #6
    sta gameBg_colorRePaint
    jsr gameBg_drawSingleColor

gameBg_checkRepaint_5:
    lda gameBg_redPaintColors+5
    bne gameBg_checkRepaint_6
    lda #7
    sta gameBg_colorRePaint
    jsr gameBg_drawSingleColor

gameBg_checkRepaint_6:
    lda gameBg_redPaintColors+6
    bne gameBg_checkRepaint_7
    lda #12
    sta gameBg_colorRePaint
    jsr gameBg_drawSingleColor

gameBg_checkRepaint_7:
    lda gameBg_redPaintColors+7
    bne gameBg_checkRepaint_8
    lda #8
    sta gameBg_colorRePaint
    jsr gameBg_drawSingleColor

gameBg_checkRepaint_8:
    lda gameBg_redPaintColors+8
    bne gameBg_checkRepaint_9
    lda #9
    sta gameBg_colorRePaint
    jsr gameBg_drawSingleColor

gameBg_checkRepaint_9:
    lda gameBg_redPaintColors+9
    bne gameBg_checkRepaint_end
    lda #10
    sta gameBg_colorRePaint
    jsr gameBg_drawSingleColor


gameBg_checkRepaint_end:
    jsr gameBg_refillColorCounter
    rts


gameBg_refillColorCounter:
    tya
    pha
    ldy #0
    lda gamebg_colorCounterPnt
    sta 2
    dec 2
    lda gamebg_colorCounterPnt+1
    sta 3
gameBg_refillColorCounterLoop:
    lda gameBg_redPaintColors,y
    bne gameBg_refillColorCounterInc
    lda (2),y
    sta gameBg_redPaintColors,y
gameBg_refillColorCounterInc    
    iny
    cpy #10
    bne gameBg_refillColorCounterLoop
    pla
    tay
    rts



    
;--------------------------Change background for this level-------------------------
gamebg_change:
    sta gameBg_levelSub
    jsr gameBg_print
    rts
 
