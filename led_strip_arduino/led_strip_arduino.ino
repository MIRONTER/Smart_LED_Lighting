#include "FastLED.h"

#define LED_STRIP_LENGTH 264
#define STRIP_CONTROL_PIN 3

byte currentLightMode = 1;
boolean autoSwitch = 1;
long changePeriodMilliseconds = 300000;
CRGB ledStrip[LED_STRIP_LENGTH];
unsigned long lastChange;

byte currentEffectDelay, currentStripSaturation;
byte currentRed, currentGreen, currentBlue;
int ledIndex;
byte ledHue, ledBrightness;
bool bounceDirection;

int middleLedIndex = int(LED_STRIP_LENGTH / 2);
boolean isStripLengthOdd = LED_STRIP_LENGTH % 2;
boolean changeFlag;
byte ledStripBuffer[LED_STRIP_LENGTH][3];

void setup() {
  fillStrip(0, 0, 0);
  FastLED.setBrightness(255);
  FastLED.addLeds<WS2811, STRIP_CONTROL_PIN, GRB>(ledStrip, LED_STRIP_LENGTH);
  FastLED.show();
  randomSeed(analogRead(0));
  changeLightMode(currentLightMode);
  Serial.begin(9600);
}

void loop() {
  if (millis() - lastChange > changePeriodMilliseconds && autoSwitch) {
    currentLightMode = random(1, 4);
    changeLightMode(currentLightMode);
    lastChange = millis();
  }
  
  if (Serial.available() > 0) {
    String command = Serial.readString();
    Serial.flush();
    parseCommand(command);
  }
  
  performEffect();
}
