enum LightMode {
  static,
  brightnessPulse,
  brightnessWave,
  rainbowWave,
  rainbowFade;

  static LightMode fromCode(int code) {
    final index = code--;
    return LightMode.values[index];
  }

  int get code => LightMode.values.indexOf(this) + 1;

  bool get hasBaseColor => this.index < 3;

  String get asset {
    final words = _words;
    return 'assets/images/${_words.join('_').toLowerCase()}.${words.contains('static') ? 'png' : 'gif'}';
  }

  String get displayName {
    final name = _words.join(' ');
    return "${name[0].toUpperCase()}${name.substring(1)}";
  }

  List<String> get _words =>
      this.toString().split('.')[1].split(RegExp(r"(?<=[a-z])(?=[A-Z])"));
}
