import 'package:flutter/material.dart';
import 'package:led_strip_controller/feature/home_screen/light_mode.dart';
import 'package:led_strip_controller/resource/text_styles.dart';

class EffectCard extends StatelessWidget {
  const EffectCard(
      {Key? key, required this.lightMode, this.onTap, this.isSelected = false})
      : super(key: key);

  final LightMode lightMode;
  final VoidCallback? onTap;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: const BorderRadius.all(Radius.circular(16)),
            border: Border.all(color: Color(0xFF484848), width: 1),
            image:
                DecorationImage(image: ExactAssetImage(lightMode.getAsset())),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Visibility(
                visible: isSelected,
                child: Icon(
                  Icons.done,
                  color: Colors.green,
                  size: 50,
                  shadows: [
                    Shadow(color: Colors.black, blurRadius: 50),
                    Shadow(color: Colors.black, blurRadius: 40),
                    Shadow(color: Colors.black, blurRadius: 30),
                    Shadow(color: Colors.black, blurRadius: 20),
                    Shadow(color: Colors.black, blurRadius: 10),
                  ],
                ),
              ),
              Flexible(
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Text(
                    lightMode.getDisplayName(),
                    textAlign: TextAlign.center,
                    style: isSelected
                        ? TextStyles.modeNameSelected
                        : TextStyles.modeNameUnselected,
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
