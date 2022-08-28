import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:led_strip_controller/feature/home_screen/home_screen.dart';
import 'package:led_strip_controller/util/memory.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Memory().init().then((_) => runApp(LEDStripController()));
}

class LEDStripController extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return MaterialApp(
      title: 'LED Strip Controller',
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          elevation: 20,
          shadowColor: Colors.red,
          color: Colors.black
        ),
        primaryColor: Colors.black,
        scaffoldBackgroundColor: Colors.black,
        toggleableActiveColor: Colors.red,
        dividerColor: Colors.white,
        colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.red),
        sliderTheme: SliderThemeData(
          disabledActiveTrackColor: Color(0xFF484848),
          disabledInactiveTrackColor: Color(0xFF484848),
          disabledThumbColor: Color(0xFF646464),
        ),
      ),
      home: HomeScreen(),
    );
  }
}
