#line 1 "C:/Users/Zaid/Desktop/Embedded/Sonar Sensor/Sonar Sensor/ULTRASONIC_SHITE.c"
unsigned int distance;
unsigned int distance2;
unsigned int a;
void mymsDelay(unsigned int);
unsigned int tick = 0;
unsigned int AMBIENT_TEMP;
unsigned int WATER_TEMP;
unsigned int get_distance();

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
 asm NOP;
 asm NOP;
 }

}

void msDelay(unsigned int msCnt){
 unsigned int ms=0;
 unsigned int cc=0;
 for(ms=0;ms<(msCnt);ms++){
 for(cc=0;cc<155;cc++);
 }

}
void ATDinit_A(void);
void ATDinit_W(void);
unsigned int ATDread(void);
void interrupt(void){
if(INTCON & 0x02){



 INTCON = INTCON & 0xFD;
 }

 if(INTCON & 0x04)
 {
 TMR0=248;
 tick++;

 INTCON = INTCON & 0xFB;

 }

}

void main(){
 TRISB = 0b00010000;
 TRISC = 0x00;
 TRISD = 0x00;
 TRISA = 0b11111;
 OPTION_REG= 0x87;

 INTCON=0xB0;

 while(1)
 {
 mymsDelay(200);


 ATDinit_A();
 AMBIENT_TEMP = ATDread();
 if(AMBIENT_TEMP <= 550)
 set_ambient_blue();

 else
 set_ambient_red();
 mymsDelay(200);


 ATDinit_W();
 WATER_TEMP = ATDread();
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
 T1CON = 0x30;
 TMR1H = TMR1L = 0;

 PORTB = PORTB | 0b00001000;
 usDelay(10);

 PORTB = PORTB & 0b11110111;;

 while(!PORTB&0b00010000);
 T1CON = T1CON | 0x01;
 while(PORTB&0b00010000);
 T1CON = T1CON & 0b11111110;

 a = (TMR1L | (TMR1H<<8));


 a = a/59;
 a = a + 1;
 distance = (a*370)/100;
 TMR1H = TMR1L = 0;
 return distance;

 }

 void ATDinit_A(void){
 ADCON0 = 0x41;
 ADCON1 = 0xF0;

}

void ATDinit_W(void){
 ADCON0 = 0x49;
 ADCON1 = 0xF0;

}

void mymsDelay(unsigned int x){
 tick=0;
 while(tick<x);
}

unsigned int ATDread(void){
 ADCON0 = ADCON0 | 0x04;
 while(!(ADCON0 & 0x04));

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
 PORTC = PORTC | 0b00000001;
 }

 void set_water_green(void){
 PORTC = PORTC & 0b11111010;
 PORTC = PORTC | 0b00000010;
 }

 void set_water_blue(void){
 PORTC = PORTC & 0b11111100;
 PORTC = PORTC | 0b00000100;
 }

void set_waterlvl_green(void){
PORTD = PORTD & 0b11111010;
PORTD = PORTD | 0b00000010;
}

void set_waterlvl_red(void){
PORTD = PORTD & 0b11111001;
PORTD = PORTD | 0b00000001;
}
