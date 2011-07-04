//**************************************************************//
//  Name    : 3 Tunes for Clay Pots                             //
//  Author  : Carlyn Maw                                        //
//  Date    : 27 JUN, 2011                                      //
//  Version : 1.0                                               //
//  Notes   : Code for thwaking objects via solenoid            //
//          : This is very simple code for running a pattern    //
//          : of thwacks on the 5 tone setup.                   //
//          : Remember not to thwack too many solenoids at once //
//          : or the same one too many times.                   //
//****************************************************************

//-------------------------------------------- thwacker setup
//number of thwakers
const int numberOfThwakers = 5;

//what pins the thwakers are attached to?
//keeping those pins in an array at the top
//allows for easy updating later.
byte thwackPinArray[numberOfThwakers] = { 
  2,3,4,5,6 } 
;

// This is the brute force way to enforce the duty cycle.
// pulseLength is the length of time the solenoid is pulsed in milliseconds
// minThwack delay gets called at the end of the pulseing to ensure that the 
// for these solenoids the duty cycle is 10%
int pulseLength = 100;
int minThwackDelay = 700; //this is less than 900*

//* a 10% duty cycle would mean this number should be 900
//it is not because the same solenoid isn't necessarily going
//to be played next. It is a bit of a cheat. A solenoid can be played
//twice in a row, but the more time it is struck at this rate the
//hotter it will get.

//------------------------------------------------ tune setup
//holders for infromation you're going to pass to thwaking function
//in this version of the code all tunes are 12 beats long.
const int lengthOfSequence = 12;
byte scaleArray[lengthOfSequence];

//-----------------------------------------------button setup
const byte scalesModePin = 12;
// 1 is off, 0 is on (internal pull up will be set
byte scalesModeFlag = 1;  

const byte tune1ModePin = 11;
// 1 is off, 0 is on (internal pull up will be set
byte tune1ModeFlag = 1;  

const byte tune2ModePin = 10;
// 1 is off, 0 is on (internal pull up will be set
byte tune2ModeFlag = 1;  

//------------------------------------------------------------------ START SETUP
void setup() {
  //set pins to output because they are addressed in the main loop
  for (byte i = 0; i <= numberOfThwakers; i ++) {
    pinMode(thwackPinArray[i], OUTPUT);   
  }
  
  
  pinMode(scalesModePin, INPUT);
  digitalWrite(scalesModePin, HIGH); // set pull up 
  
  pinMode(scalesModePin, INPUT);
  digitalWrite(scalesModePin, HIGH); // set pull up 
  
  pinMode(scalesModePin, INPUT);
  digitalWrite(scalesModePin, HIGH); // set pull up

//This is where the pattern for the scales lives. 
//Last bit lines up with first pin listed in the 
//thwackPinArray
 scaleArray[0] = B00000001; 
 scaleArray[1] = B00000010; 
 scaleArray[2] = B00000100; 
 scaleArray[3] = B00001000;   
 scaleArray[4] = B00010000; 
 scaleArray[5] = B00000000; 
 scaleArray[6] = B00010000; 
 scaleArray[7] = B00001000; 
 scaleArray[8] = B00000100; 
 scaleArray[9] = B00000010;
 scaleArray[10] = B00000001;
 scaleArray[11] = B00000000;  
 
 tuneArray[0] = B00000001; 
 tuneArray[1] = B00010000; 
 tuneArray[2] = B00000100; 
 tuneArray[3] = B00001000;   
 tuneArray[4] = B00000100; 
 tuneArray[5] = B00001001; 
 tuneArray[6] = B00010000; 
 tuneArray[7] = B00001010; 
 tuneArray[8] = B00010000; 
 tuneArray[9] = B00000010;
 tuneArray[10] = B00001000;
 tuneArray[11] = B00000010;  


 tune2Array[0] = B00000100; 
 tune2Array[1] = B00000010; 
 tune2Array[2] = B00000001; 
 tune2Array[3] = B00000100;   
 tune2Array[4] = B00000010; 
 tune2Array[5] = B00000001; 
 tune2Array[6] = B00010000; 
 tune2Array[7] = B00001000; 
 tune2Array[8] = B00000100; 
 tune2Array[9] = B00001000;
 tune2Array[10] = B00010001;
 tune2Array[11] = B00000010; 

}



//------------------------------------------------------------------ START MAIN LOOP
void loop() {

//STEP ONE: Check the environment
scalesModeFlag = digitalRead(scalesModePin);  // pressed is LOW, so 0 is ON
tune1ModeFlag = digitalRead(tune1ModePin);  // pressed is LOW, so 0 is ON
tune2ModeFlag = digitalRead(tune2ModePin);  // pressed is LOW, so 0 is ON

//STEP TWO: Do something about it

//depending on which button is pressed a different tune will play
//if all three are pressed, only scalesModeFlag will matter
//if they were written as seperate if statements it could happen that
//if all three were pressed it would cycle through all three before the
//code even checked the buttons again. 

//there are many ways to to do what is essentially blinking without delays. 
//Look at the Blink Without Delay code that comes with Arduino for starters.

if (scalesModeFlag == 0) {
    playSequence(scaleArray);
} else if (tune1ModeFlag == 0) {
    playSequence(tuneArray);
} else if  (tune2ModeFlag == 0) {
    playSequence(tune2Array);
}


}

//------------------------------------------------------------------ END MAIN LOOP


//----------------------------------------------------------------- thwackOut()
//this is very similar to a shift out function
//starting with bit 7 (of 0-7) look through the 
//byte I've been handed and then set the corresponding
//pin in the thackPinArray to that value. 
//Wait the the minimum pulse time, and then turn everyone off.
//The pins at the begining of the array end up getting fractions
//of a second more than the end, but it is faster than 
//a human could percieve. 
void thwakOut(byte myDataOut) {
  int pinState;
  for (int t=7; t>=0; t--)  {
    if ( myDataOut & (1<<t) ) {
      pinState= 1;
    }
    else {	
      pinState= 0;
    }
    digitalWrite(thwackPinArray[t], pinState);
  }
  delay(pulseLength);
  for (int t=7; t>=0; t--)  {
    digitalWrite(thwackPinArray[t], 0);
  }
}

//-------------------------------------------------------------- playSequence()
//Steps through the array of length of sequence,
//sending each byte to thwackOut()
void playSequence(byte * mySequenceArray) {
  for (int j = 0; j < lengthOfSequence; j++) {
    byte currentByte = mySequenceArray[j];
    thwakOut(currentByte);   
    delay(minThwackDelay);
  }
}

