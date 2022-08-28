void performEffect() {
  switch (currentLightMode) {
    case 1: rainbowWave(); break;
    case 2: rainbowFade(); break;
    case 3: sparkle(); break;
    case 4: doublePropeller(); break;
    case 5: triplePropeller(); break;
    case 6: brightnessPulse(); break;
    case 7: saturationPulse(); break;
    case 8: randomStream(); break;
    case 9: colorWipe(); break;
    case 10: brightnessWave(); break;
    case 11: flicker(); break;
    case 12: glow(); break;
  }
}

void changeLightMode(int newLightMode) {
  bounceDirection = 0;
  fillStrip(0, 0, 0);
  currentLightMode = newLightMode;
  currentStripSaturation = 255;
  setRandomColor();
  switch (newLightMode) {
    case 1: currentEffectDelay = 0; break;
    case 2: currentEffectDelay = 10; break;
    case 3: currentEffectDelay = 0; break;
    case 4: currentEffectDelay = 10; break;
    case 5: currentEffectDelay = 10; break;
    case 6: currentEffectDelay = 0; break;
    case 7: currentEffectDelay = 0; break;
    case 8: currentEffectDelay = 30; break;
    case 9: currentEffectDelay = 20; break;
    case 10: currentEffectDelay = 10; break;
    case 11: break;
    case 12: currentEffectDelay = 85; break;
    case 13: fillStrip(255, 255, 255); break;
    case 14: fillStrip(255, 0, 0); break;
    case 15: fillStrip(0, 255, 0); break;
    case 16: fillStrip(0, 0, 255); break;
    case 17: fillStrip(255, 255, 0); break;
    case 18: fillStrip(0, 255, 255); break;
    case 19: fillStrip(255, 0, 255); break;
    case 20: fillStrip(255, 0, 128); break;
    case 21: fillStrip(255, 128, 0); break;
  }
}
