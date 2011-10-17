 /*
 * Software Servo Library Example 1 -  Change based on serial instruction
 * ------------
 *
 * Circuit: 
 *          - Servo 1 on pin 2
 *          - Servo 2 on pin 4
 *
 * Behavior: 
 *         When serial messages are sent to the Arduino
 *         you can pick which servo to move. Values 9 through 0
 *         move the servo in 20 degree segments.
 *         
 *         I'm calling the update function repeatedly. The more 
 *         it's called the more stable it is. 
 *
 *         There are WAY better libraries for servos, btw. Use the
 *         one that comes with Arduino, it is hardware based. 
 *
 * Created 17 October 2011
 * by Carlyn Maw
 *
 */

#include <SimpleSoftServo.h> 

const int servoPin1 = 2;
const int servoPin2 = 4;

SimpleSoftServo myServo1 = SimpleSoftServo(servoPin1);
SimpleSoftServo myServo2 = SimpleSoftServo(servoPin2);

int value = 0;
char currentServo = 'A';

unsigned long time;


void setup()
{
  Serial.begin(19200);

  //EXAMPLES OF AVAILAVLBLE FUNCTIONS (all 'set' functions have their get, too)
  //has default at 20000 microseconds (20 ms)
  myServo1.setFullPeriod(20000);
  //has default at 1000 microseconds
  myServo1.setMinPulseLength(700); 
  //has default at 2000 microseconds
  myServo1.setMaxPulseLength(2400); 
  //has starting default at 1500 microseconds
  myServo1.setPulseLength(1000); 

  pinMode(13, OUTPUT);
  
  Serial.println("Ready");


}


void loop()
{
  //as you'll see, can either update with a time 
  //or let the call to update determine the time on it's own
  time = micros();
  myServo1.update(time); 
  myServo2.update(time); 

  if ( Serial.available()) {
    char ch = Serial.read();
    myServo1.update(); 
    myServo2.update(); 
    switch(ch) {
    case 'A':
      currentServo='A';
      digitalWrite(13,LOW);
      Serial.println("Ready A");
      break;
    case 'B':
      currentServo='B';
      Serial.println("Ready B");
      digitalWrite(13,HIGH);
      break;
    case '0' ... '9':
      value=(ch-'0')*20;

      if (currentServo=='A')
      {
        myServo1.write(value);
        myServo1.update(); 
        myServo2.update();
        Serial.println("Servo A moving");
      }
      else if (currentServo=='B')
      {
        myServo2.write(value);
        myServo1.update(); 
        myServo2.update();
        Serial.println("Servo B moving");
      }
      break;
    default:
      Serial.println("Nada");
      break;   
    }
    myServo1.update(); 
    myServo2.update(); 
  }
}




