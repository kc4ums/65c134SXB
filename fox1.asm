	.cr	6502
	.tf	foxhunt.srec,S28
	.or	$2000
char	=	$2100
morse	=	$2101		;holds the morse word that is shifted right one bit at a time
speed	=	$2102		;delay time for delay subroutine	
next	=	$2103		;pointer to next beacon character
beacon	=	$2900		;beacon string
	
	lda	#$01
	sta	$001f		;port 5 bit 1 is output
	lda 	#$ff
	sta	$001d		;port 5 bit one set
	lda	#$00
	sta	next		;pointer to next beacon character

main	nop
	jsr	get		;next beacon character
	jsr 	lookup		;lookup next morse character to transmit in table
shift	lda 	morse		;morse character register
	lsr			;shift right one bit
	sta	morse		;save the new morse character
	bcs	dit		;if carry set this is a dit
	bcc	dah		;if carry clear this is a dah
dah	jmp	keydit		;dit routine
dit	jmp	keydah		;dah routine
compare	lda	morse		;is this the last dit or dah that has been shift 
	cmp 	#$01		;is this the last bit
	bne	shift		;if no continue shifting out dit or dah
	lda	#$02		;delay for space between morse characters
	sta	speed		;delay for space between morse characters
	jsr	delay		;delay for space between morse characters
	beq	main		;get the next  character
	jmp	end		;you SHOULD NOT end here


	;; get the next beacon character
get	ldx	next
	lda	beacon,X
	cmp	#$5d
	beq	end
	sta	char
	inx
	stx	next
	rts
	
	
	;; lookup character in morse table
lookup	ldx	#$00		;start of lookup table
	lda 	char		;letter to look-up
find	inx			;increment index register
	cmp	$2fff,X		;lookup loop
	bne	find		;keep looking till we find it
	lda	$304f,X		;morse representation of character
	sta	morse		;store in morse register
	rts			;return to calling routine

	
	                                                                  
;;; key dit 
keydit	lda	#$01
	sta	speed
	jsr 	delay
	;; rig keying
	ldx 	#$fe
	stx	$001d		;key rig
	lda	#$01
	sta	speed
	jsr	delay
	ldx 	#$ff
	stx	$001d		;unkey rig
	jmp 	compare		;dit is done
	
;;; key dah
keydah	lda	#$01
	sta	speed
	jsr 	delay
	;; rig keying
	ldx 	#$fe
	stx	$001d		;key rig
	lda	#$02
	sta	speed
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
	.db	"KC4UMS/B]"	;"]" is the termintation charcater for string 
	.or 	$3000
	.db	"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ/"
	.or	$3050
	.hs	3f.3e.3c.38.30.20.21.23.27.2f.06.11.15.09.02.14.0b.10.04.1e.0d.12.07.05.0f.16.1B.0A.08.03.0c.18.0e.19.1d.13.29
	.or	$3100

	
