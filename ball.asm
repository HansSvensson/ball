

TOP    = #0
BOTTOM = #1
RIGHT  = #2
LEFT   = #3
RIGHT_BAT  = #4
LEFT_BAT   = #5
NONE   = #6
RIGHT_BAT_UP   = #7
RIGHT_BAT_DOWN = #8
LEFT_BAT_UP    = #9
LEFT_BAT_DOWN  = #10


; 1  =  Right down
; 2  =  Right up
; 3  =  Left up 
; 4  =  Left down
RIGHT_DOWN = #1
RIGHT_UP   = #2
LEFT_UP    = #3
LEFT_DOWN  = #4
LEFT_STRAIGHT  = #5
RIGHT_STRAIGHT = #6

main_temp_pointer = 2
main_temp_x       = 4
main_temp_x_l2    = 5
main_temp_y_l2    = 6
ball_temp_d01f    .byte 0
ball_temp_d01e    .byte 0
ball_temp         .byte 0
balls_state  .byte 1,0,1,0,1,0,4,0,4,0,4,1,0,1,0,1

ball_player_1 = #1
ball_player_2 = #2
ball_player_none = #3
ball_owner  .byte 3,0,3,0,3,0,3,0,3,0,3,0,0,0,0,0
ball_player_1_color    = #15
ball_player_2_color    = #11
ball_player_none_color = #0
ball_current .byte 0

dir_0 = 4

ball_bounce_bat   = #1
ball_bounce_brick = #0
ball_bounce        .byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
ball_bounceToggle  .byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

ball_bonusUnStopable .byte 0,0,0,0


ball_init:
           lda #$3f
           sta $d015    ; Turn sprite 0 on
           sta $d027    ; Make it white
           lda ball_player_none_color
           sta $d027
           lda ball_player_none_color
           sta $d028
           lda ball_player_none_color
           sta $d029
           lda ball_player_none_color
           sta $d02a
           lda ball_player_none_color
           sta $d02b
           lda ball_player_none_color
           sta $d02c

           jsr ball_resetCord

           lda #$e0
           sta $07f8    ; set pointer: sprite data at $2000
           sta $07f9    ; set pointer: sprite data at $2000
           sta $07fa    ; set pointer: sprite data at $2000
           sta $07fb    ; set pointer: sprite data at $2000
           sta $07fc    ; set pointer: sprite data at $2000
           sta $07fd    ; set pointer: sprite data at $2000
    
           ;lda $d01c    ; enable multicolor sprites
           ;ora #$3f
           ;sta $d01c
           
           ;TODO REMOVE
           ;lda ball_player_1
           ;sta ball_owner
           ;sta ball_owner+2
           ;sta ball_owner+4
           ;lda #1
           ;lda ball_player_2
           ;sta ball_owner+6
           ;sta ball_owner+8
           ;sta ball_owner+10
           lda ball_player_none
           sta ball_owner
           sta ball_owner+2
           sta ball_owner+4
           sta ball_owner+6
           sta ball_owner+8
           sta ball_owner+10
           
           lda #0
           sta ball_bonusUnStopable
           sta ball_bonusUnStopable+1
           sta ball_bonusUnStopable+2

            lda #0
            sta dir_0

            rts


ball_resetCord:
           lda #1
           sta balls_state
           sta balls_state+2
           sta balls_state+4
           lda #4
           sta balls_state+6
           sta balls_state+8
           sta balls_state+10

           lda game_sixBalls
           beq ball_resetCord_three 
                    
           lda $d010
           and #$C0
           ora #$38
           sta $d010    ; Pl2 sprites starts at right part screen
           
           lda #34
           sta $d000    ; set x coordinate to 40
           lda #$7c
           sta $d001    ; set y coordinate to 40

           lda #38
           sta $d002    ; set x coordinate to 40
           lda #$8c
           sta $d003    ; set y coordinate to 40

           lda #42
           sta $d004    ; set x coordinate to 40
           lda #$9c
           sta $d005    ; set y coordinate to 40
           
           lda #42
           sta $d006    ; set x coordinate to 40
           lda #$9c
           sta $d007    ; set y coordinate to 40
           
           lda #46
           sta $d008    ; set x coordinate to 40
           lda #$8c
           sta $d009    ; set y coordinate to 40

           lda #50      ; left is 27in -> right 316 = 255 + 61 -> -24 sprite width => 37
           sta $d00a    ; set x coordinate to 40
           lda #$7c
           sta $d00b    ; set y coordinate to 40
           jmp ball_resetCord_end

