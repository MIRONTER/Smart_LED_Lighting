enum LightMode {
  rainbowWave,
  rainbowFade,
  sparkle,
  doublePropeller,
  triplePropeller,
  brightnessPulse,
  saturationPulse,
  randomStream,
  colorWipe,
  brightnessWave,
  flicker,
  glow,
  staticWhite,
  staticRed,
  staticGreen,
  staticBlue,
  staticYellow,
  staticAqua,
  staticPurple,
  staticPink,
  staticOrange,
}

extension LightModeData on LightMode {
  int getCode() => LightMode.values.indexOf(this) + 1;

  String getAsset() => 'assets/images/${_getWords().join('_').toLowerCase()}.${_getWords().contains('static') ? 'png' : 'gif'}';

  String getDisplayName() {
    var name = _getWords().join(' ');
    return "${name[0].toUpperCase()}${name.substring(1)}";
  }

  List<String> _getWords() => this.toString().split('.')[1].split(RegExp(r"(?<=[a-z])(?=[A-Z])"));
}