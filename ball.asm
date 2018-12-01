

TOP    = #0
BOTTOM = #1
RIGHT  = #2
LEFT   = #3
RIGHT_BAT  = #4
LEFT_BAT   = #5
NONE   = #6

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
sprite_1:
.byte $00,$00,$00,$00,$00,$00,$00,$00
.byte $00,$00,$00,$00,$00,$00,$00,$00
.byte $00,$00,$00,$00,$00,$00,$3c,$00
.byte $00,$eb,$00,$00,$eb,$00,$00,$eb
.byte $00,$00,$eb,$00,$00,$eb,$00,$00
.byte $3c,$00,$00,$00,$00,$00,$00,$00
.byte $00,$00,$00,$00,$00,$00,$00,$00
.byte $00,$00,$00,$00,$00,$00,$00,$85

balls_state  .byte 1,0,1,0,1,0,4,0,4,0,4,1,0,1,0,1

ball_player_1 = #1
ball_player_2 = #2
ball_owner  .byte 1,0,1,0,1,0,2,0,2,0,2,0,0,0,0,0
ball_player_1_color = #5
ball_player_2_color = #2
ball_current .byte 0

dir_0 = 4




ball_init:
           lda #$3f
           sta $d015    ; Turn sprite 0 on
           sta $d027    ; Make it white
           lda ball_player_1_color
           sta $d027
           lda ball_player_1_color
           sta $d028
           lda ball_player_1_color
           sta $d029
           lda ball_player_2_color
           sta $d02a
           lda ball_player_2_color
           sta $d02b
           lda ball_player_2_color
           sta $d02c

           lda #$30
           sta $d010    ; Pl2 sprites starts at right part screen

           lda #50
           sta $d000    ; set x coordinate to 40
           lda #$40
           sta $d001    ; set y coordinate to 40

           lda #70
           sta $d002    ; set x coordinate to 40
           lda #$60
           sta $d003    ; set y coordinate to 40

           lda #90
           sta $d004    ; set x coordinate to 40
           lda #$80
           sta $d005    ; set y coordinate to 40
           
           
           lda #248
           sta $d006    ; set x coordinate to 40
           lda #$80
           sta $d007    ; set y coordinate to 40
           
           lda #17
           sta $d008    ; set x coordinate to 40
           lda #$60
           sta $d009    ; set y coordinate to 40

           lda #37      ; left is 27in -> right 316 = 255 + 61 -> -24 sprite width => 37
           sta $d00a    ; set x coordinate to 40
           lda #$40
           sta $d00b    ; set y coordinate to 40


           lda #$80
           sta $07f8    ; set pointer: sprite data at $2000
           sta $07f9    ; set pointer: sprite data at $2000
           sta $07fa    ; set pointer: sprite data at $2000
           sta $07fb    ; set pointer: sprite data at $2000
           sta $07fc    ; set pointer: sprite data at $2000
           sta $07fd    ; set pointer: sprite data at $2000
    
           lda $d01c    ; enable multicolor sprites
           ora #$3f
           sta $d01c

            ldx #63
fill:
            lda sprite_1,x
            sta $2000,x
            dex
            bne fill

            lda #0
            sta dir_0

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
    jsr ball_dec_x
    inc $d001,x
    jmp ball_update_end
    
 leftDownChangeToUp
    lda LEFT_UP
    sta balls_state,x       
    jmp ball_update_end

leftDownChangeRight:
    lda RIGHT_DOWN      ;left hit -> rightDown
    sta balls_state,x       
    jmp ball_update_end

leftDownChangeToStraight:
    lda RIGHT_STRAIGHT
    sta balls_state,x       
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
    jsr ball_inc_x
    inc $d001,x
    jmp ball_update_end

rightDownChangeToUp:
    lda RIGHT_UP
    sta balls_state,x       
    jmp ball_update_end

rightDownChangeToStraight:
    lda LEFT_STRAIGHT
    sta balls_state,x       
    jmp ball_update_end
    
rightDownChangeRight:
    lda LEFT_DOWN
    sta balls_state,x       
           
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
    jsr ball_inc_x
    dec $d001,x
    jmp ball_update_end

rightUpChangeToLeft:
    lda LEFT_UP
    sta balls_state,x       
    jmp ball_update_end

rightUpChangeToStraight:
    lda LEFT_STRAIGHT
    sta balls_state,x       
    jmp ball_update_end

rightUpChangeToDown:
    lda RIGHT_DOWN
    sta balls_state,x       
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
    jsr ball_dec_x
    dec $d001,x       
    jmp ball_update_end

ball_leftUpChangeDown:
    lda LEFT_DOWN
    sta balls_state,x       
    jmp ball_update_end

ball_leftUpChangeStraight:
    lda RIGHT_STRAIGHT
    sta balls_state,x       
    jmp ball_update_end

