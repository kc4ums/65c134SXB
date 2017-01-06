	.cr	6502
	.tf	timer.srec,S28
	.or	$2000
SPEED	=	$2100
	NOP
DELAY 	LDA 	SPEED
D2  	LDX 	#$FA
D1  	DEX 
	BNE 	D1
	SEC
	SBC 	#$01
	BNE 	D2
	DEY
	BNE 	DELAY
	
