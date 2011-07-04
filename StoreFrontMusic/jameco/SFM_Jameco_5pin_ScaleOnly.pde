//**************************************************************//
//  Name    : 5 Tone Scales for Clay Pots                       //
//  Author  : Carlyn Maw                                        //
//  Date    : 26 JUN, 2011                                      //
//  Version : 1.0                                               //
//  Notes   : Code for thwaking objects via solenoid            //
//          : This is very simple code for running a pattern    //
//          : scales to a 5 tone setup.                         //
//          : remember not to thwack too many solenoids at once //
//          : to not thwack the same one too many times, etc... //
//****************************************************************


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


//holders for infromation you're going to pass to thwaking function
const int lengthOfSequence = 12;
byte scaleArray[lengthOfSequence];

//------------------------------------------------------------------ START SETUP
void setup() {
  //set pins to output because they are addressed in the main loop
  for (byte i = 0; i <= numberOfThwakers; i ++) {
    pinMode(thwackPinArray[i], OUTPUT);
  }

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

}



//------------------------------------------------------------------ START MAIN LOOP
void loop() {

     delay(2000);       
     playSequence(scaleArray);
     delay(2000);
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