ball_resetCord_three:
           lda #$07
           sta $d015    ; Turn sprite 0 on

           lda $d010
           and #$C0
           ora #$2
           sta $d010    ; Pl2 sprites starts at right part screen
           
           lda #34
           sta $d000    ; set x coordinate to 40
           lda #$7c
           sta $d001    ; set y coordinate to 40

           lda #50
           sta $d002    ; set x coordinate to 40
           lda #$7c
           sta $d003    ; set y coordinate to 40
 
           lda #174
           sta $d004    ; set x coordinate to 40
           lda #143
           sta $d005    ; set y coordinate to 40
           
ball_resetCord_end:           
           rts


; leftright
;
; x   = sprite point
;
; 1  =  Right down
; 2  =  Right up
; 3  =  Left up 
; 4  =  Left down
;

ball_update:
    stx ball_current

    lda balls_state,x

    cmp RIGHT_DOWN
    beq ball_rightDown
    cmp RIGHT_UP
    beq ball_rightUp
    cmp LEFT_UP
    beq ball_leftUp
    cmp LEFT_STRAIGHT
    beq ball_leftStraight
    cmp RIGHT_STRAIGHT
    beq ball_rightStraight
 

 ;-------------------------------
 ball_leftDown:
    jsr ball_hit
    cmp LEFT                    ;hit left wall
    beq leftDownChangeRight
    cmp BOTTOM
    beq leftDownChangeToUp
    cmp LEFT_BAT
    beq leftDownChangeToStraight
    cmp LEFT_BAT_UP
    beq leftDownChangeToBack
    cmp LEFT_BAT_UP
    beq leftDownChangeRight
    jsr ball_dec_x
    jsr ball_inc_y
    jmp ball_update_end
    
 leftDownChangeToUp
    lda LEFT_UP
    sta balls_state,x  
    jsr ball_dec_x
    jsr ball_dec_y
    jmp ball_update_end

leftDownChangeRight:
    lda RIGHT_DOWN      ;left hit -> rightDown
    sta balls_state,x  
    jsr ball_inc_x
    jsr ball_inc_y     
    jmp ball_update_end

leftDownChangeToBack:
    lda RIGHT_UP
    sta balls_state,x  
    jsr ball_inc_x
    jsr ball_dec_y     
    jmp ball_update_end

leftDownChangeToStraight:
    lda RIGHT_STRAIGHT
    sta balls_state,x   
    jsr sound_playPlayer1Claim
    jsr ball_changeOwner_2_to_1 

    jmp ball_update_end

;-------------------------------
ball_rightDown:
    jsr ball_hit 
    cmp RIGHT                    ;hit left wall
    beq rightDownChangeRight
    cmp BOTTOM
    beq rightDownChangeToUp
    cmp RIGHT_BAT
    beq rightDownChangeToStraight
    cmp RIGHT_BAT_UP
    beq rightDownChangeToBack
    cmp RIGHT_BAT_DOWN
    beq rightDownChangeRight

    jsr ball_inc_x
    jsr ball_inc_y
    jmp ball_update_end

rightDownChangeToUp:
    lda RIGHT_UP
    sta balls_state,x       
    jsr ball_inc_x
    jsr ball_dec_y
    jmp ball_update_end

rightDownChangeToStraight:
    lda LEFT_STRAIGHT
    sta balls_state,x
    jsr sound_playPlayer2Claim
    jsr ball_changeOwner_1_to_2 
    jmp ball_update_end
    
