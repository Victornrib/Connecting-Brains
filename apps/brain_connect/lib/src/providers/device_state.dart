import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class DeviceState extends ChangeNotifier {
  BluetoothDevice? _device;

  BluetoothDevice? get device => _device;

  String get deviceName => _device?.name ?? 'No device connected';

  bool get isConnected => _device != null;

  void setDevice(BluetoothDevice device) {
    _device = device;
    notifyListeners();
  }

  void disconnectDevice() {
    _device = null;
    notifyListeners();
  }
}
