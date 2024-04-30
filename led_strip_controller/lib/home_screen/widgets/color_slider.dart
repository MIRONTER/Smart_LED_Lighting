import 'package:flutter/material.dart';

class ColorSlider extends StatelessWidget {
  const ColorSlider({
    super.key,
    required this.color,
    required this.value,
    required this.onChange,
  });

  final Color color;
  final double value;
  final Function(double)? onChange;

  @override
  Widget build(BuildContext context) {
    return SliderTheme(
      data: SliderThemeData(
        activeTrackColor: color,
        inactiveTrackColor: color.withOpacity(0.5),
        disabledActiveTrackColor: color.withOpacity(0.5),
        disabledInactiveTrackColor: color.withOpacity(0.25),
        thumbColor: color,
        disabledThumbColor: color,
      ),
      child: Slider(
        min: 0,
        max: 255,
        divisions: 255,
        value: value,
        onChanged: onChange,
      ),
    );
  }
}