rightDownChangeRight:
    lda LEFT_DOWN
    sta balls_state,x       
    jsr ball_dec_x
    jsr ball_inc_y          
    jmp ball_update_end

rightDownChangeToBack:
    lda LEFT_UP
    sta balls_state,x       
    jsr ball_dec_x
    jsr ball_dec_y
    jmp ball_update_end



;------------------------------
ball_rightUp:
    jsr ball_hit
    cmp RIGHT
    beq rightUpChangeToLeft
    cmp TOP
    beq rightUpChangeToDown
    cmp RIGHT_BAT
    beq rightUpChangeToStraight
    cmp RIGHT_BAT_UP
    beq rightUpChangeToLeft
    cmp RIGHT_BAT_DOWN
    beq rightUpChangeToBack
    jsr ball_inc_x
    jsr ball_dec_y
    jmp ball_update_end

rightUpChangeToLeft:
    lda LEFT_UP
    sta balls_state,x 
    jsr ball_dec_x
    jsr ball_dec_y          
    jmp ball_update_end

rightUpChangeToStraight:
    lda LEFT_STRAIGHT
    sta balls_state,x
    jsr sound_playPlayer2Claim
    jsr ball_changeOwner_1_to_2 
    jmp ball_update_end

rightUpChangeToDown:
    lda RIGHT_DOWN
    sta balls_state,x       
    jsr ball_inc_x
    jsr ball_inc_y
    jmp ball_update_end

rightUpChangeToBack:
    lda LEFT_DOWN
    sta balls_state,x       
    jsr ball_dec_x
    jsr ball_inc_y
    jmp ball_update_end


;------------------------------
ball_leftUp:
    jsr ball_hit 
    cmp TOP
    beq ball_leftUpChangeDown
    cmp LEFT
    beq ball_leftUpChangeRight
    cmp LEFT_BAT
    beq ball_leftUpChangeStraight
    cmp LEFT_BAT_DOWN
    beq ball_leftUpChangeBack
    cmp LEFT_BAT_UP
    beq ball_leftUpChangeRight
    jsr ball_dec_x
    jsr ball_dec_y       
    jmp ball_update_end

ball_leftUpChangeDown:
    lda LEFT_DOWN
    sta balls_state,x       
    jsr ball_dec_x
    jsr ball_inc_y          
    jmp ball_update_end

ball_leftUpChangeStraight:
    lda RIGHT_STRAIGHT
    sta balls_state,x 
    jsr sound_playPlayer1Claim
    jsr ball_changeOwner_2_to_1      
    jmp ball_update_end

ball_leftUpChangeRight:
    lda RIGHT_UP
    sta balls_state,x       
    jsr ball_inc_x
    jsr ball_dec_y          
    jmp ball_update_end

ball_leftUpChangeBack:
    lda RIGHT_DOWN
    sta balls_state,x       
    jsr ball_inc_x
    jsr ball_inc_y          
    jmp ball_update_end

;------------------------------

ball_leftStraight:
    jsr ball_hit 
    cmp LEFT
    beq ball_leftStraightChangeRight
    cmp LEFT_BAT
    beq ball_leftStraightChangeStraight
    jsr ball_dec_x       
    jmp ball_update_end

ball_leftStraightChangeRight:
    lda RIGHT_UP
    sta balls_state,x       
    jmp ball_update_end
ball_leftStraightChangeStraight:
    lda RIGHT_STRAIGHT
    sta balls_state,x  
    jsr sound_playPlayer1Claim
    jsr ball_changeOwner_2_to_1 
         
    jmp ball_update_end

;------------------------------

ball_rightStraight:
    jsr ball_hit
    cmp RIGHT
    beq rightStraightChangeToLeft
    cmp RIGHT_BAT
    beq rightStraightChangeToStraight
    jsr ball_inc_x
    jmp ball_update_end

rightStraightChangeToLeft:
    lda LEFT_UP
    sta balls_state,x       
    jmp ball_update_end
