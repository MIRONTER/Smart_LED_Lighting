import 'package:led_bottom_lighting_controller/presentation/screens/home_screen.dart';
import 'bt_controller.dart';

void changeBrightness(double brightness) {
  sendCommand('B'+brightness.toInt().toString());
}

void changeChangePeriod(double period) {
  sendCommand('C'+period.toInt().toString());
}

void switchMode(String modeName) {
  if (currentModeName != modeName) {
    currentModeName = modeName;
    switch (modeName) {
      case 'Rainbow Fade':
        sendCommand('M1');
        break;
      case 'Random Pixels (All LEDs)':
        sendCommand('M2');
        break;
      case 'Random Pixels (Some LEDs)':
        sendCommand('M3');
        break;
      case 'Two Colors Spinning':
        sendCommand('M4');
        break;
      case 'Three Colors Spinning':
        sendCommand('M5');
        break;
      case 'Color Brightness Pulse':
        sendCommand('M6');
        break;
      case 'Color Saturation Pulse':
        sendCommand('M7');
        break;
      case 'Two Overlaps':
        sendCommand('M8');
        break;
      case 'Random Strip':
        sendCommand('M9');
        break;
      case 'Segmented Pulse':
        sendCommand('M10');
        break;
      case 'Color Wipe':
        sendCommand('M11');
        break;
      case 'Spinning Rainbow':
        sendCommand('M12');
        break;
      case 'Color Multipulse':
        sendCommand('M13');
        break;
      case 'Static White':
        sendCommand('M14');
        break;
      case 'Static Red':
        sendCommand('M15');
        break;
      case 'Static Green':
        sendCommand('M16');
        break;
      case 'Static Blue':
        sendCommand('M17');
        break;
      case 'Static Lime':
        sendCommand('M18');
        break;
      case 'Static Aqua':
        sendCommand('M19');
        break;
      case 'Static Purple':
        sendCommand('M20');
        break;
      case 'Static Pink':
        sendCommand('M21');
        break;
      case 'Static Yellow':
        sendCommand('M22');
        break;
    }
  }
}