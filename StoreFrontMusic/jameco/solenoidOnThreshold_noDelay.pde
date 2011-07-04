//**************************************************************//
//  Name    : thwackOne_noDelay                                 //
//  Author  : Carlyn Maw                                        //
//  Date    : 1 JULY, 2011                                      //
//  Version : 1.0                                               //
//  Notes   : code for testing a solenoid. based on             //
//          : http://arduino.cc/en/Tutorial/IfStatement         //
//          : with the addition of the pulse() function and     //
//          : its related variables.                            //
//  Circuit :  * potentiometer connected to analog pin A2.      //
//          :    - center pin A0                                //
//          :    - side leads to pins 15 & 14 (as vcc and gnd)  //
//  Behavior: Allows for smooth analog control of solenoid      //
//          : firing periods as they are determined on the fly  //
//          : and the firing is not a delay.                    //
//**************************************************************** 


//------------------------------------------------------------ GLOBAL TIME VARS
long lastMillis= 0;
long currentMillis = 0;

//---------------------------------------------------------- ANALOG INFORMATION
const int analogPin = A2;    // pin that the sensor is attached to
const int threshold = 200;   // threshold of the shortest tolerable period length    

const int aVccPin = 15;      // making pins 15  (A1)& 14(A0) serve as VCC and GND
const int aGndPin = 14;      // for the sensor means that I can stick a giant
// capacitor accross the power lines of the
// Arduino on the main 5V and GND pins
// without doing any extra setup work. 

//--------------------------------------------------------- SOLENOID INFORMATION
const int sPin = 9;        // pin that the solenoid is attached to
int sPeriod = 1000;  // length of full period, don't get too long or too short  //changed
const int sDutyCycle = 10; // duty cycle of solenoid
byte sState = 0;           // used in later verions of the code 

long sCurrentFlip = 0;



//------------------------------------------------------------------ START SETUP

void setup() {
  // initialize the solenoid pin as an output:
  pinMode(sPin, OUTPUT);
  // initialize serial communications:
  Serial.begin(9600);

  pinMode(aVccPin, OUTPUT);
  pinMode(aGndPin, OUTPUT);
  digitalWrite(aVccPin, HIGH);
  digitalWrite(aGndPin, LOW);
}

//------------------------------------------------------------- START MAIN LOOP

void loop() {
  
  //LOOP: STEP ONE, CHECK THE TIME 
  lastMillis = currentMillis; // dumps the time from the last loop into previous holder
  currentMillis = millis();  // refreshes time constant
  
  //LOOP: STEP TWO, POLL THE ENVIRONMENT
  int analogValue = analogRead(analogPin);
  sPeriod = analogValue * 2; 
  
  //LOOP: STEP THREE, DO SOMETHING ABOUT IT
  // if the analog value is high enough, pulse the Solenoid:
  if (analogValue > threshold) {
    pulse(sPin, sPeriod, sDutyCycle);
  } 
  else {
    digitalWrite(sPin,LOW); 
  }
  // print the analog value:
  Serial.println(analogValue, DEC);

}


///------------------------------------------------------------------  pulse()

//states:  ready, firing, resting
void pulse(int myPin, int myPeriod, int myDutyCycle) {
  int myOnPeriod = (myPeriod * myDutyCycle) / 100;
  int myOffPeriod = (myPeriod - myOnPeriod);

  //if my state is ready 
  if (sState == 0) {
    //get the time
    sCurrentFlip = millis();
    //set my state to firing
    sState = 1;
    //turn on the pin
    digitalWrite(myPin, HIGH);
  } 
  //if my state is firing
  else if (sState == 1) { 
    if ((myOnPeriod) < (currentMillis - sCurrentFlip)) {
      //if it's time, turn me off
      digitalWrite(myPin, LOW);
      sCurrentFlip = millis();
      sState = 2;
    }

  } 
  //if my state is resting
  else if (sState == 2) {
    //keep me off
    digitalWrite(myPin, LOW);
    //check the time and make me ready
    if ((myOffPeriod) < (currentMillis - sCurrentFlip)) {
      sState = 0;
    }

  }

}




