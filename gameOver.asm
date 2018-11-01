gameOverText .enc screen
             .text "PLAYER X WON!"
             

gameOver:

    ldx #0
    lda #32
gameOverClean:
    sta $400,x
    sta $500,x
    sta $600,x
    sta $6E8,x
    inx
    bne gameOverClean

gameOverWinner:
    lda gameOverText,x
    sta $5c6,x                   ;11rader = 440byte + 14byte = 454 = 256 + 128 + 64 + 4 + 2 = 0x1d6 => 0x5d1
    inx
    cpx #12
    bne gameOverWinner
    
    lda #0
    sta $d015                    ;turn off all sprites
gameOverWaitJoy:    
    lda $DC00
    and $DC01
    and #%00010000               ;Zero flag=0 if joystick pressed
    bne gameOverWaitJoy
   
    lda #32
    ldx #0
gameOverEndClean:
    sta $5c6,x                   ;11rader = 440byte + 9byte = 449 = 256 + 128 + 64 + 1 = 0x1d1 => 0x5d1
    inx
    cpx #12
    bne gameOverEndClean


    rts
