import 'package:led_strip_controller/feature/home_screen/widget/bluetooth_dialog.dart';
import 'package:led_strip_controller/feature/home_screen/widget/effect_card.dart';
import 'package:led_strip_controller/feature/home_screen/light_mode.dart';
import 'package:led_strip_controller/util/memory.dart';
import 'package:led_strip_controller/util/serial_controller.dart';
import 'package:flutter/material.dart';
import 'package:led_strip_controller/resource/text_styles.dart';
import 'package:led_strip_controller/util/strip_settings.dart';
import 'package:permission_handler/permission_handler.dart';

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
  late SerialController _serialController;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    var controllerType = Memory().getPrimaryController() ?? Memory().getLastController() ?? SerialControllers.usb;
    _serialController = SerialController.choose(controllerType);
    _serialController.connect();
    _serialController.isConnected.addListener(_backToDefaultMode);
  }

  @override
  void dispose() {
    _serialController.disconnect();
    _serialController.isConnected.removeListener(_backToDefaultMode);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _serialController.isConnected,
      builder: (BuildContext context, bool isConnected, __) {
        return ScaffoldMessenger(
          child: Scaffold(
            key: _scaffoldKey,
            appBar: AppBar(
              title: Text('LED Strip Controller', style: TextStyles.appBar),
              actions: [
                InkWell(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Icon(
                      Icons.bluetooth,
                      color: (isConnected && _serialController is BluetoothController) ? Colors.green : Colors.red
                    ),
                  ),
                  onTap: _toggleBluetooth,
                  onDoubleTap: () => _setPrimaryController(SerialControllers.bluetooth),
                  onTapCancel: _removePrimaryController,
                ),
                InkWell(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Icon(
                      Icons.usb,
                      color: (isConnected && _serialController is UsbController) ? Colors.green : Colors.red
                    ),
                  ),
                  onTap: _toggleUsb,
                  onDoubleTap: () => _setPrimaryController(SerialControllers.usb),
                  onTapCancel: _removePrimaryController,
                ),
              ],
            ),
            body: Scrollbar(
              thickness: 3,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(left: 12, right: 12, bottom: 0, top: 24),
                  child: Column(
                    children: [
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('LED Strip', style: TextStyles.regular),
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
                              const Text('Brightness', style: TextStyles.regular),
                              Text('$_brightness/255', style: TextStyles.regular),
                            ],
                          ),
                          Slider(
                            min: 0, max: 255,
                            value: _brightness.toDouble(),
                            onChanged: isConnected ? _changeBrightness : null,
                            onChangeEnd: isConnected ? (value) => _serialController.changeBrightness(value.toInt()) : null,
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
                              const Text('Change period', style: TextStyles.regular),
                              Text('$_changePeriodSeconds seconds', style: TextStyles.regular),
                            ],
                          ),
                          Slider(
                            min: 0, max: 600,
                            value: _changePeriodSeconds.toDouble(),
                            onChanged: isConnected ? (value) => setState(() => _changePeriodSeconds = value.toInt()) : null,
                            onChangeEnd: isConnected ? (value) => _serialController.changePeriod(value.toInt()) : null,
                            activeColor: Colors.red,
                            inactiveColor: Color(0xFF484848),
                          ),
                        ],
                      ),
                      const Divider(),
                      const Padding(
                        padding: EdgeInsets.all(8),
                        child: Text('Modes', style: TextStyles.header),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Automatic Switch', style: TextStyles.regular),
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
                          const Text('Static Effects', style: TextStyles.regular),
                          Switch(
                            value: _staticEffects,
                            onChanged: isConnected ? _toggleStaticEffects : null,
                            inactiveTrackColor: Color(0xFF484848),
                            inactiveThumbColor: Color(0xFF646464),
                          ),
                        ],
                      ),
                      GridView.builder(
                        padding: const EdgeInsets.only(bottom: 24),
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
    if (!_serialController.isConnected.value) await _serialController.connect();
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

  void _toggleBluetooth() async {
    await Permission.bluetoothScan.request();
    await Permission.bluetoothConnect.request();
    String? mac = Memory().getLastBluetoothMac();
    if (mac == null) {
      mac = await showDialog(
        context: context,
        barrierColor: Colors.black.withOpacity(0.75),
        builder: (context) {
          return const BluetoothDialog();
        }
      );
      if (mac != null) {
        Memory().setLastBluetoothMac(mac);
      } else {
        _showSnackBar('Bluetooth device was not selected');
        return;
      }
    }
    if (_serialController is BluetoothController) {
      _showSnackBar('Bluetooth ${_serialController.isConnected.value ? 'dis' : ''}connected');
      _serialController.toggleConnection();
    } else {
      if (_serialController.isConnected.value) _showSnackBar('USB disconnected');
      _serialController.disconnect();
      _serialController.isConnected.removeListener(_backToDefaultMode);
      _serialController = SerialController.choose(SerialControllers.bluetooth);
      _serialController.isConnected.addListener(_backToDefaultMode);
      await _serialController.connect();
      _showSnackBar('Bluetooth connected');
    }
  }

  void _toggleUsb() async {
    if (_serialController is UsbController) {
      _showSnackBar('USB ${_serialController.isConnected.value ? 'dis' : ''}connected');
      _serialController.toggleConnection();
    } else {
      if (_serialController.isConnected.value) _showSnackBar('Bluetooth disconnected');
      _serialController.disconnect();
      _serialController.isConnected.removeListener(_backToDefaultMode);
      _serialController = SerialController.choose(SerialControllers.usb);
      _serialController.isConnected.addListener(_backToDefaultMode);
      await _serialController.connect();
      _showSnackBar('USB connected');
    }
  }

  void _backToDefaultMode() {
    if (!_serialController.isConnected.value) _currentMode = LightMode.rainbowWave;
  }

  void _setPrimaryController(SerialControllers controller) {
    var currentPrimaryController = Memory().getPrimaryController();
    if (controller != currentPrimaryController) {
      Memory().setPrimaryController(controller);
      _showSnackBar('Set ${controller == SerialControllers.usb ? 'USB' : 'Bluetooth'} as primary controller');
    } else {
      _showSnackBar('${controller == SerialControllers.usb ? 'USB' : 'Bluetooth'} is already a primary controller');
    }
  }

  void _removePrimaryController() {
    if (Memory().getPrimaryController() != null) {
      Memory().removePrimaryController();
      _showSnackBar('Removed primary controller');
    } else {
      _showSnackBar('There already is no primary controller');
    }
  }

  void _showSnackBar(String message) {
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
