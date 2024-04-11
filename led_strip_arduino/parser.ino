void parseCommand(String command) {
  command.toLowerCase();
  Serial.println(command);
  
  if (command.startsWith("m")) {
    command.remove(0, 1);
    autoSwitch = 0;
    changeLightMode(command.toInt());
  }
  
  if (command.startsWith("a")) {
    command.remove(0, 1);
    autoSwitch = command.toInt();
  }
  
  if (command.startsWith("c")) {
    command.remove(0, 1);
    changePeriodMilliseconds = command.toInt() * 1000;
    lastChange = millis();
  }
}
