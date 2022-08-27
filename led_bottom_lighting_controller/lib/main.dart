import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:led_bottom_lighting_controller/presentation/screens.dart';

void main() => runApp(LEDBottomLightingController());

class LEDBottomLightingController extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return MaterialApp(
    title: 'LED Bottom Lighting Controller',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      accentColor: Colors.red,
      appBarTheme: AppBarTheme(
        elevation: 20,
        shadowColor: Colors.red,
        color: Colors.black
      ),
      primaryColor: Colors.black,
      scaffoldBackgroundColor: Colors.black,
      toggleableActiveColor: Colors.red,
      dividerColor: Colors.white
    ),
    routes: <String, WidgetBuilder> {
      '/': (context) => HomeScreen(),
    },
    initialRoute: '/',
  );
  }
}