rightStraightChangeToStraight:
    lda LEFT_STRAIGHT
    sta balls_state,x
    jsr sound_playPlayer2Claim
    jsr ball_changeOwner_1_to_2 
    jmp ball_update_end


;------------------------------

ball_update_end:
     ;   dec $d021
     ;   asl $d019
     ;   rti
     rts



;
; 0 - top
; 1 - bottom
; 2 - right
; 3 - left
;
ball_hit:
    lda $d001,x
    cmp #51
    beq ball_hitTop
    cmp #230
    beq ball_hitBottom

    txa
    lsr a
    tay
    lda ball_bitfield,y
    and $d010
    bne ball_hit_right
    lda $d000,x
    cmp #24
    beq ball_hitLeft
    
 ball_hit_right:   
    txa
    lsr a
    tay
    lda ball_bitfield,y
    and $d010
    ;cmp #1
    beq ball_hit_none
    lda $d000,x
    cmp #64
    bne ball_hit_none
    ;lda RIGHT
    lda NONE
    rts

ball_hit_none:
    ;lda NONE
    jsr ball_hit_bg
    cmp NONE
    bne ball_hit_none_brick
    jsr bat_hit_1
    cmp NONE
    bne ball_hit_none_bat
    jsr bat_hit_2
    cmp NONE
    bne ball_hit_none_bat
ball_hit_none_ret:
    rts
ball_hit_none_bat:
    pha
    lda ball_bounce_bat
    sta ball_bounce,x
    pla
    rts
ball_hit_none_brick:
    pha
    lda ball_bounce_brick
    sta ball_bounce,x
    pla
    rts


ball_hitLeft:
    ;lda LEFT
    lda NONE
    rts

ball_hitBottom:
    lda BOTTOM
    rts

ball_hitTop:
    lda TOP
    rts
;--------------------------


;Tables for mapping X-Y coordinates (40*25) to C64 screen addresses for start of each row, TODO: one row to much?
;Index(dec)              0                                          9                                           19                            25     
;NR bytes(dec)           0, 40, 80, 120, 160, 200, 240, 280, 320, 360, 400, 440, 480, 520, 560, 600, 640, 680, 720, 760, 800, 840, 880, 920, 960
ball_hit_cord_Hi .byte   4,  4,  4,   4,   4,   4,   4,   5,   5,   5,   5,   5,   5,   6,   6,   6,   6,   6,   6,   6,   7,   7,   7,   7,   7
ball_hit_cord_Lo .byte   0, 40, 80, 120, 160, 200, 240,  24,  64, 104, 144, 184, 224,   8,  48,  88, 128, 168, 208, 248,  32,  72, 112, 152, 192    


;Check if char at input X=col Y=row. This Function returnes in ACC.
ball_hit_char:
    cmp #$ff
    beq ball_hit_char_no_hit
    stx main_temp_pointer         ;We must preserve the X-value, calling this functio 5 times.
    lda ball_hit_cord_Lo,y        ;With Y-reg we want to get the start address for the line, then we add X-reg to that
    clc                           ;that way we know which char the sprites is above. Remember C64 ACC 8bit, addresses 16bit :)
    adc main_temp_pointer
    sta main_temp_pointer
    lda ball_hit_cord_Hi,y
    adc #0                        ;If the previous ADC set the carry-flag, add it to the the high-part of address.
    sta main_temp_pointer+1

    sty main_temp_y_l2
    ldy #0
    lda (main_temp_pointer),y     ;Use the pointer we just created.
    ldy main_temp_y_l2
ball_hit_char_adc:    
    
    cmp #$C0
    bcc ball_hit_char_others
    cmp #$F0
    bcs ball_hit_char_others

apa:
    ;NORMAL BRICKS
    clc
    adc #$42            ;$C0 -> 02
    pha
    lda #0
    jsr gameBg_hit_1
    beq ball_hit_char_hit_tmp
    pla
    tax
    lda gameBg_redPaintColors,x
    beq ball_hit_char_brick_1_0_c
    dec gameBg_redPaintColors,x
