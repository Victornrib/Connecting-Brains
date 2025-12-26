import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:brain_connect/src/services/bluetooth_service.dart';

class PairDeviceScreen extends StatefulWidget {
  const PairDeviceScreen({super.key});

  @override
  State<PairDeviceScreen> createState() => _PairDeviceScreenState();
}

class _PairDeviceScreenState extends State<PairDeviceScreen> {
  final AppBluetoothService _bluetoothService = AppBluetoothService();
  List<ScanResult> scanResults = [];
  bool isScanning = false;
  bool isConnecting = false;
  String connectingDeviceId = '';

  @override
  void initState() {
    super.initState();
    initBluetooth();
  }

  Future<void> initBluetooth() async {
    final hasPermission = await _bluetoothService.requestPermissions();
    if (!hasPermission) return;
    await _bluetoothService.ensureAdapterOn();
    startScan();
  }

  void startScan() async {
    setState(() {
      scanResults.clear();
      isScanning = true;
    });

    _bluetoothService.scan().listen((results) {
      if (!mounted) return;
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
                                final isThisConnecting =
                                    isConnecting &&
                                    connectingDeviceId == device.id.id;

                                return SizedBox(
                                  width: double.infinity,
                                  height: screenHeight * 0.07,
                                  child: ElevatedButton(
                                    onPressed:
                                        isThisConnecting
                                            ? null
                                            : () async {
                                              setState(() {
                                                isConnecting = true;
                                                connectingDeviceId =
                                                    device.id.id;
                                              });

                                              try {
                                                await _bluetoothService
                                                    .connectDevice(device);
                                                if (!mounted) return;

                                                // Close dialog first, then pop with result safely
                                                await showDialog(
                                                  context: context,
                                                  barrierDismissible: false,
                                                  builder:
                                                      (_) => AlertDialog(
                                                        title: const Text(
                                                          'Device Connected',
                                                        ),
                                                        content: Text(
                                                          device.name.isNotEmpty
                                                              ? device.name
                                                              : 'Unknown device',
                                                        ),
                                                        actions: [
                                                          TextButton(
                                                            onPressed: () {
                                                              Navigator.of(
                                                                context,
                                                              ).pop(); // close dialog
                                                            },
                                                            child: const Text(
                                                              'OK',
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                );

                                                // Use microtask to ensure navigator transition finished
                                                Future.microtask(() {
                                                  if (mounted) {
                                                    Navigator.pop(
                                                      context,
                                                      device,
                                                    ); // return device
                                                  }
                                                });
                                              } catch (e) {
                                                if (!mounted) return;
                                                ScaffoldMessenger.of(
                                                  context,
                                                ).showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                      'Failed to connect: $e',
                                                    ),
                                                  ),
                                                );
                                              } finally {
                                                setState(() {
                                                  isConnecting = false;
                                                  connectingDeviceId = '';
                                                });
                                              }
                                            },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          isThisConnecting
                                              ? Colors.grey
                                              : Colors.green,
                                      shape: RoundedRectangleBorder(
                                        side: const BorderSide(
                                          color: Colors.black,
                                          width: 2,
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child:
                                        isThisConnecting
                                            ? const Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                SizedBox(
                                                  width: 16,
                                                  height: 16,
                                                  child:
                                                      CircularProgressIndicator(
                                                        strokeWidth: 2,
                                                        color: Colors.black,
                                                      ),
                                                ),
                                                SizedBox(width: 8),
                                                Text(
                                                  'Connecting...',
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ],
                                            )
                                            : Text(
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
