
_usDelay:

;ULTRASONIC_SHITE.c,20 :: 		void usDelay(unsigned int usCnt){
;ULTRASONIC_SHITE.c,21 :: 		unsigned int us=0;
	CLRF       usDelay_us_L0+0
	CLRF       usDelay_us_L0+1
;ULTRASONIC_SHITE.c,23 :: 		for(us=0;us<usCnt;us++){
	CLRF       usDelay_us_L0+0
	CLRF       usDelay_us_L0+1
L_usDelay0:
	MOVF       FARG_usDelay_usCnt+1, 0
	SUBWF      usDelay_us_L0+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__usDelay31
	MOVF       FARG_usDelay_usCnt+0, 0
	SUBWF      usDelay_us_L0+0, 0
L__usDelay31:
	BTFSC      STATUS+0, 0
	GOTO       L_usDelay1
;ULTRASONIC_SHITE.c,24 :: 		asm NOP;//0.5 uS
	NOP
;ULTRASONIC_SHITE.c,25 :: 		asm NOP;//0.5uS
	NOP
;ULTRASONIC_SHITE.c,23 :: 		for(us=0;us<usCnt;us++){
	INCF       usDelay_us_L0+0, 1
	BTFSC      STATUS+0, 2
	INCF       usDelay_us_L0+1, 1
;ULTRASONIC_SHITE.c,26 :: 		}
	GOTO       L_usDelay0
L_usDelay1:
;ULTRASONIC_SHITE.c,28 :: 		}
L_end_usDelay:
	RETURN
; end of _usDelay

_msDelay:

;ULTRASONIC_SHITE.c,30 :: 		void msDelay(unsigned int msCnt){
;ULTRASONIC_SHITE.c,31 :: 		unsigned int ms=0;
	CLRF       msDelay_ms_L0+0
	CLRF       msDelay_ms_L0+1
	CLRF       msDelay_cc_L0+0
	CLRF       msDelay_cc_L0+1
;ULTRASONIC_SHITE.c,33 :: 		for(ms=0;ms<(msCnt);ms++){
	CLRF       msDelay_ms_L0+0
	CLRF       msDelay_ms_L0+1
L_msDelay3:
	MOVF       FARG_msDelay_msCnt+1, 0
	SUBWF      msDelay_ms_L0+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__msDelay33
	MOVF       FARG_msDelay_msCnt+0, 0
	SUBWF      msDelay_ms_L0+0, 0
L__msDelay33:
	BTFSC      STATUS+0, 0
	GOTO       L_msDelay4
;ULTRASONIC_SHITE.c,34 :: 		for(cc=0;cc<155;cc++);//1ms
	CLRF       msDelay_cc_L0+0
	CLRF       msDelay_cc_L0+1
L_msDelay6:
	MOVLW      0
	SUBWF      msDelay_cc_L0+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__msDelay34
	MOVLW      155
	SUBWF      msDelay_cc_L0+0, 0
L__msDelay34:
	BTFSC      STATUS+0, 0
	GOTO       L_msDelay7
	INCF       msDelay_cc_L0+0, 1
	BTFSC      STATUS+0, 2
	INCF       msDelay_cc_L0+1, 1
	GOTO       L_msDelay6
L_msDelay7:
;ULTRASONIC_SHITE.c,33 :: 		for(ms=0;ms<(msCnt);ms++){
	INCF       msDelay_ms_L0+0, 1
	BTFSC      STATUS+0, 2
	INCF       msDelay_ms_L0+1, 1
;ULTRASONIC_SHITE.c,35 :: 		}
	GOTO       L_msDelay3
L_msDelay4:
;ULTRASONIC_SHITE.c,37 :: 		}
L_end_msDelay:
	RETURN
; end of _msDelay

_interrupt:
	MOVWF      R15+0
	SWAPF      STATUS+0, 0
	CLRF       STATUS+0
	MOVWF      ___saveSTATUS+0
	MOVF       PCLATH+0, 0
	MOVWF      ___savePCLATH+0
	CLRF       PCLATH+0

;ULTRASONIC_SHITE.c,41 :: 		void interrupt(void){
;ULTRASONIC_SHITE.c,42 :: 		if(INTCON & 0x02){// will get here every falling on the external interrupt pin
	BTFSS      INTCON+0, 1
	GOTO       L_interrupt9
;ULTRASONIC_SHITE.c,46 :: 		INTCON =  INTCON & 0xFD;// Clear External IF (Bit 1 in INTCON)
	MOVLW      253
	ANDWF      INTCON+0, 1
;ULTRASONIC_SHITE.c,47 :: 		}
L_interrupt9:
;ULTRASONIC_SHITE.c,49 :: 		if(INTCON & 0x04)
	BTFSS      INTCON+0, 2
	GOTO       L_interrupt10
;ULTRASONIC_SHITE.c,51 :: 		TMR0=248;
	MOVLW      248
	MOVWF      TMR0+0
;ULTRASONIC_SHITE.c,52 :: 		tick++;// will increment every 1 ms
	INCF       _tick+0, 1
	BTFSC      STATUS+0, 2
	INCF       _tick+1, 1
;ULTRASONIC_SHITE.c,54 :: 		INTCON = INTCON & 0xFB; //Clear TMR0 IF
	MOVLW      251
	ANDWF      INTCON+0, 1
;ULTRASONIC_SHITE.c,56 :: 		}
L_interrupt10:
;ULTRASONIC_SHITE.c,58 :: 		}
L_end_interrupt:
L__interrupt36:
	MOVF       ___savePCLATH+0, 0
	MOVWF      PCLATH+0
	SWAPF      ___saveSTATUS+0, 0
	MOVWF      STATUS+0
	SWAPF      R15+0, 1
	SWAPF      R15+0, 0
	RETFIE
; end of _interrupt

_main:

;ULTRASONIC_SHITE.c,60 :: 		void main(){
;ULTRASONIC_SHITE.c,61 :: 		TRISB = 0b00010000;  //RB4 as Input PIN (ECHO)
	MOVLW      16
	MOVWF      TRISB+0
;ULTRASONIC_SHITE.c,62 :: 		TRISC = 0x00;
	CLRF       TRISC+0
;ULTRASONIC_SHITE.c,63 :: 		TRISD = 0x00;
	CLRF       TRISD+0
;ULTRASONIC_SHITE.c,64 :: 		TRISA = 0b11111; //A is an input port
	MOVLW      31
	MOVWF      TRISA+0
;ULTRASONIC_SHITE.c,65 :: 		OPTION_REG= 0x87; //This will cause TMR0 clock to scale to a point where every count takes 128 uSeconds
	MOVLW      135
	MOVWF      OPTION_REG+0
;ULTRASONIC_SHITE.c,67 :: 		INTCON=0xB0; // enabling global interrupts, TMR0 interrupts and external interrupts
	MOVLW      176
	MOVWF      INTCON+0
;ULTRASONIC_SHITE.c,69 :: 		while(1)
L_main11:
;ULTRASONIC_SHITE.c,71 :: 		mymsDelay(200);
	MOVLW      200
	MOVWF      FARG_mymsDelay+0
	CLRF       FARG_mymsDelay+1
	CALL       _mymsDelay+0
;ULTRASONIC_SHITE.c,74 :: 		ATDinit_A();    //prepare ATD converter
	CALL       _ATDinit_A+0
;ULTRASONIC_SHITE.c,75 :: 		AMBIENT_TEMP = ATDread();   //Read ATD converter
	CALL       _ATDread+0
	MOVF       R0+0, 0
	MOVWF      _AMBIENT_TEMP+0
	MOVF       R0+1, 0
	MOVWF      _AMBIENT_TEMP+1
;ULTRASONIC_SHITE.c,76 :: 		if(AMBIENT_TEMP <= 550)
	MOVF       R0+1, 0
	SUBLW      2
	BTFSS      STATUS+0, 2
	GOTO       L__main38
	MOVF       R0+0, 0
	SUBLW      38
L__main38:
	BTFSS      STATUS+0, 0
	GOTO       L_main13
;ULTRASONIC_SHITE.c,77 :: 		set_ambient_blue();
	CALL       _set_ambient_blue+0
	GOTO       L_main14
L_main13:
;ULTRASONIC_SHITE.c,80 :: 		set_ambient_red();
	CALL       _set_ambient_red+0
L_main14:
;ULTRASONIC_SHITE.c,81 :: 		mymsDelay(200);
	MOVLW      200
	MOVWF      FARG_mymsDelay+0
	CLRF       FARG_mymsDelay+1
	CALL       _mymsDelay+0
;ULTRASONIC_SHITE.c,84 :: 		ATDinit_W();   //prepare ATD converter
	CALL       _ATDinit_W+0
;ULTRASONIC_SHITE.c,85 :: 		WATER_TEMP = ATDread();    //Read ATD converter
	CALL       _ATDread+0
	MOVF       R0+0, 0
	MOVWF      _WATER_TEMP+0
	MOVF       R0+1, 0
	MOVWF      _WATER_TEMP+1
;ULTRASONIC_SHITE.c,86 :: 		if(WATER_TEMP <= 550)
	MOVF       R0+1, 0
	SUBLW      2
	BTFSS      STATUS+0, 2
	GOTO       L__main39
	MOVF       R0+0, 0
	SUBLW      38
L__main39:
	BTFSS      STATUS+0, 0
	GOTO       L_main15
;ULTRASONIC_SHITE.c,87 :: 		set_water_blue();
	CALL       _set_water_blue+0
	GOTO       L_main16
L_main15:
;ULTRASONIC_SHITE.c,89 :: 		set_water_red();
	CALL       _set_water_red+0
L_main16:
;ULTRASONIC_SHITE.c,91 :: 		mymsDelay(200);
	MOVLW      200
	MOVWF      FARG_mymsDelay+0
	CLRF       FARG_mymsDelay+1
	CALL       _mymsDelay+0
;ULTRASONIC_SHITE.c,93 :: 		distance2 = get_distance();
	CALL       _get_distance+0
	MOVF       R0+0, 0
	MOVWF      _distance2+0
	MOVF       R0+1, 0
	MOVWF      _distance2+1
;ULTRASONIC_SHITE.c,94 :: 		if(distance2 >=15 && distance2 <=20)
	MOVLW      0
	SUBWF      R0+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main40
	MOVLW      15
	SUBWF      R0+0, 0
L__main40:
	BTFSS      STATUS+0, 0
	GOTO       L_main19
	MOVF       _distance2+1, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__main41
	MOVF       _distance2+0, 0
	SUBLW      20
L__main41:
	BTFSS      STATUS+0, 0
	GOTO       L_main19
L__main29:
;ULTRASONIC_SHITE.c,95 :: 		PORTD = PORTD | 0b00000100;
	BSF        PORTD+0, 2
	GOTO       L_main20
L_main19:
;ULTRASONIC_SHITE.c,97 :: 		mymsDelay(200);
	MOVLW      200
	MOVWF      FARG_mymsDelay+0
	CLRF       FARG_mymsDelay+1
	CALL       _mymsDelay+0
L_main20:
;ULTRASONIC_SHITE.c,99 :: 		}
	GOTO       L_main11
;ULTRASONIC_SHITE.c,101 :: 		}
L_end_main:
	GOTO       $+0
