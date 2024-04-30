#include <EEPROM.h>

void getMode() {
  byte mode;
  EEPROM.get(0, mode);
  if (mode < 1 || mode > 5) {
    currentMode = 1;
  } else {
    currentMode = mode;
  }
}

void setMode(byte mode) {
  EEPROM.put(0, mode);
}

void getAutoSwitch() {
  byte autoSwitch;
  EEPROM.get(1, autoSwitch);
  if (autoSwitch < 0 || autoSwitch > 1) {
    currentAutoSwitch = 1;
  } else {
    currentAutoSwitch = autoSwitch;
  }
}

void setAutoSwitch(byte autoSwitch) {
  EEPROM.put(1, autoSwitch);
}

void getBaseColor() {
  byte r, g, b;
  EEPROM.get(2, r);
  EEPROM.get(3, g);
  EEPROM.get(4, b);
  currentBaseColor[0] = r;
  currentBaseColor[1] = g;
  currentBaseColor[2] = b;
}

void setBaseColor(byte r, byte g, byte b) {
  EEPROM.put(2, r);
  EEPROM.put(3, g);
  EEPROM.put(4, b);
}
