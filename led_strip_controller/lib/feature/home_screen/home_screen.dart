import 'package:led_strip_controller/feature/home_screen/effect_card.dart';
import 'package:led_strip_controller/feature/home_screen/light_mode.dart';
import 'package:led_strip_controller/util/bt_controller.dart';
import 'package:flutter/material.dart';
import 'package:led_strip_controller/resource/text_styles.dart';
import 'package:led_strip_controller/util/strip_settings.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _ledStripOn = true;
  bool _autoSwitch = false;
  bool _staticEffects = false;
  int _brightness = 128;
  int _changePeriodSeconds = 300;
  LightMode _currentMode = LightMode.rainbowWave;
  BluetoothController _bluetoothController = BluetoothController();

  @override
  void initState() {
    super.initState();
    _bluetoothController.connect();
  }

  @override
  void dispose() {
    _bluetoothController.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _bluetoothController.isConnected,
      builder: (_, bool isConnected, __) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Led Strip Controller', style: TextStyles.appBar),
            actions: [
              IconButton(
                icon: Icon(
                    Icons.bluetooth,
                    color: isConnected ? Colors.green : Colors.red
                ),
                onPressed: _bluetoothController.toggleConnection,
              ),
            ],
          ),
          body: Scrollbar(
            thickness: 3,
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(left: 12, right: 12, bottom: 0, top: 24),
                child: Column(
                  children: [
                    Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('LED Strip', style: TextStyles.regular),
                        Switch(
                          value: _ledStripOn && _brightness > 0 && isConnected,
                          onChanged: _toggleStrip,
                          inactiveTrackColor: Color(0xFF484848),
                          inactiveThumbColor: Color(0xFF646464),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Text('Brightness', style: TextStyles.regular),
                            Text('$_brightness/255', style: TextStyles.regular),
                          ],
                        ),
                        Slider(
                          min: 0, max: 255,
                          value: _brightness.toDouble(),
                          onChanged: isConnected ? _changeBrightness : null,
                          onChangeEnd: isConnected ? (value) => _bluetoothController.changeBrightness(value.toInt()) : null,
                          activeColor: Colors.red,
                          inactiveColor: Color(0xFF484848),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Text('Change period', style: TextStyles.regular),
                            Text('$_changePeriodSeconds seconds', style: TextStyles.regular),
                          ],
                        ),
                        Slider(
                          min: 0, max: 600,
                          value: _changePeriodSeconds.toDouble(),
                          onChanged: isConnected ? (value) => setState(() => _changePeriodSeconds = value.toInt()) : null,
                          onChangeEnd: isConnected ? (value) => _bluetoothController.changeChangePeriod(value.toInt()) : null,
                          activeColor: Colors.red,
                          inactiveColor: Color(0xFF484848),
                        ),
                      ],
                    ),
                    Divider(),
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Text('Modes', style: TextStyles.header),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Automatic Switch', style: TextStyles.regular),
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
                        Text('Static Effects', style: TextStyles.regular),
                        Switch(
                          value: _staticEffects,
                          onChanged: isConnected ? _toggleStaticEffects : null,
                          inactiveTrackColor: Color(0xFF484848),
                          inactiveThumbColor: Color(0xFF646464),
                        ),
                      ],
                    ),
                    GridView.builder(
                      padding: EdgeInsets.only(bottom: 24),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 10/9,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                      ),
                      itemCount: LightMode.values.length,
                      itemBuilder: (context, index) {
                        var mode = LightMode.values[index];
                        return EffectCard(
                          lightMode: mode,
                          isSelected: _currentMode == mode && !_autoSwitch && isConnected,
                          onTap: isConnected ? () => _selectEffect(mode) : null,
                        );
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _selectEffect(LightMode mode) {
    _bluetoothController.changeMode(mode);
    setState(() {
      _currentMode = mode;
      _autoSwitch = false;
    });
  }

  void _changeBrightness(double brightness) {
    setState(() {
      _brightness = brightness.toInt();
      if (_brightness == 0) {
        _ledStripOn = false;
      } else {
        _ledStripOn = true;
      }
    });
  }

  void _toggleStrip(bool isOn) async {
    if (!_bluetoothController.isConnected.value) await _bluetoothController.connect();
    setState(() => _ledStripOn = isOn);
    if (_brightness == 0) _brightness = 128;
    _bluetoothController.changeBrightness(isOn ? _brightness : 0);
  }

  void _toggleStaticEffects(bool isOn) {
    setState(() => _staticEffects = isOn);
    _bluetoothController.toggleStaticEffects(isOn);
  }

  void _toggleAutoSwitch(bool isOn) {
    setState(() => _autoSwitch = isOn);
    _bluetoothController.toggleAutoSwitch(isOn);
  }
}
