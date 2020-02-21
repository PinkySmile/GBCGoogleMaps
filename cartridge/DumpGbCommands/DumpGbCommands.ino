/*
  ASCII table

  Prints out byte values in all possible formats:
  - as raw binary values
  - as ASCII-encoded decimal, hex, octal, and binary values

  For more on ASCII, see http://www.asciitable.com and http://en.wikipedia.org/wiki/ASCII

  The circuit: No external hardware needed.

  created 2006
  by Nicholas Zambetti <http://www.zambetti.com>
  modified 9 Apr 2012
  by Tom Igoe

  This example code is in the public domain.

  http://www.arduino.cc/en/Tutorial/ASCIITable
*/

unsigned char epins[] = {
  34, /* 0 */
  69, /* Missing */
  56, /* 2 */
  60, /* 3 */
  57, /* 4 */
  58, /* 5 */
  59, /* 6 */
  41, /* 7 */
  42, /* 8 */
  6,  /* 9 */
  40, /* 10 */
  5,  /* 11 */
  39, /* 12 */
  3,  /* 13 */
  38, /* 14 */
  37  /* 15 */
};

unsigned char dpins[] = {
  67,
  66,
  48,
  55,
  54,
  53,
  52,
  51
};

#include "rom.data"

#define GETADDR (GPIOE->IDR >> 2U)

unsigned short raw = 0x00;
unsigned short oaddr = 0x00;
unsigned short addr = 0x00;

bool rd = 0;
bool cs = 0;

void updateDataBus(HardwareTimer *)
{
  rom[0xFE] =  analogRead(A0);
  rom[0xFF] =  analogRead(A1);
}

void setup() {
  Serial.begin(2000000);
  while (!Serial);
 /*
  HardwareTimer *MyTim = new HardwareTimer(TIM3);
  MyTim->setMode(0, TIMER_OUTPUT_COMPARE);
  MyTim->setOverflow(60, HERTZ_FORMAT);
  MyTim->attachInterrupt(0, updateDataBus);
  MyTim->resume();
*/
  pinMode(A0, INPUT);
  pinMode(A1, INPUT);
  pinMode(D13, INPUT_PULLUP);
  for (int i = 0; i < 16; i++)
    pinMode(epins[i], INPUT);
  for (int i = 0; i < 8; i++)
    pinMode(dpins[i], OUTPUT);
  GPIOD->ODR = 0x00;
  while (/*true){*/GETADDR != 0x7EE) {
    GPIOD->ODR = rom[GETADDR];
  }
}

void loop() {
  unsigned add = GETADDR;

  switch (add) {
  //default:
  //  GPIOD->ODR = rom[add];
  //  break;
  case 0x7FF:
    int x = analogRead(A1);
    int y = analogRead(A0);
    char result = (x < 0x140) | ((x > 0x190) << 1) | ((y < 0x160) << 3) | ((y > 0x190) << 2) | (!digitalRead(D13) << 4);

    Serial.print(x, HEX);
    Serial.print(" ");
    Serial.print(y, HEX);
    Serial.print(" ");
    Serial.println(result, BIN);
    GPIOD->ODR = result;
  }
}