ball_hit_char_brick_1_0_c:    
    jmp ball_hit_char_hit_brick

ball_hit_char_hit_tmp:
    pla
    jmp ball_hit_char_hit

ball_hit_char_others:
    cmp #128
    beq ball_hit_bonus_1
    cmp #129
    beq ball_hit_bonus_1
    cmp #130
    beq ball_hit_bonus_1
    cmp #131
    beq ball_hit_bonus_1
    cmp #132
    beq ball_hit_bonus_1
    cmp #133
    beq ball_hit_bonus_1
    cmp #134
    beq ball_hit_bonus_1
    cmp #135
    beq ball_hit_bonus_1
    cmp #136
    beq ball_hit_bonus_1

    cmp #105
    beq wall_hit
    cmp #106
    beq wall_hit
    cmp #107
    beq wall_hit
    cmp #108
    beq wall_hit

    cmp #$a0                      ;TODO: this must support more kinds of 
    beq ball_hit_char_hit
    cmp #$a1                      ;TODO: this must support more kinds of 
    beq ball_hit_char_hit
    cmp #$a2                      ;TODO: this must support more kinds of 
    beq ball_hit_char_hit
    cmp #$a3                      ;TODO: this must support more kinds of 
    beq ball_hit_char_hit
    cmp #$a4                      ;TODO: this must support more kinds of 
    beq ball_hit_char_hit
    ;cmp #$a5                      ;TODO: this must support more kinds of 
    ;beq ball_hit_char_hit
    cmp #$a6                      ;TODO: this must support more kinds of 
    beq ball_hit_char_hit
    ;cmp #$a7                      ;TODO: this must support more kinds of 
    ;beq ball_hit_char_hit
    cmp #$a8                      ;TODO: this must support more kinds of 
    beq ball_hit_char_hit
    ;cmp #$a9                      ;TODO: this must support more kinds of 
    ;beq ball_hit_char_hit
    cmp #$aa                      ;TODO: this must support more kinds of 
    beq ball_hit_char_hit
    cmp #$ab                      ;TODO: this must support more kinds of 
    beq ball_hit_char_hit
    ;cmp #$ac                      ;TODO: this must support more kinds of 
    ;beq ball_hit_char_hit
    cmp #$ad                      ;TODO: this must support more kinds of 
    beq ball_hit_char_hit
    ;cmp #$ae                      ;TODO: this must support more kinds of 
    ;beq ball_hit_char_hit
    cmp #$af                      ;TODO: this must support more kinds of 
    beq ball_hit_char_hit
    ;cmp #$b0                      ;TODO: this must support more kinds of 
    ;beq ball_hit_char_hit
    cmp #$b1                      ;TODO: this must support more kinds of 
    beq ball_hit_char_hit

    cmp #102                      ;TODO: this must support more kinds of 
    beq ball_hit_char_hit
    cmp #103                      ;TODO: this must support more kinds of 
    beq ball_hit_char_hit
    cmp #104                      ;TODO: this must support more kinds of 
    beq ball_hit_char_hit

  ; TODO
  ;  cmp #$4A
  ;  beq ball_hit_char_brick_hardbrick
  ;  cmp #$4B
  ;  beq ball_hit_char_brick_hardbrick_2


    cmp #$60                      ;hit hard bricks
    bcc ball_hit_char_brick_2
ball_hit_char_no_hit:    
    lda #0
    rts

ball_hit_bonus_1:
    jsr gameBg_hit_bonus_1
    jmp ball_hit_char_hit
ball_hit_char_brick_2:
    cmp #$40
    bcs ball_hit_char_brick_2_do
    lda #0
    rts

ball_hit_char_brick_2_do
    jsr gameBg_hit_2

;Hit something that is not a brick
ball_hit_char_hit:
    lda #1    
    rts

ball_hit_char_hit_brick:
    jsr gameBg_getOwner
    tax
    lda ball_bonusUnStopable,x
    bne ball_hit_char_hit_brick_unstopable
    lda #1    
    ldx main_temp_x
    rts
