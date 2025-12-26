import 'package:flutter/material.dart';

class PairDeviceScreen extends StatelessWidget {
  const PairDeviceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Example list of devices
    final List<String> devices = [
      'Device #1',
      'Device #2',
      'Device #3',
      'Device #4',
      'Device #5',
    ];

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
              Spacer(flex: 1),

              // TITLE
              Text(
                'Pair Device',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),

              // SPACE BETWEEN TITLE AND DEVICE LIST
              Spacer(flex: 2),

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
                    child: ListView.separated(
                      itemCount: devices.length,
                      separatorBuilder:
                          (_, __) => SizedBox(height: screenHeight * 0.02),
                      itemBuilder: (context, index) {
                        return SizedBox(
                          width: double.infinity,
                          height: screenHeight * 0.07,
                          child: ElevatedButton(
                            onPressed: () {
                              print('Selected ${devices[index]}');
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
                              devices[index],
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

              // SPACE BELOW LIST
              Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }
}
