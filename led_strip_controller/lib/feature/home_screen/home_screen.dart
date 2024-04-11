import 'package:led_strip_controller/feature/home_screen/widget/effect_card.dart';
import 'package:led_strip_controller/feature/home_screen/light_mode.dart';
import 'package:led_strip_controller/feature/home_screen/widget/tap_gauge.dart';
import 'package:led_strip_controller/util/serial_controller.dart';
import 'package:flutter/material.dart';
import 'package:led_strip_controller/resource/text_styles.dart';
import 'package:led_strip_controller/util/strip_settings.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _ledStripOn = true;
  bool _autoSwitch = true;
  bool _staticEffects = false;
  int _brightness = 128;
  int _changePeriodSeconds = 300;
  LightMode _currentMode = LightMode.rainbowWave;
  late UsbController _serialController;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  ValueNotifier<bool> _isConnected = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    _serialController = UsbController();
    _serialController.isConnected.addListener(_connectionListener);
    _serialController.connect();
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
              title: Text('LED Strip Controller', style: TextStyles.appBar),
              centerTitle: true,
              leading: InkWell(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Icon(Icons.usb,
                      color: (isConnected) ? Colors.green : Colors.red),
                ),
                onTap: _toggleUsb,
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('LED Strip', style: TextStyles.regular),
                            Switch(
                              value:
                                  _ledStripOn && _brightness > 0 && isConnected,
                              onChanged: _toggleStrip,
                              inactiveTrackColor: Color(0xFF484848),
                              inactiveThumbColor: Color(0xFF646464),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Automatic Switch',
                                style: TextStyles.regular),
                            Switch(
                              value: _autoSwitch,
                              onChanged: isConnected ? _toggleAutoSwitch : null,
                              inactiveTrackColor: Color(0xFF484848),
                              inactiveThumbColor: Color(0xFF646464),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Static Effects',
                                style: TextStyles.regular),
                            Switch(
                              value: _staticEffects,
                              onChanged:
                                  isConnected ? _toggleStaticEffects : null,
                              inactiveTrackColor: Color(0xFF484848),
                              inactiveThumbColor: Color(0xFF646464),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Brightness', style: TextStyles.regular),
                            TapGauge(
                              value: _brightness,
                              min: 0,
                              max: 255,
                              onChange: isConnected ? _changeBrightness : null,
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Change period',
                                style: TextStyles.regular),
                            TapGauge(
                              value: _changePeriodSeconds,
                              min: 30,
                              max: 600,
                              onChange: isConnected ? _changePeriod : null,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: GridView.builder(
                      padding: const EdgeInsets.only(bottom: 24),
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 10 / 9,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      itemCount: LightMode.values.length,
                      itemBuilder: (context, index) {
                        var mode = LightMode.values[index];
                        return EffectCard(
                          lightMode: mode,
                          isSelected: _currentMode == mode &&
                              !_autoSwitch &&
                              isConnected,
                          onTap: isConnected ? () => _selectEffect(mode) : null,
                        );
                      },
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
    _serialController.changeMode(mode);
    setState(() {
      _currentMode = mode;
      _autoSwitch = false;
    });
  }

  void _changePeriod(int period) {
    setState(() {
      _changePeriodSeconds = period;
    });
    _serialController.changePeriod(period);
  }

  void _changeBrightness(int brightness) {
    setState(() {
      _brightness = brightness;
      if (_brightness == 0) {
        _ledStripOn = false;
      } else {
        _ledStripOn = true;
      }
    });
    _serialController.changeBrightness(brightness);
  }

  void _toggleStrip(bool isOn) async {
    if (!_isConnected.value) await _serialController.connect();
    setState(() => _ledStripOn = isOn);
    if (_brightness == 0) _brightness = 128;
    _serialController.changeBrightness(isOn ? _brightness : 0);
  }

  void _toggleStaticEffects(bool isOn) {
    setState(() => _staticEffects = isOn);
    _serialController.toggleStaticEffects(isOn);
  }

  void _toggleAutoSwitch(bool isOn) {
    setState(() => _autoSwitch = isOn);
    _serialController.toggleAutoSwitch(isOn);
  }

  void _toggleUsb() async {
    _serialController.toggleConnection();
  }

  void _connectionListener() {
    var isConnected = _serialController.isConnected.value;
    _isConnected.value = isConnected;
    if (isConnected) {
      _showSnackBar('USB connected');
    } else {
      _showSnackBar('USB disconnected');
      _currentMode = LightMode.rainbowWave;
      _brightness = 128;
      _changePeriodSeconds = 300;
      _autoSwitch = true;
      _staticEffects = false;
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(_scaffoldKey.currentContext!).hideCurrentSnackBar();
    ScaffoldMessenger.of(_scaffoldKey.currentContext!).showSnackBar(
      SnackBar(
        content: Text(message, style: TextStyles.regular),
        backgroundColor: Color(0xFF282828),
        elevation: 15,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
