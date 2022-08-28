import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:led_strip_controller/resource/text_styles.dart';

class BluetoothDialog extends StatelessWidget {
  const BluetoothDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 15,
      backgroundColor: Colors.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 8),
            child: Text('Bluetooth Connection', style: TextStyles.header),
          ),
          const Divider(),
          const _BluetoothDataArea(),
          const Divider(),
          Padding(
            padding: const EdgeInsets.only(left: 12, right: 12, bottom: 8),
            child: InkWell(
              child: const SizedBox(
                child: Center(child: Text('Back', style: TextStyles.subHeader)),
                width: double.infinity,
                height: 48,
              ),
              borderRadius: BorderRadius.circular(8),
              onTap: Navigator.of(context).pop,
            ),
          ),
        ],
      ),
    );
  }
}

class _BluetoothDataArea extends StatefulWidget {
  const _BluetoothDataArea({Key? key}) : super(key: key);

  @override
  State<_BluetoothDataArea> createState() => _BluetoothDataAreaState();
}

class _BluetoothDataAreaState extends State<_BluetoothDataArea> {
  List<BluetoothDiscoveryResult> _devices = [];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: Center(
        child: StreamBuilder(
          stream: FlutterBluetoothSerial.instance.startDiscovery(),
          builder: (_, AsyncSnapshot<BluetoothDiscoveryResult> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator(color: Colors.red);
            } else if (snapshot.connectionState == ConnectionState.active ||
                snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return const Text('Error while scanning Bluetooth devices', style: TextStyles.regular);
              } else if (snapshot.hasData) {
                if (!_devices.any((device) => device.device.address == snapshot.data!.device.address)) _devices.add(snapshot.data!);
                return Scrollbar(
                  thickness: 3,
                  child: ListView.separated(
                    itemBuilder: (_, index) {
                      var device = _devices[index].device;
                      return _BluetoothDeviceTile(
                        device: device,
                        onTap: () => Navigator.of(context).pop(device.address),
                      );
                    },
                    separatorBuilder: (_, __) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Divider(),
                      );
                    },
                    itemCount: _devices.length,
                  ),
                );
              } else {
                return const Text('No Bluetooth devices found', style: TextStyles.regular);
              }
            } else {
              return const Offstage();
            }
          },
        ),
      ),
    );
  }
}

class _BluetoothDeviceTile extends StatelessWidget {
  const _BluetoothDeviceTile({Key? key, required this.device, required this.onTap}) : super(key: key);

  final BluetoothDevice device;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(device.name ?? 'No Name', style: TextStyles.header),
            const SizedBox(height: 4),
            Text(device.address, style: TextStyles.subHeader),
          ],
        ),
      ),
    );
  }
}