; end of _main

_get_distance:

;ULTRASONIC_SHITE.c,105 :: 		unsigned int get_distance(void){
;ULTRASONIC_SHITE.c,106 :: 		T1CON = 0x30;                 //Initialize Timer Module
	MOVLW      48
	MOVWF      T1CON+0
;ULTRASONIC_SHITE.c,107 :: 		TMR1H = TMR1L = 0;                  //Sets the Initial Value of Timer
	CLRF       TMR1L+0
	MOVF       TMR1L+0, 0
	MOVWF      TMR1H+0
;ULTRASONIC_SHITE.c,109 :: 		PORTB = PORTB | 0b00001000;               //TRIGGER HIGH
	BSF        PORTB+0, 3
;ULTRASONIC_SHITE.c,110 :: 		usDelay(10);               //10uS Delay
	MOVLW      10
	MOVWF      FARG_usDelay_usCnt+0
	MOVLW      0
	MOVWF      FARG_usDelay_usCnt+1
	CALL       _usDelay+0
;ULTRASONIC_SHITE.c,112 :: 		PORTB = PORTB & 0b11110111;;               //TRIGGER LOW
	MOVLW      247
	ANDWF      PORTB+0, 1
;ULTRASONIC_SHITE.c,114 :: 		while(!PORTB&0b00010000);           //Waiting for Echo
L_get_distance21:
	MOVF       PORTB+0, 0
	MOVLW      1
	BTFSS      STATUS+0, 2
	MOVLW      0
	MOVWF      R1+0
	BTFSS      R1+0, 4
	GOTO       L_get_distance22
	GOTO       L_get_distance21
L_get_distance22:
;ULTRASONIC_SHITE.c,115 :: 		T1CON = T1CON | 0x01;               //Timer Starts
	BSF        T1CON+0, 0
;ULTRASONIC_SHITE.c,116 :: 		while(PORTB&0b00010000);            //Waiting for Echo goes LOW
L_get_distance23:
	BTFSS      PORTB+0, 4
	GOTO       L_get_distance24
	GOTO       L_get_distance23
L_get_distance24:
;ULTRASONIC_SHITE.c,117 :: 		T1CON = T1CON & 0b11111110;               //Timer Stops
	MOVLW      254
	ANDWF      T1CON+0, 1
;ULTRASONIC_SHITE.c,119 :: 		a = (TMR1L | (TMR1H<<8));   //Reads Timer Value
	MOVF       TMR1H+0, 0
	MOVWF      R0+1
	CLRF       R0+0
	MOVF       TMR1L+0, 0
	IORWF      R0+0, 1
	MOVLW      0
	IORWF      R0+1, 1
	MOVF       R0+0, 0
	MOVWF      _a+0
	MOVF       R0+1, 0
	MOVWF      _a+1
;ULTRASONIC_SHITE.c,122 :: 		a = a/59;                //Converts Time to Distance
	MOVLW      59
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	CALL       _Div_16X16_U+0
	MOVF       R0+0, 0
	MOVWF      _a+0
	MOVF       R0+1, 0
	MOVWF      _a+1
;ULTRASONIC_SHITE.c,123 :: 		a = a + 1;                  //Distance Calibration
	INCF       R0+0, 1
	BTFSC      STATUS+0, 2
	INCF       R0+1, 1
	MOVF       R0+0, 0
	MOVWF      _a+0
	MOVF       R0+1, 0
	MOVWF      _a+1
;ULTRASONIC_SHITE.c,124 :: 		distance = (a*370)/100;
	MOVLW      114
	MOVWF      R4+0
	MOVLW      1
	MOVWF      R4+1
	CALL       _Mul_16X16_U+0
	MOVLW      100
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	CALL       _Div_16X16_U+0
	MOVF       R0+0, 0
	MOVWF      _distance+0
	MOVF       R0+1, 0
	MOVWF      _distance+1
;ULTRASONIC_SHITE.c,125 :: 		TMR1H = TMR1L = 0;
	CLRF       TMR1L+0
	MOVF       TMR1L+0, 0
	MOVWF      TMR1H+0
;ULTRASONIC_SHITE.c,126 :: 		return distance;
;ULTRASONIC_SHITE.c,128 :: 		}
L_end_get_distance:
	RETURN
