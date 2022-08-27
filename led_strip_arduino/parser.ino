void parseCommand(String command) {
  command.toLowerCase();
  Serial.println(command);
  
  if (IS_BLUETOOTH_ENABLED) bluetooth.println(command);
  
  if (command.startsWith("b")) {
    command.remove(0, 1);
    maxBrightness = command.toInt();
    FastLED.setBrightness(maxBrightness);
    FastLED.show();
  }
  
  if (command.startsWith("m")) {
    command.remove(0, 1);
    autoSwitch = 0;
    changeEffect(command.toInt());
  }
  
  if (command.startsWith("a")) {
    command.remove(0, 1);
    autoSwitch = command.toInt();
  }
  
  if (command.startsWith("s")) {
    command.remove(0, 1);
    enableAutoStaticEffects = command.toInt();
  }
  
  if (command.startsWith("c")) {
    command.remove(0, 1);
    changePeriodMilliseconds = command.toInt() * 1000;
    lastChange = millis();
  }
}