ball_hit_char_hit_brick_unstopable:
    lda #0
    ldx main_temp_x
    rts    
    
;---------------------


;------------Check if ball collides with a CHAR-----------------
ball_hit_bg:
    stx main_temp_x          ;Store X in temp variable!!!  

;output -> A = X position    Y = Y postion    



  ;------------------

    lda main_temp_x
    tax
    lda balls_state,x

    cmp RIGHT_DOWN
    beq ball_hit_check_right_down
    cmp RIGHT_UP
    beq ball_hit_check_right_up
    cmp LEFT_UP
    beq ball_hit_check_left_up
    cmp LEFT_DOWN
    beq ball_hit_check_left_down
    cmp LEFT_STRAIGHT
    beq ball_hit_check_left_straight
    cmp RIGHT_STRAIGHT
    beq ball_hit_check_right_straight

    lda NONE
    rts


ball_hit_check_right_down:
    jsr ball_hit_bg_down
    tax
    dex
    jsr ball_hit_bg_right
    cmp NONE
    bne ball_hit_check_end
    jsr ball_hit_bg_bottom
    jmp ball_hit_check_end
ball_hit_check_right_up:
    jsr ball_hit_bg_up
    tax
    dex
    jsr ball_hit_bg_right
    cmp NONE
    bne ball_hit_check_end
    jsr ball_hit_bg_top
    jmp ball_hit_check_end
ball_hit_check_left_up:
    jsr ball_hit_bg_up
    tax
    jsr ball_hit_bg_left
    cmp NONE
    bne ball_hit_check_end
    jsr ball_hit_bg_top
    jmp ball_hit_check_end
ball_hit_check_left_down:
    jsr ball_hit_bg_down
    tax
    jsr ball_hit_bg_left
    cmp NONE
    bne ball_hit_check_end
    jsr ball_hit_bg_bottom
    jmp ball_hit_check_end
ball_hit_check_left_straight:
    jsr ball_hit_bg_down
    tax
    jsr ball_hit_bg_left
    jmp ball_hit_check_end
ball_hit_check_right_straight:
    jsr ball_hit_bg_down
    tax
    jsr ball_hit_bg_right
    jmp ball_hit_check_end



ball_hit_check_end
    ldx main_temp_x           ; TODO this one returns 0 but shohould be NONW!!!
    rts

ball_hit_bg_no:
    lda NONE                    ;NONE         ; TODO: WAS ZERO CHANGED TO NONE!!!!!!
    rts

ball_hit_bg_left:
    dex 
    jsr ball_hit_char
    inx
    cmp #1    
    bne ball_hit_bg_no
    lda LEFT
    rts
ball_hit_bg_right:
    inx 
    jsr ball_hit_char
    dex
    cmp #1    
    bne ball_hit_bg_no
    lda RIGHT
    rts
ball_hit_bg_bottom:
    iny                      ;Move down and search BELOW the sprite
    jsr ball_hit_char
    dey
    cmp #1
    bne ball_hit_bg_no
    lda BOTTOM
    rts
ball_hit_bg_top:
    dey                      ;We start to search for at hit ABOVE the sprite
    jsr ball_hit_char        
    iny
    cmp #1
    bne ball_hit_bg_no
    lda TOP
    rts
ball_hit_bg_top2:
    jsr ball_hit_char
    cmp #1    
    bne ball_hit_bg_no
    lda TOP
    rts

ball_hit_bg_none:
    lda NONE
    ldx main_temp_x
    rts


 
ball_hit_bg_down:

    ldx main_temp_x
    txa

    lsr a
    tay      
    lda $d010                ;If sprite is on the right part of the screen above pixel 255
    and ball_bitfield,y
    beq ball_hit_bg_x_less_FF_down

ball_hit_bg_x_over_FF_down    ;ruta 30 börjar på pixel 252 ->  d000,x pixel 0-3 = 0, 4-b = 1, osv
    lda $d000,x          ;256 equals column 30 and 4 pixels chars  (240 + 4 + c)    
    clc
    adc #8
    lsr a
    lsr a
    lsr a
    clc
    adc #$1e
    pha
    
    jmp ball_hit_bg_y_down
    
