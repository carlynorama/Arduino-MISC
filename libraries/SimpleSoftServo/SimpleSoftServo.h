/*
	SimpleSoftServo.h - - SimpleSoftServo library for Wiring/Arduino - Version 0.1
	
	Original library 		(0.1) by Carlyn Maw.
	
 */

// ensure this library description is only included once
#ifndef SimpleSoftServo_h
#define SimpleSoftServo_h

// include types & constants of Wiring core API
#include "WProgram.h"

// library interface description
class SimpleSoftServo {
 
  // user-accessible "public" interface
  public:
  // constructors:
    SimpleSoftServo(int myPin);
    //SimpleSoftServo(int myBit, unsigned char *myRegister);
    
    //char* version(void);			// get the library version
    //unsigned char getRegisterValue(void);

    void setCurrentTime(unsigned long);
    void update(unsigned long);
    void update(void);
    
    int getState(void);
	
	int getPulseLength(void);
	void setPulseLength(int);
	
    int getMinPulseLength(void);
	void setMinPulseLength(int);
	
	int getMaxPulseLength(void);
	void setMaxPulseLength(int);
	
	long getFullPeriod(void);
	void setFullPeriod(long);
	
	void write(int);

    


  // library-accessible "private" interface
  private:
    int _myPin;
    int _myBit;
    unsigned char *_myRegister;
    unsigned char _registerValue;
    bool _type;  //direct pin or shift register
    bool _mode;  //HIGH == pressed (1) or LOW == pressed (0)
    int _degreePulse [181];
    
    int _lastState;
    int _currentState;
    bool _pinState;
    
    int _onPeriod;
    int _offPeriod;
    int _pulseLength;
    long _fullPeriod;
    
    int _minPulseLength;
    int _maxPulseLength;
    
    //int _servoHardwareSpeed;

        		
    bool _pulseFlag;    		

    unsigned long int _flipTime;	
	unsigned long int _currentTime;
	
    
    void calculateDegreePulses(void);
	
	//void updatePin(bool);
  
};

#endif

