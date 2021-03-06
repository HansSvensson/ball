
bat_1_cordX = $d00c
bat_1_cordY = $d00d
bat_2_cordX = $d00e
bat_2_cordY = $d00f

bat_bottom = #200
bat_up     = #80
bat_hight  = #21
bat_ball_hight = #14

bat_bash_state .byte 0, 0, 0  ;0=bat-right 1=dummyvalue  2=bat-left

bat_init:
           lda $d010
           ora #$80     ;set sprite 8 at the right
           and #$BF
           sta $d010    

           lda $d015    ; we set sprite 7 and 8 as bats
           ora #$C0
           sta $d015

           lda #05      ; 
           sta $d02D
           lda #05
           sta $d02E

           lda #$18
           sta bat_1_cordX    ; set x coordinate to 40
           lda #140
           sta bat_1_cordY    ; set y coordinate to 40

           lda #$40
           sta bat_2_cordX    ; set x coordinate to 40
           lda #140
           sta bat_2_cordY    ; set y coordinate to 40

           lda #$e1
           sta $07fe    ; set pointer: sprite data at $2040
           sta $07ff    ; set pointer: sprite data at $2040
           
           lda $d01c
           ora #$C0
           sta $d01c
           
           lda #12     ;sprite multicolor 1
           sta $D025
           lda #11     ;sprite multicolor 2
           sta $D026 
           
           lda #15     ;sprite 6 individual
           sta $D02d 
           lda #12     ;sprite 7 individual
           sta $D02e 

           lda #0
           ldx #0
           sta bat_bash_state,x
           inx
           inx
           sta bat_bash_state,x

            rts


bat_temp_x .byte 0

bat_update:
            stx bat_temp_x
            ;check up
            lda $DC01
            and #%00011111
            cmp #%00011110
            beq bat_update1_up
            cmp #%00011101
            beq bat_update1_down
            jmp bat_update_2

bat_update1_up:
            lda bat_1_cordY
            cmp bat_up
            bcc bat_update_2
            dec bat_1_cordY 
            dec bat_1_cordY 
            dec bat_1_cordY 
            jmp bat_update_2

bat_update1_down:
            lda bat_1_cordY
            cmp bat_bottom
            bcs bat_update_2
            inc bat_1_cordY 
            inc bat_1_cordY 
            inc bat_1_cordY 

bat_update_2:
            lda $DC00
            and #%00011111
            cmp #%00011110
            beq bat_update2_up
            cmp #%00011101
            beq bat_update2_down
            jmp bat_update_bash

bat_update2_up:
            lda bat_2_cordY
            cmp bat_up
            bcc bat_update_bash
            dec bat_2_cordY 
            dec bat_2_cordY 
            dec bat_2_cordY 
            jmp bat_update_bash

bat_update2_down:
            lda bat_2_cordY
            cmp bat_bottom
            bcs bat_update_bash
            inc bat_2_cordY 
            inc bat_2_cordY 
            inc bat_2_cordY 

bat_update_bash
            ldx #0
            ldy #1
            jsr bat_update_bash_start
            ldx #2
            ldy #0
            jsr bat_update_bash_start
            ldx bat_temp_x
            rts



            ;-----------button pressed, X-reg => 0=bat-left 2=bat-right--------------
bat_update_bash_start:
            lda bat_bash_state,x
            cmp #0
            bne bat_update_bash_fire
            lda $dc00,y
            and #%00010000               ;Zero flag=0 if joystick pressed
            bne bat_update_bash_zero     ;jump if joystick not pressed
            lda #12
bat_update_bash_fire:
            adc #$fE 
            cmp #6
            bcc bat_update_bash_out ;if smaller    
            
bat_update_bash_in:
            cpx #2
            beq bat_update_bash_dec
            inc bat_1_cordX,x
            jmp bat_update_bash_quit
bat_update_bash_dec:
            dec bat_1_cordX,x
            jmp bat_update_bash_quit
            
bat_update_bash_out:
            cpx #2
            beq bat_update_bash_inc
            dec bat_1_cordX,x
            jmp bat_update_bash_quit
bat_update_bash_inc:
            inc bat_1_cordX,x
            jmp bat_update_bash_quit

bat_update_bash_zero:
            lda #0
bat_update_bash_quit:
            sta bat_bash_state,x
            rts




ball_hit_mask .byte $01,$00, $02,$00, $04,$00, $08,$00, $10,$00, $20,$00, $40,$00, $80,$00
bat_hit_d01e .byte 0