ball_hit_bg_x_less_FF_down:
    lda $d000,x              ;Also add sprite X value converted to Char cord (40*25) in Reg X
    clc
    adc #$F8                 ;Screen start at 24, sprite center 12 pixel => 0xF4
    bcc ball_hit_bg_x_none
    clc
    lsr a
    lsr a
    lsr a
    cmp #0
    beq ball_hit_bg_x_none
    pha

ball_hit_bg_y_down:
    lda $d001,x              ;We Want sprites Y value converted to Char cord (40*25) in REG Y
    clc
    adc #$D6                 ;Screen start at 50, sprite center 12 pixel => 0xD8
    lsr a
    lsr a
    lsr a
    tay
    pla
    rts



ball_hit_bg_up:

    ldx main_temp_x
    txa

    lsr a
    tay      
    lda $d010                ;If sprite is on the right part of the screen above pixel 255
    and ball_bitfield,y
    beq ball_hit_bg_x_less_FF_up

ball_hit_bg_x_over_FF_up    ;ruta 30 börjar på pixel 252 ->  d000,x pixel 0-3 = 0, 4-b = 1, osv
    lda $d000,x          ;256 equals column 30 and 4 pixels chars  (240 + 4 + c)    
    clc
    adc #8
    lsr a
    lsr a
    lsr a
    clc
    adc #$1e
    pha
    
    jmp ball_hit_bg_y_up
    
ball_hit_bg_x_less_FF_up:
    lda $d000,x              ;Also add sprite X value converted to Char cord (40*25) in Reg X
    clc
    adc #$F8                 ;Screen start at 24, sprite center 12 pixel => 0xF4
    bcc ball_hit_bg_x_none
    clc
    lsr a
    lsr a
    lsr a
    cmp #0
    beq ball_hit_bg_x_none
    pha

ball_hit_bg_y_up:
    lda $d001,x              ;We Want sprites Y value converted to Char cord (40*25) in REG Y
    clc
    adc #$Dc                 ;Screen start at 50, sprite center 12 pixel => 0xD8
    lsr a
    lsr a
    lsr a
    tay
 
    pla
    rts  

ball_hit_bg_x_none:
    lda #$ff
    ldy #$ff
    rts    
;----------------End Of BALL_HIT_BG-----------------



;Bitfield for easier masking of D010   ;TODO: probably we have duplicates..
ball_bitfield .byte 1,2,4,8,16,32,64,128

;-------------Alternate angle-----------------------
;ball_bounce_bat   = 1
;ball_bounce_brick = 0
;ball_bounce        .byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
;ball_bounceToggle  .byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

;if last bounce was from brick, when every second frame we should skip y
; bat bounce 2*2,1*1,2*2,...   brick bounce 2*1,1*1,2*1,...
ball_inc_y:
    lda ball_bounce,x
    bne ball_inc_y_bat
    
ball_inc_y_brick:
   lda ball_bounceToggle,x
   bne ball_inc_y_brick_skip

   lda #1
   sta ball_bounceToggle,x
   inc $d001,x
   rts

ball_inc_y_brick_skip:
    lda #0
    sta ball_bounceToggle,x
    rts
        
ball_inc_y_bat:
    inc $d001,x
    rts


ball_dec_y:
    lda ball_bounce,x
    bne ball_dec_y_bat
    
ball_dec_y_brick:
   lda ball_bounceToggle,x
   bne ball_dec_y_brick_skip

   lda #1
   sta ball_bounceToggle,x
   dec $d001,x
   rts

ball_dec_y_brick_skip:
    lda #0
    sta ball_bounceToggle,x
    rts
        
ball_dec_y_bat:
    dec $d001,x
    rts

;-------------Increase the X-position of a sprite-------------
ball_inc_x:
    lda $d000,x         
    cmp #255
    beq ball_inc_x_over
    inc $d000,x         
    jsr ball_inc_x_bounds   ;Check if ball out of bounds at right
    rts

