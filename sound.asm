
; #0  -  intro tune
; #6  -  game tune
; #3  -  tune song end
;
;

sound_effec_delay_value = 4
sound_delay_cnt: .byte 0         ;Counter to make the menus a move at a good speed
sound_delay_lim = #15
sound_random_value .byte 0
sound_songToPlay .byte 0
sound_effect_delay .byte 0

sound_init_game:
    lda #1 ;TODO change back 
    ;lda #6
    jsr $1000
    rts

sound_init_menu:
    lda sound_songToPlay
    jsr $1000
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
    jsr $1003
    jsr game_setIsr
    asl $d019
    ;dec $d020

    ;----Dec sound effect counter
    lda sound_effect_delay
    beq sound_isr_rand
    dec sound_effect_delay

    ;----make some random number
sound_isr_rand:    
    lda $d012 
    eor $dc04 
    sbc $dc05 
    sta sound_random_value

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
    jsr $1003
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
   

sound_playBrick:
    lda sound_effect_delay
    bne sound_playReturn 
    lda sound_effec_delay_value
    sta sound_effect_delay
    lda #$3b
    sta $12ef
    lda #0
    sta $12e0
    inc $d020
sound_playBrick_end:    
    rts
sound_playPlayer1Claim:
    lda sound_effect_delay
    bne sound_playReturn 
    lda sound_effec_delay_value
    sta sound_effect_delay
    lda #$66
    sta $12ef
    lda #0
    sta $12e0
    rts    
sound_playPlayer2Claim:
    lda sound_effect_delay
    bne sound_playReturn 
    lda sound_effec_delay_value
    sta sound_effect_delay
    lda #$6e
    sta $12ef
    lda #0
    sta $12e0
    rts    
sound_playBricksReappear:
    lda sound_effect_delay
    bne sound_playReturn 
    lda sound_effec_delay_value
    sta sound_effect_delay
    lda #$48
    sta $12ef
    lda #0
    sta $12e0
    rts
sound_playBonusLarge:
    lda sound_effect_delay
    bne sound_playReturn 
    lda sound_effec_delay_value
    sta sound_effect_delay
    lda #$4e
    sta $12ef
    lda #0
    sta $12e0
    rts
sound_playBonusSmall:
    lda sound_effect_delay
    bne sound_playReturn 
    lda sound_effec_delay_value
    sta sound_effect_delay
    lda #$52
    sta $12ef
    lda #0
    sta $12e0
    rts
sound_playBonusUnStopable:
    lda sound_effect_delay
    bne sound_playReturn 
    lda sound_effec_delay_value
    sta sound_effect_delay
    lda #$76
    sta $12ef
    lda #0
    sta $12e0
    rts
sound_playBonusBullet:
    lda sound_effect_delay
    bne sound_playReturn 
    lda sound_effec_delay_value
    sta sound_effect_delay
    lda #$57
    sta $12ef
    lda #0
    sta $12e0
    rts
sound_playBonusBulletShoot:
    lda sound_effect_delay
    bne sound_playReturn 
    lda sound_effec_delay_value
    sta sound_effect_delay
    lda #$5f
    sta $12ef
    lda #0
    sta $12e0
    rts
sound_playBonusOwnAll:
    lda sound_effect_delay
    bne sound_playReturn 
    lda sound_effec_delay_value
    sta sound_effect_delay
    lda #$7d
    sta $12ef
    lda #0
    sta $12e0
    rts

sound_playReturn
    rts



;--------HT SOUND EFFECT-------------
sound_playHtActive .byte 0    
sound_playHtCounter .byte 0   

sound_playHtStart:
    lda #1
    sta sound_playHtActive
    rts
sound_playHtStop:
    lda #0
    sta sound_playHtActive
    rts



sound_playHt:
    lda sound_playHtActive
    beq sound_playHtEnd
    lda sound_playHtCounter
    cmp #10
    bne sound_playHtNoTrigg
    lda #$3e
    sta $12ef
    lda #0
    sta $12e0
    sta sound_playHtCounter
sound_playHtNoTrigg:
    inc sound_playHtCounter
    rts
sound_playHtEnd:
    sta sound_playHtCounter    
    rts


