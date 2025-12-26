import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:brain_connect/src/services/bluetooth_service.dart';

class DeviceState extends ChangeNotifier {
  String? _deviceName;
  BluetoothDevice? _connectedDevice;
  final AppBluetoothService _bluetoothService = AppBluetoothService();

  String get deviceName => _deviceName ?? '';
  BluetoothDevice? get connectedDevice => _connectedDevice;
  bool get isConnected => _connectedDevice != null;

  void setDevice(BluetoothDevice device) {
    _connectedDevice = device;
    _deviceName = device.name.isNotEmpty ? device.name : 'Unknown Device';
    notifyListeners();
  }

  Future<void> disconnectDevice() async {
    if (_connectedDevice != null) {
      await _bluetoothService.disconnectDevice(_connectedDevice!);
      _connectedDevice = null;
      _deviceName = null;
      notifyListeners();
    }
  }

  void clearDevice() {
    _connectedDevice = null;
    _deviceName = null;
    notifyListeners();
  }
}