ball_inc_x_over:
    txa
    lsr a          
    tay
    lda ball_bitfield,y
    ora $d010
    sta $d010
    inc $d000,x
ball_inc_x_over_quit:
    rts

;-------------If ball out of bounds at right side reset it to left side-------------
ball_inc_x_bounds:
    txa
    lsr a
    tay
    lda ball_bitfield,y
    and $d010
    beq ball_inc_x_bounds_quit   ;Take jump if d010 NOT set
    lda $d000,x
    cmp #80
    bcc ball_inc_x_bounds_quit
    lda ball_bitfield,y
    eor $d010
    sta $d010
    lda #12
    sta $d000,x
    lda #140                      ;TODO: QUICK FIX, see rball_dex_x also
    sta $d001,x                   ;      Avoid wired reflections.
    ;lda ball_player_1            ;Change balls owner since it changed side
    ;sta ball_owner,x
    ;txa
    ;lsr a
    ;tay
    ;lda ball_player_1_color
    ;sta $d027,y
ball_inc_x_bounds_quit:
    rts
;---------------------




;-------------Decrease the X-position of a sprite-------------
ball_dec_x:
    txa
    lsr a  
    tay
    lda ball_bitfield,y
    and $d010
    beq ball_dec_x_leftside   

ball_dec_x_rightside:
    lda $d000,x
    beq ball_dec_x_rightside_go_leftside
    dec $d000,x                   ;normal ball still on right side
    rts

ball_dec_x_rightside_go_leftside:
    lda ball_bitfield,y
    eor $d010
    sta $d010
    lda #$ff
    sta $d000,x
    rts

ball_dec_x_leftside:    
    lda $d000,x
    cmp #4
    bcc ball_dec_x_leftside_out
    dec $d000,x                   ;normal ball still on field
    rts

ball_dec_x_leftside_out:          ;Move ball to other side. Set D011
    lda ball_bitfield,y
    ora $d010
    sta $d010
    lda #80
    sta $d000,x
    lda #140                      ;Set Y to middle, othwise it might get wired reflections
    sta $d001,x                   ;TODO: QUICK FIX!!
    rts
;-------------------------------------------------



ball_changeOwner_1_to_2:
    txa 
    lsr a
    tay
    lda ball_player_2_color
    sta $d027,y
    lda ball_player_2
    sta ball_owner,x
    rts

ball_changeOwner_2_to_1:
    txa 
    lsr a
    tay
    lda ball_player_1_color
    sta $d027,y
    lda ball_player_1
    sta ball_owner,x
    rts



;--------------Reset all balls--------------------
ball_changeOwnerAll:
    txa
    pha
    tya
    pha

    txa
    cmp ball_player_1
    beq ball_changeOwnerAll_2

    ldx #0
    jsr ball_changeOwner_1_to_2
    ldx #2
    jsr ball_changeOwner_1_to_2
    ldx #4
    jsr ball_changeOwner_1_to_2
    ldx #6
    jsr ball_changeOwner_1_to_2
    ldx #8
    jsr ball_changeOwner_1_to_2
    ldx #10
    jsr ball_changeOwner_1_to_2     

    jmp ball_changeOwnerAll_end

ball_changeOwnerAll_2
    ldx #0
    jsr ball_changeOwner_2_to_1
    ldx #2
    jsr ball_changeOwner_2_to_1
    ldx #4
    jsr ball_changeOwner_2_to_1
    ldx #6
    jsr ball_changeOwner_2_to_1
    ldx #8
    jsr ball_changeOwner_2_to_1
    ldx #10
    jsr ball_changeOwner_2_to_1     

ball_changeOwnerAll_end:    
    pla
    tay
    pla
    tax
    rts


ball_unStopableActivate:
    lda #1
    sta ball_bonusUnStopable,x
    rts

ball_unStopableDeactivate:
    lda #0
    sta ball_bonusUnStopable,x
    rts

