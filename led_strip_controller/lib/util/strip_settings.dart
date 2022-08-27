import 'package:led_strip_controller/feature/home_screen/light_mode.dart';
import 'package:led_strip_controller/util/bt_controller.dart';

extension StripSettings on BluetoothController{
  void changeBrightness(int brightness) => sendCommand('b$brightness');

  void changeChangePeriod(int period) => sendCommand('c$period');

  void changeMode(LightMode mode) => sendCommand('m${mode.getCode()}');

  void toggleAutoSwitch(bool autoSwitch) => sendCommand('a${autoSwitch ? 1 : 0}');

  void toggleStaticEffects(bool staticEffects) => sendCommand('s${staticEffects ? 1 : 0}');
}
