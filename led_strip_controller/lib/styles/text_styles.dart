part of 'app_theme.dart';

class _TextStyles {
  const _TextStyles()
      : this.appBar = const TextStyle(
          fontFamily: 'Ubuntu',
          color: Colors.white,
          fontSize: 22,
          fontWeight: FontWeight.w700,
        ),
        this.header = const TextStyle(
          fontFamily: 'Ubuntu',
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        this.subHeader = const TextStyle(
          fontFamily: 'Ubuntu',
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w400,
        ),
        this.modeNameSelected = const TextStyle(
          fontFamily: 'Ubuntu',
          color: Colors.white,
          fontSize: 25,
          fontWeight: FontWeight.w600,
        ),
        this.modeNameUnselected = const TextStyle(
          fontFamily: 'Ubuntu',
          color: Colors.white,
          fontSize: 22,
          fontWeight: FontWeight.w300,
        ),
        this.regular = const TextStyle(
          fontFamily: 'Ubuntu',
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w400,
        );

  final TextStyle appBar;
  final TextStyle header;
  final TextStyle subHeader;
  final TextStyle modeNameSelected;
  final TextStyle modeNameUnselected;
  final TextStyle regular;
}
