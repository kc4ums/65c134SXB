	.cr	6502
	.tf	foxhunt.srec,S28
	.or	$2000
speed	=	$2100
	lda	#$01
	sta	$001f		;port 5 bit 1 is output
	lda 	#$ff
	sta	$001d		;port 5 bit one set
	lda	#$00
	sta	$2101		;location of beacon string
	;; main routine start
newchar	ldy	$2101		;pointer to first letter
	ldx	#$00		;start of lookup table
find	inx
	lda 	$2900,Y		;letter to look-up
	cmp	$2fff,X		;lookup loop
	bne	find
	iny
	sty	$2101
	lda	$304f,X		;morse representation of character
shift	lsr
	pha			;push letter on stack
	bcs	dit
	bcc	dah
dah	jmp	keydit
dit	jmp	keydah
compare	pla			;pop letter off of stack after rts
	cmp 	#$01
	bne	shift
	lda	$2100
	cmp	#$5d
	beq	end
	jmp 	newchar
	
	                                                                  
;;; key dit 
keydit	lda	#$01
	sta	$2100
	jsr 	delay
	;; rig keying
	ldx 	#$fe
	stx	$001d		;key rig
	lda	#$01
	sta	$2100
	jsr	delay
	ldx 	#$ff
	stx	$001d		;unkey rig
	jmp 	compare		;dit is done
	
;;; key dit 
keydah	lda	#$01
	sta	$2100
	jsr 	delay
	;; rig keying
	ldx 	#$fe
	stx	$001d		;key rig
	lda	#$02
	sta	$2100
	jsr	delay
	ldx 	#$ff
	stx	$001d		;unkey rig
	jmp 	compare		;dah is done

;;; delay sub routine
delay 	lda 	speed
d2  	ldx 	#$fa
d1  	dex 
	bne 	d1
	sec
	sbc 	#$01
	bne 	d2
	dey
	bne 	delay
	rts

;;; end of routine	
end	nop

	
	;;  lookup table for characters to morse
	.or	$2900
	.db	"KC4UMS/B EM81HM]"	;"]" is the termintation charcater for string 
	.or 	$3000
	.db	"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"
	.or	$3050
	.hs	3f.3e.3c.38.30.20.21.23.27.2f.06.11.15.09.03.1b.0b.10.04.1e.0d.12.07.05.08.16.1B.0A.08.03.0c.18.0e.19.1d.13
	.or	$3100

	
