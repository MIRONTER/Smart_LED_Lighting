#include "FastLED.h"

#define LED_STRIP_LENGTH 264
#define STRIP_CONTROL_PIN 13
#define CHANGE_PERIOD 5 * 60 * 1000

CRGB ledStrip[LED_STRIP_LENGTH];

byte currentBaseColor[3] = {255, 255, 255};
byte currentMode;
boolean currentAutoSwitch;
byte currentEffectDelay;

byte ledHue, ledBrightness;
bool bounceDirection;

unsigned long lastChange;

void setup() {
  fillStrip(0, 0, 0);
  FastLED.setBrightness(255);
  FastLED.addLeds<WS2811, STRIP_CONTROL_PIN, GRB>(ledStrip, LED_STRIP_LENGTH);
  FastLED.show();
  randomSeed(analogRead(0));
  getMode();
  getAutoSwitch();
  getBaseColor();
  changeMode(currentMode);
  Serial.begin(2400);
}

void loop() {
  performAutoSwitch();
  parseSerial();
  performEffect();
}
