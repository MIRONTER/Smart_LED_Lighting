import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:led_bottom_lighting_controller/utils/bt_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:led_bottom_lighting_controller/presentation/text_styles.dart';
import 'package:led_bottom_lighting_controller/utils/controller_data.dart';
import 'package:led_bottom_lighting_controller/utils/strip_settings.dart';

bool ledStripOn = true;
bool autoSwitch = false;
bool isConnected = false;
int brightness = 127;
int brightnessBackup = 0;
int changePeriod = 90;
String currentModeName = 'Spinning Rainbow';
String lastModeUsed = '';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  void initState() {
    super.initState();
    BluetoothConnection.toAddress(CONTROLLER_MAC).then((_connection) {
      connection = _connection;
      setState(() {
        isConnected = true;
      });
    });
  }

  @override
  void dispose() {
    isConnected = false;
    connection.dispose();
    connection = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text('Main Menu', style: appBar),
      actions: [
        IconButton(
          icon: Icon(
            Icons.bluetooth,
            color: isConnected ? Colors.green : Colors.red),
          onPressed: (){
            if (!isConnected) {
              BluetoothConnection.toAddress(CONTROLLER_MAC).then((_connection) {
                connection = _connection;
                setState(() {
                  isConnected = true;
                });
              });
            } else {
              isConnected = false;
              connection.dispose();
              connection = null;
            }
            setState(() {});
          }),
      ],
    ),
    body: Scrollbar(
      thickness: 3,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Divider(),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('LED Bottom Lighting', style: usual),
                  Switch(
                    value: ledStripOn,
                    onChanged: (value) {
                      if (isConnected) {
                        if (value) {
                          setState(() {
                            brightness = brightnessBackup;
                            ledStripOn = value;
                          });
                          changeBrightness(brightness.toDouble());
                        } else {
                          setState(() {
                            brightnessBackup = brightness;
                            brightness = 0;
                            ledStripOn = value;
                          });
                          changeBrightness(brightness.toDouble());
                        }
                      }
                    },
                    inactiveTrackColor: Color(0xFF484848),
                    inactiveThumbColor: Color(0xFF646464),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Text('Brightness', style: usual),
                      Text('$brightness/255', style: usual),
                    ],
                  ),
                  Slider(
                    min: 0, max: 255,
                    value: brightness.toDouble(),
                    onChanged: (value) {
                      if (isConnected) {
                        setState(() {
                          brightness = value.toInt();
                          if (brightness == 0) {
                            ledStripOn = false;
                          } else {
                            ledStripOn = true;
                          }
                        });
                      }
                    },
                    onChangeEnd: (value) => isConnected ? changeBrightness(value) : null,
                    activeColor: Colors.red,
                    inactiveColor: Color(0xFF484848),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Text('Change period', style: usual),
                      Text('$changePeriod seconds', style: usual),
                    ],
                  ),
                  Slider(
                    min: 0, max: 180,
                    value: changePeriod.toDouble(),
                    onChanged: (value) => isConnected ? setState(() => changePeriod = value.toInt()) : null,
                    onChangeEnd: (value) => isConnected ? changeChangePeriod(value) : null,
                    activeColor: Colors.red,
                    inactiveColor: Color(0xFF484848),
                  ),
                ],
              ),
              Divider(),
              Padding(
                padding: EdgeInsets.all(8),
                child: Text('Modes', style: header),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Autoswitch', style: usual),
                  Switch(
                    value: autoSwitch,
                    onChanged: (value) {
                      if (isConnected) {
                        setState(() {
                          autoSwitch = value;
                          if (value) {
                            lastModeUsed = currentModeName;
                            currentModeName = 'Automatic';
                            sendCommand('A');
                          } else {
                            currentModeName = lastModeUsed;
                          }
                        });
                      }
                    },
                    inactiveTrackColor: Color(0xFF484848),
                    inactiveThumbColor: Color(0xFF646464),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.all(8),
                child: Text('Rainbow', style: subHeader),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  EffectCard(parent: this, modeName: 'Rainbow Fade'),
                  EffectCard(parent: this, modeName: 'Spinning Rainbow')
                ],
              ),
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.all(8),
                child: Text('Random Stuff', style: subHeader),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  EffectCard(parent: this, modeName: 'Random Pixels (All LEDs)'),
                  EffectCard(parent: this, modeName: 'Random Pixels (Some LEDs)')
                ],
              ),
              SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  EffectCard(parent: this, modeName: 'Random Strip'),
                  SizedBox(height: 108, width: 120)
                ],
              ),
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.all(8),
                child: Text('Spinning Colors', style: subHeader),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  EffectCard(parent: this, modeName: 'Two Colors Spinning'),
                  EffectCard(parent: this, modeName: 'Three Colors Spinning')
                ],
              ),
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.all(8),
                child: Text('Pulse', style: subHeader),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  EffectCard(parent: this, modeName: 'Color Brightness Pulse'),
                  EffectCard(parent: this, modeName: 'Color Saturation Pulse')
                ],
              ),
              SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  EffectCard(parent: this, modeName: 'Two Overlaps'),
                  EffectCard(parent: this, modeName: 'Segmented Pulse')
                ],
              ),
              SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  EffectCard(parent: this, modeName: 'Color Wipe'),
                  EffectCard(parent: this, modeName: 'Color Multipulse')
                ],
              ),
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.all(8),
                child: Text('Static Colors', style: subHeader),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  EffectCard(parent: this, modeName: 'Static Red'),
                  EffectCard(parent: this, modeName: 'Static Green')
                ],
              ),
              SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  EffectCard(parent: this, modeName: 'Static Blue'),
                  EffectCard(parent: this, modeName: 'Static Lime')
                ],
              ),
              SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  EffectCard(parent: this, modeName: 'Static Aqua'),
                  EffectCard(parent: this, modeName: 'Static Purple')
                ],
              ),
              SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  EffectCard(parent: this, modeName: 'Static Pink'),
                  EffectCard(parent: this, modeName: 'Static Yellow')
                ],
              ),
              SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  EffectCard(parent: this, modeName: 'Static White'),
                  SizedBox(height: 108, width: 120),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

class EffectCard extends StatefulWidget {
  final String modeName;
  final _HomeScreenState parent;

  EffectCard({@required this.parent, @required this.modeName});
  @override
  _EffectCardState createState() => _EffectCardState();
}

class _EffectCardState extends State<EffectCard> {
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: () => isConnected ? widget.parent.setState(() {
      switchMode(widget.modeName);
      autoSwitch = false;
    }) : null,
    child: Card(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      elevation: 15,
      shadowColor: Colors.red,
      color: Colors.black,
      child: Container(
        height: 108, width: 120,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Image.asset('assets/images/'+widget.modeName.toLowerCase().replaceAll(' ', '_').replaceAll('(', '').replaceAll(')', '')+'.gif'),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Visibility(
                  child: Icon(Icons.done, color: Colors.green, size: 50),
                  visible: currentModeName == widget.modeName
                ),
                Flexible(
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Text(
                      widget.modeName,
                      textAlign: TextAlign.center,
                      style: currentModeName == widget.modeName ? modeNameEnabled : modeNameDisabled
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    ),
  );
}
