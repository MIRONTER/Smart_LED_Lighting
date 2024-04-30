boolean changeFlag;

void setPixel(int i, byte red, byte green, byte blue) {
  ledStrip[i].r = red;
  ledStrip[i].g = green;
  ledStrip[i].b = blue;
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