; end of _get_distance

_ATDinit_A:

;ULTRASONIC_SHITE.c,130 :: 		void ATDinit_A(void){
;ULTRASONIC_SHITE.c,131 :: 		ADCON0 = 0x41; //prescale 16, channel A0, dont start conversion, power on ATD
	MOVLW      65
	MOVWF      ADCON0+0
;ULTRASONIC_SHITE.c,132 :: 		ADCON1 = 0xF0; // right justified, all channels are analog
	MOVLW      240
	MOVWF      ADCON1+0
;ULTRASONIC_SHITE.c,134 :: 		}
L_end_ATDinit_A:
	RETURN
; end of _ATDinit_A

_ATDinit_W:

;ULTRASONIC_SHITE.c,136 :: 		void ATDinit_W(void){
;ULTRASONIC_SHITE.c,137 :: 		ADCON0 = 0x49; //prescale 16, channel A1, dont start conversion, power on ATD
	MOVLW      73
	MOVWF      ADCON0+0
;ULTRASONIC_SHITE.c,138 :: 		ADCON1 = 0xF0; // right justified, all channels are analog
	MOVLW      240
	MOVWF      ADCON1+0
;ULTRASONIC_SHITE.c,140 :: 		}
L_end_ATDinit_W:
	RETURN
; end of _ATDinit_W

