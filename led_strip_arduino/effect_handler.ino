void performEffect() {
  switch (ledEffect) {
    case 1: rainbowFade(); break;
    case 2: randomLedChangeColor(); break;
    case 3: twoColorsSpinning(); break;
    case 4: threeColorsSpinning(); break;
    case 5: brightnessPulse(); break;
    case 6: saturationPulse(); break;
    case 7: randomStream(); break;
    case 8: colorWipe(); break;
    case 9: rainbowWave(); break;
    case 10: brightnessWave(); break;
    case 11: flicker(); break;
    case 12: glow(); break;
  }
}

void changeEffect(int newEffect) {
  bounceDirection = 0;
  fillStrip(0, 0, 0);
  ledEffect = newEffect;
  currentStripSaturation = 255;
  setRandomColor();
  switch (newEffect) {
    case 1: currentEffectDelay = 10; break;
    case 2: currentEffectDelay = 0; break;
    case 3: currentEffectDelay = 10; break;
    case 4: currentEffectDelay = 10; break;
    case 5: currentEffectDelay = 0; break;
    case 6: currentEffectDelay = 0; break;
    case 7: currentEffectDelay = 30; break;
    case 8: currentEffectDelay = 20; break;
    case 9: currentEffectDelay = 0; break;
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
