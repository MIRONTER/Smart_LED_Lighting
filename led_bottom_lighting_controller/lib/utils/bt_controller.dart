import 'dart:convert';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

BluetoothConnection connection;

void sendCommand (String command) async {
  if (command.length > 0) {
    try {
      connection.output.add(utf8.encode(command));
      await connection.output.allSent;
    } catch (e) {}
  }
}