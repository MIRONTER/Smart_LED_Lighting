void performEffect() {
  switch (currentLightMode) {
    case 1: rainbowWave(); break;
    case 2: rainbowFade(); break;
    case 3: brightnessPulse(); break;
    case 4: brightnessWave(); break;
  }
}

void changeLightMode(int newLightMode) {
  bounceDirection = 0;
  fillStrip(0, 0, 0);
  currentLightMode = newLightMode;
  currentStripSaturation = 255;
  switch (newLightMode) {
    case 1: currentEffectDelay = 0; break;
    case 2: currentEffectDelay = 10; break;
    case 3: currentEffectDelay = 0; break;
    case 4: currentEffectDelay = 10; break;
    case 5: fillStrip(255, 255, 255); break;
  }
}
