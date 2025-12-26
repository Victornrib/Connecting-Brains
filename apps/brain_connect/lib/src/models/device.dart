import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class Device {
  final String name;
  final String id;
  final BluetoothDevice bluetoothDevice;

  Device({required this.name, required this.id, required this.bluetoothDevice});
}
