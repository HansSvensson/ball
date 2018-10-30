bat_1:
.byte $00,$5c,$00,$00,$5c,$00,$02,$ba
.byte $00,$02,$ba,$00,$02,$ba,$00,$00
.byte $00,$00,$01,$d5,$00,$01,$d5,$00
.byte $01,$d5,$00,$01,$d5,$00,$01,$d5
.byte $00,$01,$d5,$00,$01,$d5,$00,$01
.byte $d5,$00,$01,$d5,$00,$00,$00,$00
.byte $02,$ba,$00,$02,$ba,$00,$02,$ba
.byte $00,$00,$5c,$00,$00,$5c,$00,$82

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

           lda #$1a
           sta bat_1_cordX    ; set x coordinate to 40
           lda #100
           sta bat_1_cordY    ; set y coordinate to 40

           lda #$40
           sta bat_2_cordX    ; set x coordinate to 40
           lda #100
           sta bat_2_cordY    ; set y coordinate to 40

           lda #$81
           sta $07fe    ; set pointer: sprite data at $2040
           sta $07ff    ; set pointer: sprite data at $2040
           
           lda $d01c
           ora #$C0
           sta $d01c
           
           lda #$06     ;sprite multicolor 1
           sta $D025
           lda #$01     ;sprite multicolor 2
           sta $D026 
           
           lda #$05     ;sprite 6 individual
           sta $D02d 
           lda #$02     ;sprite 7 individual
           sta $D02e 

           lda #0
           ldx #0
           sta bat_bash_state,x
           inx
           inx
           sta bat_bash_state,x
           ldx #0          
bat_fill:
            lda bat_1,x
            sta $2040,x
            inx
            cmp #64
            bne bat_fill

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
            jmp bat_update_2

bat_update1_down:
            lda bat_1_cordY
            cmp bat_bottom
            bcs bat_update_2
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
            jmp bat_update_bash

bat_update2_down:
            lda bat_2_cordY
            cmp bat_bottom
            bcs bat_update_bash
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
           lda bat_bash_state
           cmp #3
           bcc bat_hit_1_left
           ldy LEFT_BAT
           jmp bat_hit1_exit
bat_hit_1_left:
           ldy LEFT
bat_hit1_exit:
           lda #%01000000
           jmp bat_hit

bat_hit_2:
           lda bat_bash_state+2
           cmp #3
           bcc bat_hit_2_right
           ldy RIGHT_BAT
           jmp bat_hit2_exit
bat_hit_2_right:
           ldy RIGHT
bat_hit2_exit:
           lda #%10000000

bat_hit:
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
