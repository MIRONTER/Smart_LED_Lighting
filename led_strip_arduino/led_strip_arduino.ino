#include "FastLED.h"
#include <SoftwareSerial.h>

#define LED_STRIP_LENGTH 148
#define STRIP_CONTROL_PIN 13
#define BLUETOOTH_RX_PIN 8
#define BLUETOOTH_TX_PIN 7
#define BUTTON_PIN 2
#define IS_BLUETOOTH_ENABLED 0
#define IS_BUTTON_ENABLED 0

SoftwareSerial bluetooth(BLUETOOTH_RX_PIN, BLUETOOTH_TX_PIN);
volatile unsigned long buttonAntiBounceTimer;

byte maxBrightness = 128;
byte currentLightMode = 1;
boolean autoSwitch = 1;
boolean enableAutoStaticEffects = 0;
long changePeriodMilliseconds = 300000;
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
  changeLightMode(currentLightMode);
  Serial.begin(9600);
  if (IS_BLUETOOTH_ENABLED) bluetooth.begin(9600);
  if (IS_BUTTON_ENABLED) {
    pinMode(BUTTON_PIN, INPUT_PULLUP);
    attachInterrupt(0, buttonClick, FALLING);
  }
}

void loop() {
  if (millis() - lastChange > changePeriodMilliseconds && autoSwitch) {
    if (enableAutoStaticEffects) {
      currentLightMode = random(0, 21);
    } else {
      currentLightMode = random(0, 12);
    }
    changeLightMode(currentLightMode);
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
