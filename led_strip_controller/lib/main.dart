import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:led_strip_controller/feature/home_screen/home_screen.dart';

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
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          elevation: 0,
          toolbarHeight: 40,
          color: Colors.black,
        ),
        primaryColor: Colors.black,
        scaffoldBackgroundColor: Colors.black,
        toggleableActiveColor: Colors.red,
        dividerColor: Colors.white,
        colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.red),
      ),
      home: HomeScreen(),
    );
  }
}