_mymsDelay:

;ULTRASONIC_SHITE.c,142 :: 		void mymsDelay(unsigned int x){
;ULTRASONIC_SHITE.c,143 :: 		tick=0;
	CLRF       _tick+0
	CLRF       _tick+1
;ULTRASONIC_SHITE.c,144 :: 		while(tick<x);
L_mymsDelay25:
	MOVF       FARG_mymsDelay_x+1, 0
	SUBWF      _tick+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__mymsDelay46
	MOVF       FARG_mymsDelay_x+0, 0
	SUBWF      _tick+0, 0
L__mymsDelay46:
	BTFSC      STATUS+0, 0
	GOTO       L_mymsDelay26
	GOTO       L_mymsDelay25
L_mymsDelay26:
;ULTRASONIC_SHITE.c,145 :: 		}
L_end_mymsDelay:
	RETURN
; end of _mymsDelay

_ATDread:

;ULTRASONIC_SHITE.c,147 :: 		unsigned int ATDread(void){
;ULTRASONIC_SHITE.c,148 :: 		ADCON0 = ADCON0 | 0x04; // set the GO bit, start the conversion
	BSF        ADCON0+0, 2
;ULTRASONIC_SHITE.c,149 :: 		while(!(ADCON0 & 0x04)); // wait until the GO/DONE bit is reset, the ATD reading is ready
L_ATDread27:
	BTFSC      ADCON0+0, 2
	GOTO       L_ATDread28
	GOTO       L_ATDread27
L_ATDread28:
;ULTRASONIC_SHITE.c,151 :: 		return ((ADRESH<<8)|(ADRESL));
	MOVF       ADRESH+0, 0
	MOVWF      R0+1
	CLRF       R0+0
	MOVF       ADRESL+0, 0
	IORWF      R0+0, 1
	MOVLW      0
	IORWF      R0+1, 1
;ULTRASONIC_SHITE.c,152 :: 		}
L_end_ATDread:
	RETURN
