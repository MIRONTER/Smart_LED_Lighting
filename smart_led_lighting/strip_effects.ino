void rainbowFade() {
  ledHue++;
  if (ledHue > 255) {
    ledHue = 0;
  }
  for (int i = 0; i < LED_STRIP_LENGTH; i++) {
    ledStrip[i] = CHSV(ledHue, 255, 255);
  }
  FastLED.show();
  if (safeDelay(currentEffectDelay)) return;
}

void randomLedChangeColor() {
  ledIndex = random(0, LED_STRIP_LENGTH);
  ledHue = random(0, 255);
  ledStrip[ledIndex] = CHSV(ledHue, 255, 255);
  FastLED.show();
  if (safeDelay(currentEffectDelay)) return;
}

void twoColorsSpinning() {
  ledIndex++;
  if (ledIndex >= LED_STRIP_LENGTH) {
    ledIndex = 0;
  }
  int antipodIndex = getAntipodalLedIndex(ledIndex);
  int antipodHue = (currentStripHue + 160) % 255;
  ledStrip[ledIndex] = CHSV(currentStripHue, 255, 255);
  ledStrip[antipodIndex] = CHSV(antipodHue, 255, 255);
  FastLED.show();
  if (safeDelay(currentEffectDelay)) return;
}

void threeColorsSpinning() {
  ledIndex++;
  int ghue = (currentStripHue + 80) % 255;
  int bhue = (currentStripHue + 160) % 255;
  int N3  = int(LED_STRIP_LENGTH / 3);
  int N6  = int(LED_STRIP_LENGTH / 6);
  int N12 = int(LED_STRIP_LENGTH / 12);
  for (int i = 0; i < N3; i++) {
    int j0 = (ledIndex + i + LED_STRIP_LENGTH - N12) % LED_STRIP_LENGTH;
    int j1 = (j0 + N3) % LED_STRIP_LENGTH;
    int j2 = (j1 + N3) % LED_STRIP_LENGTH;
    ledStrip[j0] = CHSV(currentStripHue, 255, 255);
    ledStrip[j1] = CHSV(ghue, 255, 255);
    ledStrip[j2] = CHSV(bhue, 255, 255);
  }
  FastLED.show();
  if (safeDelay(currentEffectDelay)) return;
}

void brightnessPulse() {
  if (bounceDirection == 0) {
    ledBrightness++;
    if (ledBrightness >= 255) {
      bounceDirection = 1;
    }
  }
  if (bounceDirection == 1) {
    ledBrightness = ledBrightness - 1;
    if (ledBrightness <= 1) {
      bounceDirection = 0;
    }
  }
  for (int i = 0; i < LED_STRIP_LENGTH; i++) {
    ledStrip[i] = CHSV(currentStripHue, 255, ledBrightness);
  }
  FastLED.show();
  if (safeDelay(currentEffectDelay)) return;
}

void saturationPulse() {
  if (bounceDirection == 0) {
    currentStripSaturation++;
    if (currentStripSaturation >= 255) {
      bounceDirection = 1;
    }
  }
  if (bounceDirection == 1) {
    currentStripSaturation = currentStripSaturation - 1;
    if (currentStripSaturation <= 1) {
      bounceDirection = 0;
    }
  }
  for (int i = 0; i < LED_STRIP_LENGTH; i++) {
    ledStrip[i] = CHSV(currentStripHue, currentStripSaturation, 255);
  }
  FastLED.show();
  if (safeDelay(currentEffectDelay)) return;
}

void randomStream() {
  copyLedStrip();
  int nearIndex;
  ledStrip[0] = CHSV(random(0, 255), 255, 255);
  for (int index = 1; index < LED_STRIP_LENGTH; index++) {
    nearIndex = getNearCounterClockWiseLedIndex(index);
    ledStrip[index].r = ledStripBuffer[nearIndex][0];
    ledStrip[index].g = ledStripBuffer[nearIndex][1];
    ledStrip[index].b = ledStripBuffer[nearIndex][2];
  }
  FastLED.show();
  if (safeDelay(currentEffectDelay)) return;
}

