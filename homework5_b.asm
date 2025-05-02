	.Include 'M64DEF.INC'
	.ORG 0x0000
	JMP main
	
	.ORG 0x0020
	JMP TIMER0_ISR
	
	.ORG Ox0014
	JMP TIMER2_ISR
	
	.ORG 0x0050
main:
	LDI R16,low(RAMEND)
	OUT SPL,R16
	LDI R16,high(RAMEND)
	OUT SLH,R16
	
	;	40.96*(10^6)/(1000*20)=2048=1024*2
	LDI R16,0b00000111
	OUT TCCR0,R16 ;n=1024
	LDI R16,254
	OUT TCNT0,R16; count from 254
	
	;	40.96*(10^6)/1=40960000=1024*40000=1024*250*(160)
	LDI R16,0x05
	OUT TCCR2,R16; n=1024
	LDI R16,6
	OUT TCNT2,R16; counting 250 times
	
	LDI R16,0x0041
	OUT TIMSK,R16; enable T0 & T2 interupt
	
	SBI DDRB,5
	CLR R16; this is the counter of T2 and each 160 times that timer 2 interupts 
		   ; will count as one second
	LDI R17,18; R17 is the duty cycle on scale of 20 ( 2<=DS<=18 )
	LDI R18,0; R18 shows the mode of decreasing or increasing the duty cycle
	         ; 1 means incresing and 0 means decreasing
	CLR R19; R19 is the counter of T0 which indicates we are in R19/20 of whole period					
	SEI
	
finish:
	JMP finish
	
	
TIMER0_ISR:
	PUSH R20
	LDI R20,254
	OUT TCNT0,R20; count from 254
	POP R20
	
	INC R19
	CP R19,R17; check if it has to be 1 or 0
	BRCS addOne
	BREQ addOne
addZero:
	CBI PORTB,5
	JMP skipAddOne
addOne:	
	SBI PORTB,5
	
skipAddOne:	
	CPI R19,20
	BREQ clrCounter
	JMP skipClr
clrCounter:
	CLR R19
skipClr:	
	RETI
	
	
	
TIMER2_ISR:
	PUSH R20
	LDI R20,6
	OUT TCNT2,R20; count from 6
	POP R20
	
	INC R16
	CPI R16,160
	BRNQ endOfT2
	CLR R16
	CPI R17,18
	BREQ changeMode
	
	CPI R17,2
	BREQ changeMode

	JMP skipModeChange

changeMode:
	PUSH R19
	LDI R19,1
	EOR R18,R19
	POP R19

skipModeChange:	
	CPI R18,0
	BREQ decDuty
	INC R17
	JMP endOfT2
decDuty:
	DEC R17
	
endOfT2:	
	RETI