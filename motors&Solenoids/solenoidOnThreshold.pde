//**************************************************************//
//  Name    : thwackOne                                         //
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
//**************************************************************** 
 

//---------------------------------------------------------- ANALOG INFORMATION
const int analogPin = A2;    // pin that the sensor is attached to
const int threshold = 400;   // an arbitrary threshold level    

const int aVccPin = 15;      // making pins 15  (A1)& 14(A0) serve as VCC and GND
const int aGndPin = 14;      // for the sensor means that I can stick a giant
                             // capacitor accross the power lines of the
                             // Arduino on the main 5V and GND pins
                             // without doing any extra setup work. 

//--------------------------------------------------------- SOLENOID INFORMATION
const int sPin = 9;        // pin that the solenoid is attached to
const int sPeriod = 1000;  // length of full period, don't get too long or too short
const int sDutyCycle = 10; // duty cycle of solenoid
byte sState = 0;           // used in later verions of the code 



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
  // read the value of the potentiometer:
  int analogValue = analogRead(analogPin);

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

//states:  ready, firing, waiting
void pulse(int myPin, int myPeriod, int myDutyCycle) {
  int myOnPeriod = (myPeriod * myDutyCycle) / 100;
  int myOffPeriod = (myPeriod - myOnPeriod);
  
  digitalWrite(myPin, HIGH);
  sState = 1; 
  delay(myOnPeriod);

  digitalWrite(myPin, LOW);
  sState = 2;
  delay(myOffPeriod);
  
  sState = 0;
}

