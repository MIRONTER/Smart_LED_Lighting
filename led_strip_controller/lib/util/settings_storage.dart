import 'dart:ui';

import 'package:led_strip_controller/util/light_mode.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _autoSwitchKey = 'auto_switch';
const _modeKey = 'mode';
const _colorKey = 'color';

class SettingsStorage {
  SettingsStorage._();

  factory SettingsStorage() => instance;

  static final instance = SettingsStorage._();

  late SharedPreferences _sharedPreferences;

  Future<void> initialize() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  Future<void> setAutoSwitch(bool autoSwitch) {
    return _sharedPreferences.setBool(_autoSwitchKey, autoSwitch);
  }

  bool? getAutoSwitch() {
    return _sharedPreferences.getBool(_autoSwitchKey);
  }

  Future<void> setMode(LightMode mode) {
    return _sharedPreferences.setInt(_modeKey, mode.index);
  }

  Future<void> clearMode() {
    return _sharedPreferences.remove(_modeKey);
  }

  LightMode? getMode() {
    final modeIndex = _sharedPreferences.getInt(_modeKey);
    return modeIndex == null ? null : LightMode.values[modeIndex];
  }

  Future<void> setColor(Color color) {
    return _sharedPreferences.setInt(_colorKey, color.value);
  }

  Color? getColor() {
    final colorValue = _sharedPreferences.getInt(_colorKey);
    return colorValue == null ? null : Color(colorValue);
  }
}