void colorWipe() {
  for (int i = 0; i < LED_STRIP_LENGTH; i++) {
    setPixel(i, currentRed, currentGreen, currentBlue);
    FastLED.show();
    if (safeDelay(currentEffectDelay)) return;
  }
  for (int i = 0; i < LED_STRIP_LENGTH; i++) {
    setPixel(i, 0, 0, 0);
    FastLED.show();
    if (safeDelay(currentEffectDelay)) return;
  }
  setRandomColor();
}

void rainbowWave() {
  ledHue -= 1;
  fill_rainbow(ledStrip, LED_STRIP_LENGTH, ledHue);
  FastLED.show();
  delay(currentEffectDelay);
}

void brightnessWave() {
  for (int index = 0; index < LED_STRIP_LENGTH * 2; index++) {
    for (int subIndex = 0; subIndex < LED_STRIP_LENGTH; subIndex++) {
      setPixel(
        subIndex,
        getWaveBrightness(index, subIndex)*currentRed,
        getWaveBrightness(index, subIndex)*currentGreen,
        getWaveBrightness(index, subIndex)*currentBlue
      );
    }
    FastLED.show();
    if (safeDelay(currentEffectDelay)) return;
  }
}

void strobe() {
  for (int j = 0; j < 10; j++) {
    setAll(currentRed, currentGreen, currentBlue);
    FastLED.show();
    delay(20);
    setAll(0, 0, 0);
    FastLED.show();
    delay(20);
  }
  delay(500);
}

void randomStrobe() {
  setRandomColor();
  strobe();
}

void flicker() {
  int randomBrightness = random(0, 255);
  int randomDelay = random(10, 100);
  int randomBoolean = random(0, randomBrightness);
  if (randomBoolean < 10) {
    for (int i = 0; i < LED_STRIP_LENGTH; i++) {
      ledStrip[i] = CHSV(currentStripHue, currentStripSaturation, randomBrightness);
    }
    FastLED.show();
    delay(randomDelay);
  }
}

void glow() {
  if (bounceDirection == 0) {
    startGlow();
    bounceDirection = 1;
  }
  copyLedStrip();
  int iCW;
  int iCCW;
  for (int i = 0; i < LED_STRIP_LENGTH; i++ ) {
    iCW = getNearClockWiseLedIndex(i);
    iCCW = getNearCounterClockWiseLedIndex(i);
    int iSum = getPixelRGBSum(ledStripBuffer[i]);
    int iCWSum = getPixelRGBSum(ledStripBuffer[iCW]);
    int iCCWSum = getPixelRGBSum(ledStripBuffer[iCCW]);
    if (iCCWSum > 0 && iSum > 0 && iCWSum > 0) {
      ledStrip[i] = CHSV(currentStripHue, 255, 0);
    }
    if (iCCWSum > 0 && iSum > 0 && iCWSum == 0) {
      ledStrip[i] = CHSV(currentStripHue, 255, 0);
    }
    if (iCCWSum > 0 && iSum == 0 && iCWSum > 0) {
      ledStrip[i] = CHSV(currentStripHue, 255, 0);
    }
    if (iCCWSum > 0 && iSum == 0 && iCWSum == 0) {
      ledStrip[i] = CHSV(currentStripHue, 255, 255);
    }
    if (iCCWSum == 0 && iSum > 0 && iCWSum > 0) {
      ledStrip[i] = CHSV(currentStripHue, 255, 255);
    }
    if (iCCWSum == 0 && iSum > 0 && iCWSum == 0) {
      ledStrip[i] = CHSV(currentStripHue, 255, 255);
    }
    if (iCCWSum == 0 && iSum == 0 && iCWSum > 0) {
      ledStrip[i] = CHSV(currentStripHue, 255, 255);
    }
    if (iCCWSum == 0 && iSum == 0 && iCWSum == 0) {
      ledStrip[i] = CHSV(currentStripHue, 255, 0);
    }
  }
  FastLED.show();
  if (safeDelay(currentEffectDelay)) return;
}

void fillStrip(int red, int green, int blue) {
  for (int i = 0; i < LED_STRIP_LENGTH; i++) {
    ledStrip[i].setRGB(red, green, blue);
  }
  FastLED.show();
}