; end of _ATDread

_set_ambient_red:

;ULTRASONIC_SHITE.c,155 :: 		void set_ambient_red(void){
;ULTRASONIC_SHITE.c,156 :: 		PORTC = PORTC | 0b00001000;
	BSF        PORTC+0, 3
;ULTRASONIC_SHITE.c,157 :: 		PORTC = PORTC & 0b11001111;
	MOVLW      207
	ANDWF      PORTC+0, 1
;ULTRASONIC_SHITE.c,158 :: 		}
L_end_set_ambient_red:
	RETURN
; end of _set_ambient_red

_set_ambient_green:

;ULTRASONIC_SHITE.c,161 :: 		void set_ambient_green(void){
;ULTRASONIC_SHITE.c,162 :: 		PORTC = PORTC | 0b00010000;
	BSF        PORTC+0, 4
;ULTRASONIC_SHITE.c,163 :: 		PORTC = PORTC & 0b11010111;
	MOVLW      215
	ANDWF      PORTC+0, 1
;ULTRASONIC_SHITE.c,164 :: 		}
L_end_set_ambient_green:
	RETURN
; end of _set_ambient_green

_set_ambient_blue:

;ULTRASONIC_SHITE.c,167 :: 		void set_ambient_blue(void){
;ULTRASONIC_SHITE.c,168 :: 		PORTC = PORTC & 0b11100111;
	MOVLW      231
	ANDWF      PORTC+0, 1
;ULTRASONIC_SHITE.c,169 :: 		PORTC = PORTC | 0b00100000;
	BSF        PORTC+0, 5
;ULTRASONIC_SHITE.c,170 :: 		}
L_end_set_ambient_blue:
	RETURN
