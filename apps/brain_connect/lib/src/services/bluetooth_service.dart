import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import '../models/device.dart';

class AppBluetoothService {
  Future<bool> requestPermissions() async {
    final scan = await Permission.bluetoothScan.request();
    final connect = await Permission.bluetoothConnect.request();
    final location = await Permission.locationWhenInUse.request();

    return scan.isGranted && connect.isGranted && location.isGranted;
  }

  Future<void> ensureAdapterOn() async {
    final state = await FlutterBluePlus.adapterState.first;
    if (state != BluetoothAdapterState.on) {
      await FlutterBluePlus.turnOn();
    }
  }

  Stream<List<ScanResult>> scan({
    Duration timeout = const Duration(seconds: 6),
  }) {
    FlutterBluePlus.startScan(timeout: timeout);
    return FlutterBluePlus.scanResults;
  }

  Future<void> connectDevice(BluetoothDevice device) async {
    await device.connect(
      timeout: const Duration(seconds: 10),
      autoConnect: false,
    );
  }

  Future<void> disconnectDevice(BluetoothDevice device) async {
    await device.disconnect();
  }
}
