import 'package:led_strip_controller/feature/home_screen/light_mode.dart';
import 'package:led_strip_controller/util/serial_controller.dart';

extension StripSettings on SerialController {
  void changeBrightness(int brightness) => sendCommand('b$brightness');

  void changePeriod(int period) => sendCommand('c$period');

  void changeMode(LightMode mode) => sendCommand('m${mode.getCode()}');

  void toggleAutoSwitch(bool autoSwitch) => sendCommand('a${autoSwitch ? 1 : 0}');

  void toggleStaticEffects(bool staticEffects) => sendCommand('s${staticEffects ? 1 : 0}');
}
