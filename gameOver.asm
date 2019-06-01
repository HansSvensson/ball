gameOverText .enc screen
             .text "player#x#won!"
gameOverTextEqual .enc screen
             .text "equal,#no#winner!"
gameOverTextF1 .enc screen
             .text "press#f1#to#continue"
gameOver:
    jsr sound_init_menu
    ;lda $d018          ;set location of charset
    ;and #$f1
    ;ora #$5
    ;sta $d018
    ;lda $d016           ;Select singlecolor
    ;and #%11101111
    ;sta $d016


    ldx #0
    lda #35
gameOverClean:
    sta $428,x
    sta $500,x
    sta $600,x
    sta $6E8,x
    inx
    bne gameOverClean

    lda #1     ;FOREGROUND COLOR
    ldx #0
gameOver_cleanColorLoop:
    sta $d828,x
    sta $d900,x
    sta $da00,x
    sta $dae8,x
    inx
    bne gameOver_cleanColorLoop
    
    ldx #0
gameOver_f1Loop:    
    lda gameOverTextF1,x
    sta $610,x
    lda #5
    sta $da10,x
    inx
    cpx #21
    bne gameOver_f1Loop
            
    jsr score_lead
    tay
    jsr score_print_score_all
    tya
    bne gameOverWinner

    ldx #0
gameOverEqual:
    lda gameOverTextEqual,x
    sta $5c3,x                   ;11rader = 440byte + 14byte = 454 = 256 + 128 + 64 + 4 + 2 = 0x1d6 => 0x5d1
    inx
    cpx #17
    bne gameOverEqual
    lda #0
    sta $d015                    ;turn off all sprites
    jmp gameOverWaitF1
    
gameOverWinner:
    ldx #0
gameOverWinnerLoop:
    lda gameOverText,x
    sta $5c6,x                   ;11rader = 440byte + 14byte = 454 = 256 + 128 + 64 + 4 + 2 = 0x1d6 => 0x5d1
    inx
    cpx #12
    bne gameOverWinnerLoop 
    sty $5cd

    lda #0
    sta $d015                    ;turn off all sprites
gameOverWaitF1:
    jsr gameOver_checkF1
   
    lda #32
    ldx #0
gameOverEndClean:
    sta $5c6,x                   ;11rader = 440byte + 9byte = 449 = 256 + 128 + 64 + 1 = 0x1d1 => 0x5d1
    inx
    cpx #12
    bne gameOverEndClean


    rts


gameOver_checkF1:
    lda $dc00
    pha
    lda $dc02
    pha
    lda $dc03
    pha

    lda #$ff       ;we want to select row 
    sta $dc02      ;1:s equal Output mode
    lda #$fe
    sta $dc00

    lda #$0        ;we want to read the result from the keyboard matrix
    sta $dc03      ;0:s equal Input mode

gameOver_checkF1_loop:
    lda $dc01
    and #$10 
    bne gameOver_checkF1_loop

    pla
    sta $dc03
    pla
    sta $dc02
    pla
    sta $dc00
    rts

     
