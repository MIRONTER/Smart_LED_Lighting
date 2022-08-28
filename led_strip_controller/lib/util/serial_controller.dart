import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:led_strip_controller/util/memory.dart';
import 'package:usb_serial/usb_serial.dart';

enum SerialControllers {usb, bluetooth}

abstract class SerialController {
  SerialController();

  factory SerialController.choose(SerialControllers option) {
    switch (option) {
      case SerialControllers.usb: return UsbController();
      case SerialControllers.bluetooth: return BluetoothController();
    }
  }

  ValueNotifier<bool> isConnected = ValueNotifier(false);

  Future<void> connect();

  void disconnect();

  void toggleConnection();

  void sendCommand(String command);
}

class UsbController extends SerialController {
  UsbController() {
    UsbSerial.usbEventStream?.listen((event) {
      if (event.event == UsbEvent.ACTION_USB_ATTACHED) connect();
      if (event.event == UsbEvent.ACTION_USB_DETACHED) disconnect();
    });
  }

  static const _ch340VendorId = 0x1A86;
  static const _ch340ProductId = 0x7523;
  static const _baudRate = 9600;

  UsbDevice? _device;
  UsbPort? _port;

  @override
  Future<void> connect() async {
    var usbDeviceList = await UsbSerial.listDevices();

    try {
      _device = usbDeviceList.firstWhere((device) => _isCH340(device));
    } catch (e) {
      _device = null;
    }

    if (_device != null) {
      _port = await _device!.create();
      if (_port != null && await _port!.open()) {
       await _port!.setDTR(true);
       await _port!.setRTS(true);
       await _port!.setPortParameters(_baudRate, UsbPort.DATABITS_8, UsbPort.STOPBITS_1, UsbPort.PARITY_NONE);
       isConnected.value = true;
       Memory().setLastController(SerialControllers.usb);
      }
    }
  }

  @override
  void disconnect() async {
    await _port?.close();
    _port = null;
    _device = null;
    isConnected.value = false;
  }

  @override
  void toggleConnection() {
    if (_port != null && _device != null) {
      disconnect();
    } else {
      connect();
    }
  }

  @override
  void sendCommand(String command) async {
    if (command.length > 0) {
      try {
        await _port?.write(Uint8List.fromList(utf8.encode(command)));
      } catch (e) {
        disconnect();
      }
    }
  }

  bool _isCH340(UsbDevice device) => device.vid == _ch340VendorId && device.pid == _ch340ProductId;
}

class BluetoothController extends SerialController {
  BluetoothConnection? _connection;

  @override
  Future<void> connect() async {
    var mac = Memory().getLastBluetoothMac();
    if (mac == null) return;
    _connection = await BluetoothConnection.toAddress(mac);
    isConnected.value = true;
    Memory().setLastController(SerialControllers.bluetooth);
  }

  @override
  void disconnect() {
    _connection?.close();
    _connection = null;
    isConnected.value = false;
  }

  @override
  void toggleConnection() {
    if (_connection?.isConnected ?? false) {
      disconnect();
    } else {
      connect();
    }
  }

  @override
  void sendCommand(String command) async {
    if (command.length > 0) {
      try {
        _connection?.output.add(Uint8List.fromList(utf8.encode(command)));
        await _connection?.output.allSent;
      } catch (e) {
        disconnect();
      }
    }
  }
}