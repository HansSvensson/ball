
game_init:
    lda #<game_isr   ;Set raster interrupt position
    sta $fffe
    lda #>game_isr
    sta $ffff
    lda #1 
    sta $d012

    rts




game_isr
   inc $d020
   lda $d01f
   sta ball_temp_d01f
   lda $d01e
   sta ball_temp_d01e
   ;Round 1-----------------
   jsr bat_update
   ldx #2
   jsr ball_update
   ldx #0
   jsr ball_update
   ldx #4
   jsr ball_update
   ldx #6
   jsr ball_update
   ldx #8
   jsr ball_update
   ldx #10
   jsr ball_update
   ;Round 2---------------
   jsr bat_update
   ldx #2
   jsr ball_update
   ldx #0
   jsr ball_update
   ldx #4
   jsr ball_update
   ldx #6
   jsr ball_update
   ldx #8
   jsr ball_update
   ldx #10
   jsr ball_update

   ;-----------------------
   jsr gameBgEl
   dec $d020
   asl $d019
   rti




