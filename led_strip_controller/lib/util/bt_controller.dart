import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class BluetoothController {
  static const controllerMAC = '20:16:05:20:21:47';

  BluetoothConnection? connection;

  ValueNotifier<bool> isConnected = ValueNotifier(false);

  Future<void> connect() async {
    connection = await BluetoothConnection.toAddress(controllerMAC);
    isConnected.value = true;
  }

  void disconnect() {
    connection?.close();
    connection = null;
    isConnected.value = false;
  }

  void toggleConnection() {
    if (connection?.isConnected ?? false) {
      connect();
    } else {
      disconnect();
    }
  }

  void sendCommand(String command) async {
    if (command.length > 0) {
      try {
        connection?.output.add(Uint8List.fromList(utf8.encode(command)));
        await connection?.output.allSent;
      } catch (e) {}
    }
  }
}