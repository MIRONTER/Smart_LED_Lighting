import 'package:flutter/material.dart';
import 'package:led_strip_controller/styles/app_theme.dart';
import 'package:led_strip_controller/util/light_mode.dart';

class EffectCard extends StatelessWidget {
  const EffectCard({
    Key? key,
    required this.lightMode,
    required this.baseColor,
    this.onTap,
    this.isSelected = false,
  }) : super(key: key);

  final Color baseColor;
  final LightMode lightMode;
  final VoidCallback? onTap;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return SizedBox(
      // Section with these cards takes 2/3 of the screen width
      // Each card should take 1/3 of available width excluding spacing
      width: (screenWidth * 2 / 3) / 3 - 12 * 2,
      child: AspectRatio(
        aspectRatio: 10 / 9,
        child: GestureDetector(
          onTap: onTap,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: AppTheme.colors.background,
              borderRadius: const BorderRadius.all(Radius.circular(16)),
              border: isSelected
                  ? Border.all(color: AppTheme.colors.borderSelected, width: 2)
                  : Border.all(color: AppTheme.colors.border, width: 1),
              image: DecorationImage(
                image: ExactAssetImage(lightMode.asset),
                colorFilter: lightMode.hasBaseColor
                    ? ColorFilter.mode(baseColor, BlendMode.color)
                    : null,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Text(
                  lightMode.displayName,
                  textAlign: TextAlign.center,
                  style: isSelected
                      ? AppTheme.textStyles.modeNameSelected
                      : AppTheme.textStyles.modeNameUnselected,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