bat_hit_1:
           jsr bat_hit_1_range
           beq ball_hit_quit
           lda bat_bash_state
           cmp #3
           bcc bat_hit_1_left
           ldy LEFT_BAT
           jmp bat_hit1_exit
bat_hit_1_left:
           ldy LEFT
           lda $DC01              ;if bat moves counter the ball move
           and #%00000001
           bne bat_hit1_down
           ldy LEFT_BAT_UP
           jmp bat_hit1_exit
bat_hit1_down:           
           lda $DC01
           and #%00000010
           bne bat_hit1_exit
           ldy LEFT_BAT_DOWN            
bat_hit1_exit:
           lda #%01000000
           jmp bat_hit

bat_hit_2:
           jsr bat_hit_2_range
           beq ball_hit_quit
           lda bat_bash_state+2
           cmp #3
           bcc bat_hit_2_right
           ldy RIGHT_BAT
           jmp bat_hit2_exit
bat_hit_2_right:
           ldy RIGHT
           lda $DC00
           and #%00000001
           bne bat_hit2_down
           ldy RIGHT_BAT_UP
           jmp bat_hit2_exit
bat_hit2_down:           
           lda $DC00
           and #%00000010
           bne bat_hit2_exit
           ldy RIGHT_BAT_DOWN            
bat_hit2_exit:
           lda #%10000000
           jmp bat_hit

bat_hit:                          ;check if bat colides with sprite, and if ball does it.
            and ball_temp_d01e
            beq ball_hit_quit
            lda ball_temp_d01e
            ora $d01e
            sta ball_temp_d01e
            and ball_hit_mask,x
            beq ball_hit_quit
            tya
            rts

ball_hit_quit:
            lda NONE
            rts    
            

;----------Range ball so that we minimize risk of changing balls direkcion---------------
bat_hit_1_range:
            tya                      ;first must check if d010 is set or not
            pha
            txa
            lsr a
            tay
            lda ball_bitfield,y
            and $d010
            bne bat_hit_1_range_no   ;om satt

            lda $d000,x
            cmp #42                  ;rangecheck limit remember $c then balls middle at the boarder of screen 8+8+8+12+6
            bcc bat_hit_1_range_yes                        
             
bat_hit_1_range_no:
            pla
            tay
            lda #0
            rts
               
bat_hit_1_range_yes:
            pla
            tay
            lda #1
            rts                     

bat_hit_2_range:
            tya                      ;first must check if d010 is set or not
            pha
            txa
            lsr a
            tay
            lda ball_bitfield,y
            and $d010
            beq bat_hit_2_range_no

            lda $d000,x
            cmp #48                  ;rangecheck limit remember $c then balls middle at the boarder of screen 320-256+12-8-8-8=56 
            bcs bat_hit_2_range_yes                        
             
bat_hit_2_range_no:
            pla
            tay
            lda #0
            rts
               
bat_hit_2_range_yes:
            pla
            tay
            lda #1
            rts                     
 
 ;-----------------------------------------------------           
                        
;---------------Code for bonus logic--------------
bat_bonus_smaller:
    cpx ball_player_1
    beq bat_bonus_smaller_pl1
    cpx ball_player_2
    beq bat_bonus_smaller_pl2
    rts
bat_bonus_smaller_pl1:
    lda #$e2
    sta $07ff
    rts
bat_bonus_smaller_pl2:
    lda #$e2
    sta $07fe
    rts

bat_bonus_smaller_end:
    cpx ball_player_1
    beq bat_bonus_smaller_end_pl1
    cpx ball_player_2
    beq bat_bonus_smaller_end_pl2
    rts
bat_bonus_smaller_end_pl1:
    lda #$e1
    sta $07ff
    rts
bat_bonus_smaller_end_pl2:
    lda #$e1
    sta $07fe
    rts

;----larger----
bat_bonus_larger:
    cpx ball_player_1
    beq bat_bonus_larger_pl1
    cpx ball_player_2
    beq bat_bonus_larger_pl2
    rts
bat_bonus_larger_pl1:
    lda $d017
    ora #%01000000
    sta $d017
    rts
bat_bonus_larger_pl2:
    lda $d017
    ora #%10000000
    sta $d017
    rts

bat_bonus_larger_end:
    cpx ball_player_1
    beq bat_bonus_larger_end_pl1
    cpx ball_player_2
    beq bat_bonus_larger_end_pl2
    rts
bat_bonus_larger_end_pl1:
    lda $d017
    and #%10111111
    sta $d017
    rts
bat_bonus_larger_end_pl2:
    lda $d017
    and #%01111111
    sta $d017
    rts
     
