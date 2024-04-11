import 'dart:math' as Math;
import 'package:flutter/material.dart';
import 'package:led_strip_controller/resource/text_styles.dart';

class TapGauge extends StatelessWidget {
  const TapGauge({
    super.key,
    required this.value,
    required this.min,
    required this.max,
    required this.onChange,
  });

  final int value;
  final int min;
  final int max;
  final Function(int)? onChange;

  @override
  Widget build(BuildContext context) {
    final buttonBackgroundColor = onChange != null ? Colors.red : Color(0xFF484848);
    final textColor = onChange != null ? Colors.white : Color(0xFF646464);
    return Padding(
      padding: const EdgeInsets.only(top: 9, bottom: 9, right: 12),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            onTap: () => onChange?.call(_clampInt(value - 1)),
            onLongPress: () => onChange?.call(_clampInt(value - 10)),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: buttonBackgroundColor,
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                child: SizedBox(
                  width: 10,
                  child: Center(
                    child: Text(
                      '-',
                      style: TextStyles.gaugeButton.copyWith(color: textColor),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 8),
          SizedBox(
            width: 36,
            child: Center(
              child: Text(
                '$value',
                style: TextStyles.regular.copyWith(color: textColor),
              ),
            ),
          ),
          SizedBox(width: 8),
          InkWell(
            onTap: () => onChange?.call(_clampInt(value + 1)),
            onLongPress: () => onChange?.call(_clampInt(value + 10)),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: buttonBackgroundColor,
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                child: SizedBox(
                  width: 10,
                  child: Center(
                    child: Text(
                      '+',
                      style: TextStyles.gaugeButton.copyWith(color: textColor),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  int _clampInt(int value) {
    return Math.min(Math.max(min, value), max);
  }
}
