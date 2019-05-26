wall_sleepTime  = #250
wall_activeTime = #100

wall_active: .byte 0,0
wall_sleep:  .byte 0,0

wall_init:
    lda #1
    sta wall_active+1
    sta wall_active
    sta wall_sleep
    sta wall_sleep+1
    rts

wall_update:
    ldx #0
    jsr wall_update_start
    ldx #1
    jsr wall_update_start
    rts

wall_update_start:
    jsr wall_update_check
    lda wall_active,x
    beq wall_update_sleep
    dec wall_active,x
    beq wall_update_deactivate
wall_update_sleep:
    lda wall_sleep,x
    beq wall_update_end
    dec wall_sleep,x

wall_update_end:
    rts    




wall_update_check
    lda wall_sleep,x
    bne wall_update_check_end
    lda $dc00,x
    and #%00000100
    bne wall_update_check_end    
    lda wall_activeTime
    sta wall_active,x
    lda wall_sleepTime
    sta wall_sleep,x
    lda #1
    jsr wall_update_print
    rts
    
    
wall_update_check_end;    
    rts


wall_update_deactivate:
    lda #0
    jsr wall_update_print
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
    ldx #39
    jmp wall_update_deactivate_start
wall_update_print_pl1:    
    ldx #8
wall_update_deactivate_start:
    sta $474,x
    sta $474+$28,x
    sta $474+$50,x
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
    sta $474+$2a8,x
    sta $474+$2d0,x
    sta $474+$2f8,x

    cmp #$a6
    bne wall_update_print_eraseCol
    lda #15
    jmp wall_update_print_color
wall_update_print_eraseCol:
    lda #6    
    
wall_update_print_color:
    sta $d874,x
    sta $d874+$28,x
    sta $d874+$50,x
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
    sta $d874+$2a8,x
    sta $d874+$2d0,x
    sta $d874+$2f8,x

    pla
    tax
    rts
        
