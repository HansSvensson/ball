gameOverText .enc screen
             .text "player x won!"
gameOverTextEqual .enc screen
             .text "Equal, no winner!"

gameOver:
    jsr sound_init_menu
    lda $d018          ;set location of charset
    and #$f1
    ora #$5
    sta $d018
    lda $d016           ;Select singlecolor
    and #%11101111
    sta $d016


    ldx #0
    lda #32
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
    
    jsr score_lead
    tay
    jsr score_print
    bne gameOverWinner

    ldx #0
gameOverEqual:
    lda gameOverTextEqual,x
    sta $5c6,x                   ;11rader = 440byte + 14byte = 454 = 256 + 128 + 64 + 4 + 2 = 0x1d6 => 0x5d1
    inx
    cpx #12
    bne gameOverEqual

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
gameOverWaitJoy:    
    lda $DC00
    and $DC01
    and #%00010000               ;Zero flag=0 if joystick pressed
    bne gameOverWaitJoy
gameOverWaitJoyUp:    
    lda $DC00
    and $DC01
    and #%00010000               ;Zero flag=0 if joystick pressed
    beq gameOverWaitJoyUp
   
    lda #32
    ldx #0
gameOverEndClean:
    sta $5c6,x                   ;11rader = 440byte + 9byte = 449 = 256 + 128 + 64 + 1 = 0x1d1 => 0x5d1
    inx
    cpx #12
    bne gameOverEndClean


    rts
