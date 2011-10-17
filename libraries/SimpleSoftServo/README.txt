This is a C++ library for Arduino 0018+, by Carlyn Maw

It is a meant for Software control of Servo motor. I reccomend avoiding that
as much as possible. It is pretty good if you keep calling it but there 
is another one out there that is better - SoftwareSero, but it leaves the Servo
motors very interdependant and for some reason that bothered me. I also tried to 
name things so it was clear what was going on. 


Installation
--------------------------------------------------------------------------------

To install this library, just place this entire folder as a subfolder in your
~/Documents/Arduino/libraries folder for mac My Documents\Arduino\libraries\ for a
PC.

When installed, this library should look like:

Arduino/libraries/SimpleSoftServo             (this library's folder)
Arduino/libraries/SimpleSoftServo/SimpleSoftServo.cpp     (the library implementation file)
Arduino/libraries/SimpleSoftServo/SimpleSoftServo.h       (the library description file)
Arduino/libraries/SimpleSoftServo/keywords.txt (the syntax coloring file)
Arduino/libraries/SimpleSoftServo/examples     (the examples in the "open" menu)
Arduino/libraries/SimpleSoftServo/readme.txt   (this file)

Building
--------------------------------------------------------------------------------

After this library is installed, you just have to start the Arduino application.
You may see a few warning messages as it's built.

Add the corresponding line to the top of your sketch:
#include <SimpleSoftServo.h>

To stop using this library, delete that line from your sketch.

Public Functions
--------------------------------------------------------------------------------

SimpleSoftServo myInstance = SimpleSoftServo(int pinNumber);

other public functions, shown in the example:

update                    
write                      

setMinPulseLength          
setMaxulseLength           

getPulseLength	           
setPulseLength	           

getMinPulseLength	  
setMinPulseLength     

getMaxPulseLength
setMaxPulseLength

getFullPeriod
setFullPeriod

	
	
	
	



