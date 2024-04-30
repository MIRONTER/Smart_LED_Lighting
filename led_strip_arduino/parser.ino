void parseSerial() {
  if (Serial.available()) {
    char data[16];
    int amount = Serial.readBytesUntil(';', data, 16);
    data[amount] = '\0';

    char key = data[0];
    char* value = data + 1;

    switch (key) {
      case 'm': modeCommand(value); break;
      case 'a': autoSwitchCommand(value); break;
      case 'c': colorCommand(value); break;
    }
  }
}

void modeCommand(char* value) {
  byte mode = atoi(value);
  changeMode(mode);
  setMode(mode);
  currentAutoSwitch = 0;
  setAutoSwitch(0);
}

void autoSwitchCommand(char* value) {
  byte autoSwitch = atoi(value);
  currentAutoSwitch = autoSwitch;
  setAutoSwitch(autoSwitch);
}

void colorCommand(char* value) {
  byte b = atoi(value + 6);
  value[6] = '\0';
  byte g = atoi(value + 3);
  value[3] = '\0';
  byte r = atoi(value);
  currentBaseColor[0] = r;
  currentBaseColor[1] = g;
  currentBaseColor[2] = b;
  setBaseColor(r, g, b);
}
