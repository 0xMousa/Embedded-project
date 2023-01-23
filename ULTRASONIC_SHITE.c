unsigned int distance;
unsigned int distance2;
unsigned int a;
void mymsDelay(unsigned int);
unsigned int tick = 0;
unsigned int AMBIENT_TEMP;
unsigned int WATER_TEMP;
unsigned int get_distance();
 //LED Control Functions
   void set_ambient_red(void);
   void set_ambient_green(void);
   void set_ambient_blue(void);
   void set_water_red(void);
   void set_water_green(void);
   void set_water_blue(void);
   void set_waterlvl_green(void);
   void set_waterlvl_red(void);


void usDelay(unsigned int usCnt){
    unsigned int us=0;

    for(us=0;us<usCnt;us++){
      asm NOP;//0.5 uS
      asm NOP;//0.5uS
    }

}

void msDelay(unsigned int msCnt){
    unsigned int ms=0;
    unsigned int cc=0;
    for(ms=0;ms<(msCnt);ms++){
    for(cc=0;cc<155;cc++);//1ms
    }

}
void ATDinit_A(void);
void ATDinit_W(void);
unsigned int ATDread(void);
void interrupt(void){
if(INTCON & 0x02){// will get here every falling on the external interrupt pin

            // toggle water level target

             INTCON =  INTCON & 0xFD;// Clear External IF (Bit 1 in INTCON)
                           }

 if(INTCON & 0x04)
 {// will get here every 1ms
    TMR0=248;
    tick++;// will increment every 1 ms

    INTCON = INTCON & 0xFB; //Clear TMR0 IF

    }

}

void main(){
 TRISB = 0b00010000;  //RB4 as Input PIN (ECHO)
  TRISC = 0x00;
  TRISD = 0x00;
  TRISA = 0b11111; //A is an input port
  OPTION_REG= 0x87; //This will cause TMR0 clock to scale to a point where every count takes 128 uSeconds
    // Configure the pump and level sensor pins as input/output
  INTCON=0xB0; // enabling global interrupts, TMR0 interrupts and external interrupts

   while(1)
  { 
      mymsDelay(200);
    //check ambient temp and give feedback through RGB LED
    
    ATDinit_A();    //prepare ATD converter
    AMBIENT_TEMP = ATDread();   //Read ATD converter
     if(AMBIENT_TEMP <= 550)
     set_ambient_blue();

     else
    set_ambient_red();
     mymsDelay(200);
    
    //check WATER_TEMP and give feedback through RGB LED
        ATDinit_W();   //prepare ATD converter
        WATER_TEMP = ATDread();    //Read ATD converter
    if(WATER_TEMP <= 550)
    set_water_blue();
          else
    set_water_red();
 
     mymsDelay(200);

   distance2 = get_distance();
  if(distance2 >=15 && distance2 <=20)
    PORTD = PORTD | 0b00000100;
    else
      mymsDelay(200);

    }

     }
    
    

    unsigned int get_distance(void){
      T1CON = 0x30;                 //Initialize Timer Module
      TMR1H = TMR1L = 0;                  //Sets the Initial Value of Timer

    PORTB = PORTB | 0b00001000;               //TRIGGER HIGH
    usDelay(10);               //10uS Delay

    PORTB = PORTB & 0b11110111;;               //TRIGGER LOW

    while(!PORTB&0b00010000);           //Waiting for Echo
    T1CON = T1CON | 0x01;               //Timer Starts
    while(PORTB&0b00010000);            //Waiting for Echo goes LOW
    T1CON = T1CON & 0b11111110;               //Timer Stops

    a = (TMR1L | (TMR1H<<8));   //Reads Timer Value


     a = a/59;                //Converts Time to Distance
    a = a + 1;                  //Distance Calibration
    distance = (a*370)/100;
    TMR1H = TMR1L = 0;
     return distance;
    
    }
    
 void ATDinit_A(void){
     ADCON0 = 0x41; //prescale 16, channel A0, dont start conversion, power on ATD
     ADCON1 = 0xF0; // right justified, all channels are analog

}

void ATDinit_W(void){
 ADCON0 = 0x49; //prescale 16, channel A1, dont start conversion, power on ATD
 ADCON1 = 0xF0; // right justified, all channels are analog

}

void mymsDelay(unsigned int x){
    tick=0;
    while(tick<x);
}

unsigned int ATDread(void){
    ADCON0 = ADCON0 | 0x04; // set the GO bit, start the conversion
     while(!(ADCON0 & 0x04)); // wait until the GO/DONE bit is reset, the ATD reading is ready

return ((ADRESH<<8)|(ADRESL));
 }
 

 void set_ambient_red(void){
          PORTC = PORTC | 0b00001000;
          PORTC = PORTC & 0b11001111;
 }


 void set_ambient_green(void){
 PORTC = PORTC | 0b00010000;
 PORTC = PORTC & 0b11010111;
 }


 void set_ambient_blue(void){
 PORTC = PORTC & 0b11100111;
 PORTC = PORTC | 0b00100000;
 }

 void set_water_red(void){
  PORTC = PORTC & 0b11111001;
 PORTC = PORTC |  0b00000001;
 }

 void set_water_green(void){
  PORTC = PORTC & 0b11111010;
 PORTC = PORTC |  0b00000010;
 }

 void set_water_blue(void){
  PORTC = PORTC & 0b11111100;
 PORTC = PORTC |  0b00000100;
 }

void set_waterlvl_green(void){
PORTD = PORTD & 0b11111010;
PORTD = PORTD | 0b00000010;
}

void set_waterlvl_red(void){
PORTD = PORTD & 0b11111001;
PORTD = PORTD | 0b00000001;
}