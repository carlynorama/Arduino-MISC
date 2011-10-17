/*
  SimpleSoftServo.h - SimpleSoftServo for Wiring/Arduino
  (cc) 2011 Carlyn Maw, Attribute, Share Alike
  
  Created 06 July 2011
  Version 0.1
*/


// include core Wiring API
#include "WProgram.h"

// include this library's description file
#include "SimpleSoftServo.h"

   
  
// Constructor /////////////////////////////////////////////////////////////////
// Function that handles the creation and setup of instances

//------------------------------------------------------ Using Arduino Pin Num
SimpleSoftServo::SimpleSoftServo(int myPin)
{
    // initialize this instance's variables
    this->_myPin = myPin;
    
    pinMode(this->_myPin, OUTPUT);
    
    this->_type = 0;
    this->_myBit = this->_myPin;
    
    _lastState = 0;
    _currentState = 0;
    _pinState= 0;

    _minPulseLength = 1000;    
    _maxPulseLength = 2000;
    _pulseLength = (_minPulseLength + _maxPulseLength) /2 ;
    _fullPeriod = 20000;
    
    calculateDegreePulses();
    
    _onPeriod = _pulseLength;
    _offPeriod = (_fullPeriod - _pulseLength);
      
}

// Public Methods //////////////////////////////////////////////////////////////
// Functions available in Wiring sketches, this library, and other libraries

//---------////////////////////MAIN LOOP / LISTENER ///////////--------------//

void SimpleSoftServo::update(void) {
           update(micros());
}



void SimpleSoftServo::update(unsigned long newCurrentTime) {

      _currentTime = newCurrentTime;
      _lastState = _currentState;
        
           
      //if my state is ready 
      if (_currentState == 0) {
        //get the time
        _flipTime = _currentTime;
        //set my state to firing
        _currentState = 1;
        //turn on the pin
        digitalWrite(_myPin, HIGH);
        //updatePin(HIGH);
      } 
      //if my state is firing
      else if (_currentState == 1) { 
        if ((_onPeriod) < (_currentTime - _flipTime)) {
          //if it's time, turn me off
          _flipTime = _currentTime;
          _currentState = 2;
          digitalWrite(_myPin, LOW);
          //updatePin(LOW);
        }    
      } 
      //if my state is resting
      else if (_currentState == 2) {
        //keep me off
        //check the time and make me ready
        if ((_offPeriod) < (_currentTime - _flipTime)) {
          _currentState = 0;
          _flipTime = _currentTime;
        }
    
      }
}

//for weird case of wanting to know where in the pulse firing cycle we are. 
int SimpleSoftServo::getState(void){
    return _currentState;
}

//returns actual pulse length currently using
int SimpleSoftServo::getPulseLength(void){
    return _pulseLength;
}

//change actual pulse length currently using
void SimpleSoftServo::setPulseLength(int newPL) {

    if (newPL > _maxPulseLength) { newPL = _maxPulseLength; }
    if (newPL < _minPulseLength) { newPL = _minPulseLength; }
    
    _pulseLength = newPL;
    
    _onPeriod = _pulseLength;
    _offPeriod = (_fullPeriod - _pulseLength);
}

//confirm the amount of time between pulse fires
long SimpleSoftServo::getFullPeriod(void){
    return _fullPeriod;
}

//shouldn't ever need this. Use the default 20 ms (20000 micros)
void SimpleSoftServo::setFullPeriod(long newFP){
    _fullPeriod = newFP;
    
    _onPeriod = _pulseLength;
    _offPeriod = (_fullPeriod - _pulseLength);
}

//returns what the library thinks is the shortest valid pulse length is.
int SimpleSoftServo::getMinPulseLength(void){
    return _minPulseLength;
}

//can set what the minimum valid pulse length is. 
//Defualt is 1000, some motors go lower. 
//If this is changed, then the values in the degree to pulse
//array need to be updated. 
void SimpleSoftServo::setMinPulseLength(int newMP){
    _minPulseLength = newMP;
    calculateDegreePulses();
}

//returns what the library thinks is the longest valid pulse length is.
int SimpleSoftServo::getMaxPulseLength(void){
    return _maxPulseLength;
}

//can set what the minimum valid pulse length is. 
//Defualt is 2000, some motors go higher. 
//If this is changed, then the values in the degree to pulse
//array need to be updated. 
void SimpleSoftServo::setMaxPulseLength(int newMP){
    _maxPulseLength = newMP;
    calculateDegreePulses();
}

//does what write does in all of them - changes what location
//the motor thinks it should be at in degrees.  
void SimpleSoftServo::write(int newLoc) {
     setPulseLength(_degreePulse[newLoc]);
}

// Private Methods //////////////////////////////////////////////////////////////
// Functions available to the library only.



void SimpleSoftServo::calculateDegreePulses() {
    int diffLength = _maxPulseLength - _minPulseLength;
    int stepSize = diffLength/180;
    
    for (int s = 0; s < 181; s++) {
        _degreePulse[s] = _minPulseLength + (s * stepSize);
    }
}

/*
void SimpleSoftServo::updatePin(bool pinValue) {
    
    if(!_type) {
        digitalWrite(_myPin, pinValue);
    } else {
        _registerValue = *_myRegister;
        if (pinValue) {
            _registerValue |= (1 << _myBit);
        } else {
            _registerValue &=~ (1 << _myBit);
        }
      *_myRegister = _registerValue;  
    }
   

} */
