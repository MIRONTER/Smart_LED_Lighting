void rainbowFade() {
  ledHue++;
  for (int i = 0; i < LED_STRIP_LENGTH; i++) {
    ledStrip[i] = CHSV(ledHue, 255, 255);
  }
  FastLED.show();
  if (safeDelay(currentEffectDelay)) return;
}

void brightnessPulse() {
  if (bounceDirection == 0) {
    ledBrightness = ledBrightness + 3;
    if (ledBrightness >= 255) {
      bounceDirection = 1;
    }
  } else if (bounceDirection == 1) {
    ledBrightness = ledBrightness - 3;
    if (ledBrightness <= 1) {
      bounceDirection = 0;
    }
  }
  for (int i = 0; i < LED_STRIP_LENGTH; i++) {
     setPixel(
        i,
        (ledBrightness / 255.0 * currentBaseColor[0]),
        (ledBrightness / 255.0 * currentBaseColor[1]),
        (ledBrightness / 255.0 * currentBaseColor[2])
      );
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
  for (int index = 0; index < LED_STRIP_LENGTH; index++) {
    for (int subIndex = 0; subIndex < LED_STRIP_LENGTH; subIndex++) {
      if (Serial.available()) {
        break;
      }
      setPixel(
        subIndex,
        getWaveBrightness(index, subIndex) * currentBaseColor[0],
        getWaveBrightness(index, subIndex) * currentBaseColor[1],
        getWaveBrightness(index, subIndex) * currentBaseColor[2]
      );
    }
    if (Serial.available()) {
        break;
    }
    FastLED.show();
    if (safeDelay(currentEffectDelay)) return;
  }
}

double getWaveBrightness(int index, int subIndex) {
  return cos(subIndex / 6 + index) / 2 + 0.5;
}

void fillStrip(byte r, byte g, byte b) {
  for (int i = 0; i < LED_STRIP_LENGTH; i++) {
    ledStrip[i].setRGB(r, g, b);
  }
  FastLED.show();
}
