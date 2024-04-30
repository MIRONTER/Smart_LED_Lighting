import 'package:led_strip_controller/home_screen/widgets/color_slider.dart';
import 'package:led_strip_controller/home_screen/widgets/effect_card.dart';
import 'package:led_strip_controller/styles/app_theme.dart';
import 'package:led_strip_controller/util/debounce_command.dart';
import 'package:led_strip_controller/util/light_mode.dart';
import 'package:led_strip_controller/util/serial_controller.dart';
import 'package:flutter/material.dart';
import 'package:led_strip_controller/util/settings_storage.dart';
import 'package:led_strip_controller/util/strip_settings.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var _autoSwitch = true;
  var _baseColor = Colors.white;
  LightMode? _currentMode;

  final _scaffoldKey = GlobalKey();
  final _isConnected = ValueNotifier(false);

  late final UsbController _serialController;
  late final StripSettings _stripSettings;

  @override
  void initState() {
    super.initState();
    SettingsStorage.instance.initialize().then((_) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          _autoSwitch = SettingsStorage.instance.getAutoSwitch() ?? _autoSwitch;
          _baseColor = SettingsStorage.instance.getColor() ?? _baseColor;
          _currentMode = SettingsStorage.instance.getMode();
        });
        _serialController = UsbController();
        _serialController.isConnected.addListener(_connectionListener);
        _serialController.connect();
        _stripSettings = StripSettings(_serialController);
      });
    });
  }

  @override
  void dispose() {
    _serialController.isConnected.removeListener(_connectionListener);
    _isConnected.dispose();
    _serialController.isConnected.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _isConnected,
      builder: (BuildContext context, bool isConnected, __) {
        return ScaffoldMessenger(
          child: Scaffold(
            key: _scaffoldKey,
            appBar: AppBar(
              title: Text(
                'LED Strip Controller',
                style: AppTheme.textStyles.appBar,
              ),
              centerTitle: true,
              leading: InkWell(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Icon(
                    Icons.usb,
                    color: (isConnected)
                        ? AppTheme.colors.green
                        : AppTheme.colors.red,
                  ),
                ),
                onTap: _toggleUsb,
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Automatic Switch',
                              style: AppTheme.textStyles.regular,
                            ),
                            Switch(
                              value: _autoSwitch,
                              onChanged: isConnected ? _toggleAutoSwitch : null,
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              'Base Color',
                              style: AppTheme.textStyles.regular,
                            ),
                            ColorSlider(
                              color: AppTheme.colors.red,
                              value: _baseColor.red.toDouble(),
                              onChange: isConnected
                                  ? (value) {
                                      _setBaseColor(
                                        _baseColor.withRed(value.toInt()),
                                      );
                                    }
                                  : null,
                            ),
                            ColorSlider(
                              color: AppTheme.colors.green,
                              value: _baseColor.green.toDouble(),
                              onChange: isConnected
                                  ? (value) {
                                      _setBaseColor(
                                        _baseColor.withGreen(value.toInt()),
                                      );
                                    }
                                  : null,
                            ),
                            ColorSlider(
                              color: AppTheme.colors.blue,
                              value: _baseColor.blue.toDouble(),
                              onChange: isConnected
                                  ? (value) {
                                      _setBaseColor(
                                        _baseColor.withBlue(value.toInt()),
                                      );
                                    }
                                  : null,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      runAlignment: WrapAlignment.center,
                      alignment: WrapAlignment.center,
                      children: LightMode.values
                          .map(
                            (mode) => EffectCard(
                              lightMode: mode,
                              baseColor: _baseColor,
                              isSelected: _currentMode == mode &&
                                  !_autoSwitch &&
                                  isConnected,
                              onTap: isConnected
                                  ? () => _selectEffect(mode)
                                  : null,
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _selectEffect(LightMode mode) {
    setState(() {
      _currentMode = mode;
      _autoSwitch = false;
    });
    debouncedCommand(
      () => _stripSettings.changeMode(mode),
    );
  }

  void _toggleAutoSwitch(bool isOn) {
    setState(() {
      _autoSwitch = isOn;
      _currentMode = null;
    });
    debouncedCommand(
      () => _stripSettings.toggleAutoSwitch(isOn),
    );
  }

  void _setBaseColor(Color color) {
    setState(() => _baseColor = color);
    debouncedCommand(
      () => _stripSettings.changeBaseColor(color),
    );
  }

  void _toggleUsb() async {
    _serialController.toggleConnection();
  }

  void _connectionListener() {
    final isConnected = _serialController.isConnected.value;
    _isConnected.value = isConnected;
  }
}
