import 'package:led_strip_controller/util/serial_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Memory {
  static const _lastBluetoothMacKey = 'last_bluetooth_mac';
  static const _lastControllerKey = 'last_controller';
  static const _primaryControllerKey = 'primary_controller';

  Memory._();
  factory Memory() => _instance;
  static final _instance = Memory._();

  late SharedPreferences _prefs;

  Future<void> init() async => _prefs = await SharedPreferences.getInstance();

  Future<void> setLastBluetoothMac(String mac) => _prefs.setString(_lastBluetoothMacKey, mac);
  String? getLastBluetoothMac() => _prefs.getString(_lastBluetoothMacKey);

  Future<void> setLastController(SerialControllers controller) {
    switch (controller) {
      case SerialControllers.bluetooth: return _prefs.setString(_lastControllerKey, 'BT');
      case SerialControllers.usb: return _prefs.setString(_lastControllerKey, 'USB');
    }
  }
  SerialControllers? getLastController() {
    var lastController = _prefs.getString(_lastControllerKey);
    switch (lastController) {
      case 'USB': return SerialControllers.usb;
      case 'BT': return SerialControllers.bluetooth;
      default: return null;
    }
  }

  Future<void> setPrimaryController(SerialControllers controller) {
    switch (controller) {
      case SerialControllers.bluetooth: return _prefs.setString(_primaryControllerKey, 'BT');
      case SerialControllers.usb: return _prefs.setString(_primaryControllerKey, 'USB');
    }
  }
  SerialControllers? getPrimaryController() {
    var primaryController = _prefs.getString(_primaryControllerKey);
    switch (primaryController) {
      case 'USB': return SerialControllers.usb;
      case 'BT': return SerialControllers.bluetooth;
      default: return null;
    }
  }
  Future<bool> removePrimaryController() => _prefs.remove(_primaryControllerKey);
}