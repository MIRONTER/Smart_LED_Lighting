import 'package:flutter/material.dart';

part 'text_styles.dart';
part 'colors.dart';

class AppTheme {
  static const textStyles = _TextStyles();
  static const colors = _Colors();

  final themeData = ThemeData(
    appBarTheme: AppBarTheme(
      elevation: 0,
      toolbarHeight: 40,
      color: colors.background,
    ),
    scaffoldBackgroundColor: colors.background,
    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
        if (states.contains(MaterialState.disabled)) {
          return colors.controlDisabledPrimary;
        }
        return colors.controlEnabledPrimary;
      }),
      trackColor: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
        if (states.contains(MaterialState.disabled)) {
          return colors.controlDisabledSecondary;
        }
        return colors.controlEnabledSecondary;
      }),
    ),
  );
}
