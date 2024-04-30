import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:led_strip_controller/home_screen/home_screen.dart';
import 'package:led_strip_controller/styles/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeRight]);
  runApp(LEDStripController());
}

class LEDStripController extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LED Strip Controller',
      theme: AppTheme().themeData,
      home: HomeScreen(),
    );
  }
}
