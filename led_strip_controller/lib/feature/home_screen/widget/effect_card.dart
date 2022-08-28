import 'package:flutter/material.dart';
import 'package:led_strip_controller/feature/home_screen/light_mode.dart';
import 'package:led_strip_controller/resource/text_styles.dart';

class EffectCard extends StatelessWidget {
  const EffectCard({Key? key, required this.lightMode, this.onTap, this.isSelected = false}) : super(key: key);

  final LightMode lightMode;
  final VoidCallback? onTap;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        elevation: 12,
        shadowColor: Colors.red,
        color: Colors.black,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Image.asset(lightMode.getAsset()),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Visibility(
                  child: Icon(Icons.done, color: Colors.green, size: 50),
                  visible: isSelected,
                ),
                Flexible(
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Text(
                      lightMode.getDisplayName(),
                      textAlign: TextAlign.center,
                      style: isSelected ? TextStyles.modeNameSelected : TextStyles.modeNameUnselected,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
