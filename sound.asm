
sound_delay_cnt: .byte 0
sound_delay_lim = #15

sound_init_game:
    lda #0
    jsr $5f80
    rts

sound_init_menu:
    lda #1
    jsr $5f80
    lda #<sound_isr_only   ;Set raster interrupt position
    sta $fffe
    lda #>sound_isr_only
    sta $ffff
    lda #80     ;this is how to tell the VICII to generate a raster interrupt
    sta $d012
    lda #1
    sta $d01a
    cli
    rts

sound_setIsr:
    lda #$
    lda #<sound_isr   ;Set raster interrupt position
    sta $fffe
    lda #>sound_isr
    sta $ffff
    lda #160     ;this is how to tell the VICII to generate a raster interrupt
    sta $d012
    rts


sound_isr:
    pha
    txa
    pha
    tya
    pha
    php
    ;lda #4
    ;sta $d020
    lda sound_delay_cnt
    cmp sound_delay_lim
    beq sound_isr_cont
    inc sound_delay_cnt
sound_isr_cont:    
    jsr $5012
    jsr game_setIsr
    asl $d019
    ;dec $d020
    plp
    pla
    tay
    pla
    tax
    pla
    ;lda #0
    ;sta $d020
    rti
    
sound_isr_only:
    pha
    txa
    pha
    tya
    pha
    php
    lda sound_delay_cnt
    cmp sound_delay_lim
    beq sound_isr_only_cont
    inc sound_delay_cnt
sound_isr_only_cont:    
    ;inc $d020
    jsr $5012
    asl $d019
    ;lda #0
    ;sta $d020
    plp
    pla
    tay
    pla
    tax
    pla
    rti
   