; end of _set_ambient_blue

_set_water_red:

;ULTRASONIC_SHITE.c,172 :: 		void set_water_red(void){
;ULTRASONIC_SHITE.c,173 :: 		PORTC = PORTC & 0b11111001;
	MOVLW      249
	ANDWF      PORTC+0, 1
;ULTRASONIC_SHITE.c,174 :: 		PORTC = PORTC |  0b00000001;
	BSF        PORTC+0, 0
;ULTRASONIC_SHITE.c,175 :: 		}
L_end_set_water_red:
	RETURN
; end of _set_water_red

_set_water_green:

;ULTRASONIC_SHITE.c,177 :: 		void set_water_green(void){
;ULTRASONIC_SHITE.c,178 :: 		PORTC = PORTC & 0b11111010;
	MOVLW      250
	ANDWF      PORTC+0, 1
;ULTRASONIC_SHITE.c,179 :: 		PORTC = PORTC |  0b00000010;
	BSF        PORTC+0, 1
;ULTRASONIC_SHITE.c,180 :: 		}
L_end_set_water_green:
	RETURN
; end of _set_water_green

_set_water_blue:

;ULTRASONIC_SHITE.c,182 :: 		void set_water_blue(void){
;ULTRASONIC_SHITE.c,183 :: 		PORTC = PORTC & 0b11111100;
	MOVLW      252
	ANDWF      PORTC+0, 1
;ULTRASONIC_SHITE.c,184 :: 		PORTC = PORTC |  0b00000100;
	BSF        PORTC+0, 2
;ULTRASONIC_SHITE.c,185 :: 		}
L_end_set_water_blue:
	RETURN
; end of _set_water_blue

_set_waterlvl_green:

;ULTRASONIC_SHITE.c,187 :: 		void set_waterlvl_green(void){
;ULTRASONIC_SHITE.c,188 :: 		PORTD = PORTD & 0b11111010;
	MOVLW      250
	ANDWF      PORTD+0, 1
;ULTRASONIC_SHITE.c,189 :: 		PORTD = PORTD | 0b00000010;
	BSF        PORTD+0, 1
;ULTRASONIC_SHITE.c,190 :: 		}
L_end_set_waterlvl_green:
	RETURN
; end of _set_waterlvl_green

_set_waterlvl_red:

;ULTRASONIC_SHITE.c,192 :: 		void set_waterlvl_red(void){
;ULTRASONIC_SHITE.c,193 :: 		PORTD = PORTD & 0b11111001;
	MOVLW      249
	ANDWF      PORTD+0, 1
;ULTRASONIC_SHITE.c,194 :: 		PORTD = PORTD | 0b00000001;
	BSF        PORTD+0, 0
;ULTRASONIC_SHITE.c,195 :: 		}
L_end_set_waterlvl_red:
	RETURN
; end of _set_waterlvl_red
