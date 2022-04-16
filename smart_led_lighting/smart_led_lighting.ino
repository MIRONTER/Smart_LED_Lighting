#include "FastLED.h"
#include <SoftwareSerial.h>

#define LED_STRIP_LENGTH 148
#define STRIP_CONTROL_PIN 13
#define IS_BLUETOOTH_ENABLED 0

SoftwareSerial bluetooth(8,7);

byte maxBrightness = 128;
byte ledEffect = 9;
boolean autoSwitch = 1;
boolean enableStaticEffects = 0;
long changePeriod = 300000;
CRGB ledStrip[LED_STRIP_LENGTH];
unsigned long lastChange;

byte currentEffectDelay, currentStripHue, currentStripSaturation;
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
  FastLED.setBrightness(maxBrightness);
  FastLED.addLeds<WS2811, STRIP_CONTROL_PIN, GRB>(ledStrip, LED_STRIP_LENGTH);
  FastLED.show();
  randomSeed(analogRead(0));
  changeEffect(ledEffect);
  Serial.begin(9600);
  if (IS_BLUETOOTH_ENABLED) bluetooth.begin(9600);
}

void loop() {
  if (millis() - lastChange > changePeriod && autoSwitch) {
    if (enableStaticEffects) ledEffect = random(0, 16);
      else ledEffect = random(0, 25);
    changeEffect(ledEffect);
    lastChange = millis();
  }
  if (Serial.available() > 0) {
    String command = Serial.readString();
    Serial.flush();
    parseCommand(command);
  }
  if (IS_BLUETOOTH_ENABLED && bluetooth.available() > 0) {
    String command = bluetooth.readString();
    bluetooth.flush();
    parseCommand(command);
  }
  performEffect();
}
