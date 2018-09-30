

TOP    = #0
BOTTOM = #1
RIGHT  = #2
LEFT   = #3
NONE   = #5

; 1  =  Right down
; 2  =  Right up
; 3  =  Left up 
; 4  =  Left down
RIGHT_DOWN = #1
RIGHT_UP   = #2
LEFT_UP    = #3
LEFT_DOWN  = #4


sprite_1:
.byte $00,$7e,$00,$03,$ff,$c0,$07,$ff
.byte $e0,$1f,$ff,$f8,$1f,$ff,$f8,$3f
.byte $ff,$fc,$7f,$ff,$fe,$7f,$ff,$fe
.byte $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
.byte $ff,$ff,$ff,$ff,$ff,$ff,$ff,$7f
.byte $ff,$fe,$7f,$ff,$fe,$3f,$ff,$fc
.byte $1f,$ff,$f8,$1f,$ff,$f8,$07,$ff
.byte $e0,$03,$ff,$c0,$00,$7e,$00,$00

balls_state  .byte 1,0,2,1,3,1,4,1,0,1,0,1,0,1,0,1

dir_0 = 4




ball_init:
           lda #0
           sta $d010    ; no sprites starts at right part screen

           lda #$0f
           sta $d015    ; Turn sprite 0 on
           sta $d027    ; Make it white
           lda #04
           sta $d027
           lda #05
           sta $d028
           lda #06
           sta $d029
           lda #07
           sta $d02a

           lda #255
           sta $d000    ; set x coordinate to 40
           lda #40
           sta $d001    ; set y coordinate to 40

           lda #128
           sta $d002    ; set x coordinate to 40
           lda #80
           sta $d003    ; set y coordinate to 40

           lda #40
           sta $d004    ; set x coordinate to 40
           lda #60
           sta $d005    ; set y coordinate to 40
           
           lda #60
           sta $d006    ; set x coordinate to 40
           lda #160
           sta $d007    ; set y coordinate to 40
           
           lda #$80
           sta $07f8    ; set pointer: sprite data at $2000
           lda #$80
           sta $07f9    ; set pointer: sprite data at $2000
           lda #$80
           sta $07fa    ; set pointer: sprite data at $2000
           lda #$80
           sta $07fb    ; set pointer: sprite data at $2000
    
            ldx #63
fill:
            lda sprite_1,x
            sta $2000,x
            dex
            bne fill

            lda #0
            sta dir_0

            lda #<ball_isr   ;Set raster interrupt position
            sta $fffe
            lda #>ball_isr
            sta $ffff
            lda #100 
            sta $d012
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

ball_isr
    inc $d021
    ldx #0
    jsr ball_update
    ldx #2
    jsr ball_update
    ldx #4
    jsr ball_update
    ldx #6
    jsr ball_update
    dec $d021
    asl $d019
    rti


ball_update:
    lda balls_state,x

    cmp RIGHT_DOWN
    beq ball_rightDown
    cmp RIGHT_UP
    beq ball_rightUp
    cmp LEFT_UP
    beq ball_leftUp
 

 ;-------------------------------
 ball_leftDown:
    jsr ball_hit
    cmp LEFT                    ;hit left wall
    beq leftDownChangeRight
    cmp BOTTOM
    beq leftDownChangeToUp
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

;-------------------------------
ball_rightDown:
    jsr ball_hit 
    cmp RIGHT                    ;hit left wall
    beq rightDownChangeRight
    cmp BOTTOM
    beq rightDownChangeToUp

    jsr ball_inc_x
    inc $d001,x
    jmp ball_update_end

rightDownChangeToUp:
    lda RIGHT_UP
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
    jsr ball_inc_x
    dec $d001,x
    jmp ball_update_end

rightUpChangeToLeft:
    lda LEFT_UP
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
    jsr ball_dec_x
    dec $d001,x       
    jmp ball_update_end

ball_leftUpChangeDown:
    lda LEFT_DOWN
    sta balls_state,x       
    jmp ball_update_end

ball_leftUpChangeRight:
    lda RIGHT_UP
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
    lsr  ;f
    tay
    lda ball_bitfield,y
    and $d010
    bne ball_hit_right
    lda $d000,x
    cmp #24
    beq ball_hitLeft
    
 ball_hit_right:   
    txa
    lsr    ;f
    tay
    lda ball_bitfield,y
    and $d010
    ;cmp #1
    beq ball_hit_none
    lda $d000,x
    cmp #64
    bne ball_hit_none
    lda RIGHT
    rts

ball_hit_none:
    lda NONE
    rts

ball_hitLeft:
    lda LEFT
    rts

ball_hitBottom:
    lda BOTTOM
    rts

ball_hitTop:
    lda TOP
    rts




ball_bitfield .byte 1,2,4,8,16,32,64,128


;x = 0,2,4,6,8,10,12,14   
ball_inc_x:
    lda $d000,x         
    cmp #255
    beq ball_inc_x_over
    inc $d000,x         
    rts

ball_inc_x_over:
    txa
    lsr          ;f
    tay
    lda ball_bitfield,y
    ora $d010
    sta $d010
    inc $d000,x
    rts
;----------------------



ball_dec_x:
    lda $d000,x         
    cmp #0
    beq ball_dec_x_over
    dec $d000,x         
    rts

ball_dec_x_over:
    txa
    lsr   ;f
    tay
    lda ball_bitfield,y
    eor $d010
    sta $d010
    dec $d000,x
    rts
