import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class PairDeviceScreen extends StatefulWidget {
  const PairDeviceScreen({super.key});

  @override
  State<PairDeviceScreen> createState() => _PairDeviceScreenState();
}

class _PairDeviceScreenState extends State<PairDeviceScreen> {
  List<ScanResult> scanResults = [];
  bool isScanning = false;

  @override
  void initState() {
    super.initState();
    initBluetooth();
  }

  // ---------- PERMISSIONS ----------
  Future<bool> requestBluetoothPermissions() async {
    final scan = await Permission.bluetoothScan.request();
    final connect = await Permission.bluetoothConnect.request();
    final location = await Permission.locationWhenInUse.request();

    return scan.isGranted && connect.isGranted && location.isGranted;
  }

  // ---------- INIT ----------
  Future<void> initBluetooth() async {
    final hasPermission = await requestBluetoothPermissions();
    if (!hasPermission) return;

    final adapterState = await FlutterBluePlus.adapterState.first;
    if (adapterState != BluetoothAdapterState.on) {
      await FlutterBluePlus.turnOn();
    }

    startScan();
  }

  // ---------- SCAN ----------
  void startScan() async {
    setState(() {
      scanResults.clear();
      isScanning = true;
    });

    await FlutterBluePlus.startScan(timeout: const Duration(seconds: 6));

    FlutterBluePlus.scanResults.listen((results) {
      setState(() {
        scanResults = results;
        isScanning = false;
      });
    });
  }

  @override
  void dispose() {
    FlutterBluePlus.stopScan();
    super.dispose();
  }

  // ---------- UI ----------
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color.fromRGBO(128, 116, 116, 1),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.03,
            vertical: screenHeight * 0.02,
          ),
          child: Column(
            children: [
              const Spacer(flex: 1),

              // TITLE + REFRESH
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Pair Device',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 12),
                  IconButton(
                    icon: const Icon(Icons.refresh, color: Colors.white),
                    onPressed: startScan,
                  ),
                ],
              ),

              const Spacer(flex: 2),

              // DEVICE LIST AREA
              SizedBox(
                height: screenHeight * 0.4,
                child: Center(
                  child: Container(
                    width: screenWidth * 0.9,
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.03,
                      vertical: screenHeight * 0.02,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFC3C3C3),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child:
                        isScanning && scanResults.isEmpty
                            ? const Center(child: CircularProgressIndicator())
                            : ListView.separated(
                              itemCount: scanResults.length,
                              separatorBuilder:
                                  (_, __) =>
                                      SizedBox(height: screenHeight * 0.02),
                              itemBuilder: (context, index) {
                                final result = scanResults[index];
                                final device = result.device;

                                return SizedBox(
                                  width: double.infinity,
                                  height: screenHeight * 0.07,
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      try {
                                        await device.connect();
                                        debugPrint(
                                          'Connected to ${device.name}',
                                        );
                                      } catch (_) {}
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                      shape: RoundedRectangleBorder(
                                        side: const BorderSide(
                                          color: Colors.black,
                                          width: 2,
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: Text(
                                      device.name.isNotEmpty
                                          ? device.name
                                          : 'Unknown device',
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                  ),
                ),
              ),

              const Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }
}
