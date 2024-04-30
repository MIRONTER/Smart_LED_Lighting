import 'dart:ui';

import 'package:led_strip_controller/util/light_mode.dart';
import 'package:led_strip_controller/util/serial_controller.dart';
import 'package:led_strip_controller/util/settings_storage.dart';

class StripSettings {
  StripSettings(this._controller);

  final UsbController _controller;

  Future<void> changeBaseColor(Color color) {
    final r = color.red.toString().padLeft(3, '0');
    final g = color.green.toString().padLeft(3, '0');
    final b = color.blue.toString().padLeft(3, '0');
    return Future.wait([
      _controller.sendCommand('c$r$g$b'),
      SettingsStorage.instance.setColor(color),
    ]);
  }

  Future<void> changeMode(LightMode mode) {
    return Future.wait([
      _controller.sendCommand('m${mode.code}'),
      SettingsStorage.instance.setMode(mode),
    ]);
  }

  Future<void> toggleAutoSwitch(bool autoSwitch) {
    return Future.wait([
      _controller.sendCommand('a${autoSwitch ? 1 : 0}'),
      SettingsStorage.instance.setAutoSwitch(autoSwitch),
      SettingsStorage.instance.clearMode(),
    ]);
  }
}
