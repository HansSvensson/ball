gameBg_init:
    
    ;---------score------------
    lda #$13
    sta $400
    sta $41D
    lda #$03
    sta $401
    sta $41E
    lda #$0F
    sta $402
    sta $41F
    lda #$12
    sta $403
    sta $420
    lda #$05
    sta $404
    sta $421
    lda #$3A
    sta $405
    sta $422

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
    
    ;---------fill top----------
    lda #102
    ldx #40
gameBg_fillTop:
    sta $427,x
    dex
    bne gameBg_fillTop


    ;---------fill bottom-------
    ldx #40
gameBg_fillBottom:
    sta $7BF,x
    dex
    bne gameBg_fillBottom

    ;---------fill left--------
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
   

    ;----------------set ut multicolor charset
    lda $d018
    ora #$d
    sta $d018
    lda $d016
    ora #$10
    sta $d016

    
    lda #12    ;MULTICOLOR 1
    sta $d022
    lda #8     ;ULTICOLOR 2
    sta $d023
    
    lda #9     ;FOREGROUND COLOR
    ldx #0
gameBg_fill_foreground:
    sta $d800,x
    sta $d900,x
    sta $da00,x
    sta $db00,x
    inx
    bne gameBg_fill_foreground


    rts

 * = $3000
 .binary "resources/charsetBg.bin"
