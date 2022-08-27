void buttonClick() {
  if (millis() - buttonAntiBounceTimer > 150) {
    buttonAntiBounceTimer = millis();
    ledEffect++;
    if (ledEffect > 24) ledEffect = 1;
    changeEffect(ledEffect);
    changeFlag = 1;
  }
}

void setPixel(int i, byte red, byte green, byte blue) {
  ledStrip[i].r = red;
  ledStrip[i].g = green;
  ledStrip[i].b = blue;
}

int getPixelRGBSum(byte pixel[3]) {
  int sum = pixel[0] + pixel[1] + pixel[2];
  return sum;
}

void setAll(byte red, byte green, byte blue) {
  for (int i = 0; i < LED_STRIP_LENGTH; i++) {
    setPixel(i, red, green, blue);
  }
  FastLED.show();
}

void setRandomColor() {
  currentRed = random(0, 256);
  currentGreen = random(0, 256);
  currentBlue = random(0, 256);
  currentStripHue = random(0, 256);
}

void copyLedStrip() {
  for (int i = 0; i < LED_STRIP_LENGTH; i++) {
    ledStripBuffer[i][0] = ledStrip[i].r;
    ledStripBuffer[i][1] = ledStrip[i].g;
    ledStripBuffer[i][2] = ledStrip[i].b;
  }
}

boolean safeDelay(int delTime) {
  uint32_t thisTime = millis();
  while (millis() - thisTime <= delTime) {
    if (changeFlag) {
      changeFlag = 0;
      return 1;
    }
  }
  return 0;
}

int getAntipodalLedIndex(int index) {
  int antipod = index + middleLedIndex;
  if (index >= middleLedIndex) {
    antipod = ( index + middleLedIndex ) % LED_STRIP_LENGTH;
  }
  return antipod;
}

int getNearClockWiseLedIndex(int index) {
  int nearIndex;
  if (index < LED_STRIP_LENGTH - 1) {
    nearIndex = index + 1;
  } else {
    nearIndex = 0;
  }
  return nearIndex;
}

int getNearCounterClockWiseLedIndex(int index) {
  int nearIndex;
  if (index > 0) {
    nearIndex = index - 1;
  } else {
    nearIndex = LED_STRIP_LENGTH - 1;
  }
  return nearIndex;
}

void startGlow() {
  for (int i = 0; i < LED_STRIP_LENGTH; i++) {
    if (random(0,2)) {
      ledStrip[i] = CHSV(currentStripHue, 255, 255);
    } else {
      ledStrip[i] = CHSV(currentStripHue, 255, 0);
    }
  }
  FastLED.show();
}

double getWaveBrightness(int index, int subIndex) {
  return (sin((subIndex + index)/3) * 127 + 128) / 255;
}
