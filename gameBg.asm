gameElframeCount .byte 0
gameElframeState .byte 0

gameBg_init:
        
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

    sta $6F7
    sta $71F
    sta $747
    sta $76F
    sta $797
    sta $7BF

    ;TODO remove, just som test in the middle
    sta $5A4
    sta $5cc
    sta $5f4
    sta $61c
    
    jsr gameBg_setMulticolor
    
    lda #10     ;FOREGROUND COLOR
    ldx #0
gameBg_fill_foreground:
    sta $d800,x
    sta $d900,x
    sta $da00,x
    sta $db00,x
    inx
    bne gameBg_fill_foreground
    
    jsr gameBg_squareBg

    jsr gameBgEl

    jsr gameBg_printScore
    
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

    lda #32
    sta $406
    sta $407
    sta $408
    sta $425
    sta $426
    sta $427

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

    lda #12    ;MULTICOLOR 1
    sta $d022
    lda #10     ;MULTICOLOR 2
    sta $d023
    rts



;-------------Load one big squre background-----------------
gameBg_squareBg:
    lda #0
    sta gameBg_bricksHi
    lda #80
    sta gameBg_bricksLo
    
    lda #$40
    ;row 4 starts @ 0x478 start 0x10 in 8 chars wide -> 488->490
    ldx #0
gameBg_squareBg_base_1:
    sta $486,x
    sta $4d6,x
    sta $526,x
    sta $576,x
    sta $5c6,x
    sta $616,x
    sta $666,x
    sta $6b6,x
    sta $706,x
    sta $756,x
    inx
    cpx #12
    bne gameBg_squareBg_base_1 
    lda #$54
    ldx #0
gameBg_squareBg_base_2:
    sta $4ae,x
    sta $4fe,x
    sta $54e,x
    sta $59e,x
    sta $5ee,x
    sta $63e,x
    sta $68e,x
    sta $6de,x
    sta $72e,x
    sta $77e,x
    inx
    cpx #12
    bne gameBg_squareBg_base_2

    lda #13
    ldx #0
gameBg_squareBg_base_color_1:
    sta $d886,x
    sta $d8d6,x
    sta $d926,x
    sta $d976,x
    sta $d9c6,x
    sta $da16,x
    sta $da66,x
    sta $dab6,x
    sta $db06,x
    sta $db56,x
    inx
    cpx #12
    bne gameBg_squareBg_base_color_1 
    
    lda #12
    ldx #0
gameBg_squareBg_base_color_2:
    sta $d8ae,x
    sta $d8fe,x
    sta $d94e,x
    sta $d99e,x
    sta $d9ee,x
    sta $da3e,x
    sta $da8e,x
    sta $dade,x
    sta $db2e,x
    sta $db7e,x
    inx
    cpx #12
    bne gameBg_squareBg_base_color_2 



    rts

;-----------------------Check for hit between BG and sprite----------------
gameBg_hit_1:
    lda #32
    ldy #0    
    sta (main_temp_pointer),y     ;Use the pointer we just created.
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

gameBg_hit_2:
    clc
    adc #$ff
    cmp #$48
    bne gameBg_hit_2_do 
    lda #$40
    
gameBg_hit_2_do
    ldy #0    
    sta (main_temp_pointer),y     ;Use the pointer we just created.
    rts

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
    sta $518
    stx $540
    sta $568
    stx $590
    sta $5b8
    stx $5e0
    sta $608
    stx $630
    sta $658
    stx $680
    sta $6a8

    sta $53f
    stx $567
    sta $58f
    stx $5b7
    sta $5df
    stx $607
    sta $62f
    stx $657
    sta $67f
    stx $6a7
    stx $6cf

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

 * = $3000
 .binary "resources/charsetBg.bin"
