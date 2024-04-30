void performAutoSwitch() {
  if (millis() - lastChange > CHANGE_PERIOD && currentAutoSwitch) {
    byte newMode = random(1, 6);
    while (newMode == currentMode) {
      newMode = random(1, 6);
    }
    currentMode = newMode;
    changeMode(currentMode);
    lastChange = millis();
  }
}

void performEffect() {
  switch (currentMode) {
    case 1: fillStrip(currentBaseColor[0], currentBaseColor[1], currentBaseColor[2]); break;
    case 2: brightnessPulse(); break;
    case 3: brightnessWave(); break;
    case 4: rainbowWave(); break;
    case 5: rainbowFade(); break;
  }
}

void changeMode(int newMode) {
  bounceDirection = 0;
  ledHue = 0;
  ledBrightness = 0;
  fillStrip(0, 0, 0);
  currentMode = newMode;
  setMode(newMode);
  switch (newMode) {
    case 1: currentEffectDelay = 0; break;
    case 2: currentEffectDelay = 10; break;
    case 3: currentEffectDelay = 50; break;
    case 4: currentEffectDelay = 0; break;
    case 5: currentEffectDelay = 10; break;
  }
}
