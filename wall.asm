wall_activeTime = #200

wall_active: .byte 0
wall_sleep:  .byte 0,0
wall_owner:  .byte 0
wall_init:
    lda #1
    sta wall_active
    sta wall_sleep
    sta wall_sleep+1
    lda #1
    jsr wall_text_color    
    lda #2
    sta wall_owner
    lda #0

    rts

wall_update:
    lda wall_owner
    bne wall_update_p2
    ldx #1
    jsr wall_update_start
wall_update_p2:
    cmp #1
    bne wall_update_end        
    ldx #0
    jsr wall_update_start
    rts

wall_update_start:
    dec wall_active
    bne wall_update_start_end
    lda #0
    jsr wall_update_print        ;uses X
    lda #3
    sta wall_owner
    lda #1
    jsr wall_text_color 
wall_update_start_end:    
    rts

wall_update_end:
    rts    


;X=player 0,1,   A=0 erase, A=1 print
wall_update_print:
    tay
    txa
    pha
    tya
    bne wall_update_print_add   ;check erase/print
    lda #32
    jmp wall_update_print_checkPlayer
wall_update_print_add:
    lda #$a6    
wall_update_print_checkPlayer:
    cpx #0
    beq wall_update_print_pl1
    ldx #37
    jmp wall_update_deactivate_start
wall_update_print_pl1:    
    ldx #10
wall_update_deactivate_start:
    ;sta $474,x
    ;sta $474+$28,x
    ;sta $474+$50,x
    sta $474+$78,x
    sta $474+$a0,x
    sta $474+$c8,x
    sta $474+$f0,x
    sta $474+$118,x
    sta $474+$140,x
    sta $474+$168,x
    sta $474+$190,x
    sta $474+$1b8,x
    sta $474+$1e0,x
    sta $474+$208,x
    sta $474+$230,x
    sta $474+$258,x
    sta $474+$280,x
    ;sta $474+$2a8,x
    ;sta $474+$2d0,x
    ;sta $474+$2f8,x

    cmp #$a6
    bne wall_update_print_eraseCol
    lda #15
    jmp wall_update_print_color
wall_update_print_eraseCol:
    lda #6    
    
wall_update_print_color:
    ;sta $d874,x
    ;sta $d874+$28,x
    ;sta $d874+$50,x
    sta $d874+$78,x
    sta $d874+$a0,x
    sta $d874+$c8,x
    sta $d874+$f0,x
    sta $d874+$118,x
    sta $d874+$140,x
    sta $d874+$168,x
    sta $d874+$190,x
    sta $d874+$1b8,x
    sta $d874+$1e0,x
    sta $d874+$208,x
    sta $d874+$230,x
    sta $d874+$258,x
    sta $d874+$280,x
    ;sta $d874+$2a8,x
    ;sta $d874+$2d0,x
    ;sta $d874+$2f8,x

    pla
    tax
    rts
 
 

wall_hit:
    ldx main_temp_x
    lda ball_owner,x    
    cmp ball_player_1
    beq wall_hit_p1
    cmp ball_player_2
    beq wall_hit_p2
    rts
   
   
wall_hit_p1:
    txa
    pha
    lda #1
    ldx #1
    jsr wall_update_print   
    pla
    tax
    lda #0
    sta wall_owner
    lda #5
    jsr wall_text_color
    lda wall_activeTime
    sta wall_active
    rts 
    
wall_hit_p2:
    txa
    pha 
    lda #1
    ldx #0
    jsr wall_update_print   
    pla
    tax
    lda #1
    sta wall_owner
    lda #5
    jsr wall_text_color
    lda wall_activeTime
    sta wall_active
    rts 
    
wall_text_color:
    sta $dbd2
    sta $dbd3
    sta $dbd4
    sta $dbd5
    rts        
