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

void brightnessPulse() {
  if (bounceDirection == 0) {
    ledBrightness++;
    if (ledBrightness >= 255) {
      bounceDirection = 1;
    }
  }
  if (bounceDirection == 1) {
    ledBrightness--;
    if (ledBrightness <= 1) {
      bounceDirection = 0;
    }
  }
  for (int i = 0; i < LED_STRIP_LENGTH; i++) {
    ledStrip[i] = CHSV(0, 255, ledBrightness);
  }
  FastLED.show();
  if (safeDelay(currentEffectDelay)) return;
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

void fillStrip(int red, int green, int blue) {
  for (int i = 0; i < LED_STRIP_LENGTH; i++) {
    ledStrip[i].setRGB(red, green, blue);
  }
  FastLED.show();
}