ball_leftUpChangeRight:
    lda RIGHT_UP
    sta balls_state,x       
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
    bne ball_hit_none_ret
    jsr bat_hit_1
    cmp NONE
    bne ball_hit_none_ret
    jsr bat_hit_2
ball_hit_none_ret:
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
    cmp #128
    beq ball_hit_bonus_1
    cmp #102                      ;TODO: this must support more kinds of 
    beq ball_hit_char_hit
    cmp #$41
    beq ball_hit_char_brick_1
    cmp #$40
    beq ball_hit_char_brick_1
    cmp #$60
    bcc ball_hit_char_brick_2
    lda #0
    rts
ball_hit_char_brick_1:
    jsr gameBg_hit_1
    jmp ball_hit_char_hit
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

ball_hit_char_hit:
    lda #1    
    rts
;---------------------


;------------Check if ball collides with a CHAR-----------------
ball_hit_bg:
    stx main_temp_x          ;Pusha X till stacken!!!  
    txa                      ;DO HW check if ball collides with ANY char                     
    lsr a
    tay  
    lda $d01f
    ora ball_temp_d01f
    sta ball_temp_d01f      
    lda ball_bitfield,y
    and ball_temp_d01f
    beq ball_hit_bg_none

    lda $d010                ;If sprite is on the right part of the screen above pixel 255
    and ball_bitfield,y
    beq ball_hit_bg_less_FF
    ldy #$1f                 ;256 equals 32 chars
    sty ball_temp
    jmp ball_hit_bg_calc_xy
ball_hit_bg_less_FF:
    ldy #0    
    sty ball_temp

ball_hit_bg_calc_xy    
    lda $d001,x              ;We Want sprites Y value converted to Char cord (40*25) in REG Y
    clc
    adc #$D9                 ;Screen start at 50, sprite center 11 pixel => 0xD9
    lsr a
    lsr a
    lsr a
    tay
    
   
    lda $d000,x              ;Also add sprite X value converted to Char cord (40*25) in Reg X
    clc
    adc #$F4                 ;Screen start at 24, sprite center 12 pixel => 0xF4
    lsr a
    lsr a
    lsr a
    adc ball_temp 
    tax

    dey                      ;We start to search for at hit ABOVE the sprite
    jsr ball_hit_char        
    cmp #1
    bne ball_hit_bg_bottom
    lda TOP
    ldx main_temp_x    
    rts
ball_hit_bg_bottom:
    iny                      ;Move down and search BELOW the sprite
    iny 
    jsr ball_hit_char
    cmp #1
    bne ball_hit_bg_left
    lda BOTTOM
    ldx main_temp_x    
    rts
ball_hit_bg_left:
    dey                      ;Check for hit to the LEFT
    dex 
    jsr ball_hit_char
    cmp #1    
    bne ball_hit_bg_right
    lda LEFT
    ldx main_temp_x    
    rts
ball_hit_bg_right:
    inx                      ;Check for hit RIGHT to the sprite
    inx 
    jsr ball_hit_char
    cmp #1    
    bne ball_hit_bg_top2
    lda RIGHT
    ldx main_temp_x    
    rts
ball_hit_bg_top2:
    dex                      ;search for hit inside the sprite, TODO: needed??
    jsr ball_hit_char
    cmp #1    
    bne ball_hit_bg_none
    lda TOP
    ldx main_temp_x    
    rts

    ldx main_temp_x
    rts
ball_hit_bg_none:
    lda NONE
    ldx main_temp_x
    rts
;----------------End Of BALL_HIT_BG-----------------



;Bitfield for easier masking of D010   ;TODO: probably we have duplicates..
ball_bitfield .byte 1,2,4,8,16,32,64,128


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
    lda ball_player_1            ;Change balls owner since it changed side
    sta ball_owner,x
    txa
    lsr a
    tay
    lda ball_player_1_color
    sta $d027,y
ball_inc_x_bounds_quit:
    rts
;---------------------


;-------------Decrease the X-position of a sprite-------------
ball_dec_x:
    lda $d000,x         
    cmp #0
    beq ball_dec_x_over
    dec $d000,x         
    rts

ball_dec_x_over:
    txa
    lsr a  
    tay
    jsr ball_dec_x_bounds          ;Check is out of bounds at left side
    beq ball_dec_x_over_quit
    lda ball_bitfield,y
    eor $d010
    sta $d010
    dec $d000,x
ball_dec_x_over_quit:
    rts



;-------------If sprite gets outside field at left set it to right side-------------
 ball_dec_x_bounds:
    lda ball_bitfield,y
    and $d010
    bne ball_dec_x_bounds_quit   ;Take jump if d010 set -> zero bit not set 
    lda ball_bitfield,y
    ora $d010
    sta $d010
    lda #80
    sta $d000,x
    lda ball_player_2            ;Change balls owner since it changed side
    sta ball_owner,x
    txa
    lsr a
    tay
    lda ball_player_2_color
    sta $d027,y
    
    lda #0                       ;set the zero bit
ball_dec_x_bounds_quit:
    rts


