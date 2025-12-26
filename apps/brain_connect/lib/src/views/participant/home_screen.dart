import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:brain_connect/src/views/participant/pair_device.dart';
import 'package:brain_connect/src/widgets/buttons.dart';
import 'package:brain_connect/src/providers/device_state.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class ParticipantHomeScreen extends StatelessWidget {
  const ParticipantHomeScreen({super.key});

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
            vertical: screenHeight * 0.01,
          ),
          child: Column(
            children: [
              // TOP RIGHT HEADER
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: EdgeInsets.only(
                    top: screenHeight * 0.01,
                    right: screenWidth * 0.02,
                  ),
                  child: Consumer<DeviceState>(
                    builder: (context, deviceState, _) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Welcome, User',
                                style: TextStyle(
                                  fontSize: screenWidth * 0.07,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: screenWidth * 0.02),
                              GestureDetector(
                                onTap: () => print('User settings screen'),
                                child: Image.asset(
                                  'assets/images/user.png',
                                  width: screenWidth * 0.1,
                                  height: screenWidth * 0.1,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: screenHeight * 0.01),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                deviceState.deviceName,
                                style: TextStyle(
                                  fontSize: screenWidth * 0.045,
                                  color: Colors.grey[400],
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: screenWidth * 0.02),
                              Image.asset(
                                deviceState.isConnected
                                    ? 'assets/images/connected.png'
                                    : 'assets/images/disconnected.png',
                                width: screenWidth * 0.06,
                                height: screenWidth * 0.06,
                              ),
                              SizedBox(width: screenWidth * 0.02),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),

              const Spacer(flex: 2),

              // LOGO
              LayoutBuilder(
                builder: (context, constraints) {
                  final logoWidth = constraints.maxWidth * 0.8;
                  return ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: logoWidth),
                    child: Image.asset(
                      'assets/images/logo.png',
                      fit: BoxFit.contain,
                    ),
                  );
                },
              ),

              const Spacer(flex: 2),

              // BUTTONS
              Consumer<DeviceState>(
                builder: (context, deviceState, _) {
                  return Column(
                    children: [
                      customButton(
                        context: context,
                        text: 'Join Experiment',
                        onPressed: () {},
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      customButton(
                        context: context,
                        text:
                            deviceState.isConnected
                                ? 'Disconnect Device'
                                : 'Pair Device',
                        textColor: deviceState.isConnected ? Colors.red : null,
                        onPressed: () async {
                          if (deviceState.isConnected) {
                            deviceState.disconnectDevice();
                          } else {
                            final BluetoothDevice? device =
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const PairDeviceScreen(),
                                  ),
                                );

                            if (device != null) {
                              deviceState.setDevice(device);
                            }
                          }
                        },
                      ),
                    ],
                  );
                },
              ),

              const Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }
}
