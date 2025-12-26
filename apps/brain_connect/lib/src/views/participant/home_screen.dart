import 'package:flutter/material.dart';
import 'package:brain_connect/src/views/participant/pair_device.dart';
import 'package:brain_connect/src/widgets/buttons.dart';

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
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // TOP RIGHT HEADER
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: EdgeInsets.only(
                    top: screenHeight * 0.01,
                    right: screenWidth * 0.02,
                  ),
                  child: Column(
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
                            onTap: () {
                              // RODO: Create user settings screen
                              print('User settings screen');
                            },
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
                            'No device connected',
                            style: TextStyle(
                              fontSize: screenWidth * 0.045,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: screenWidth * 0.02),
                          Image.asset(
                            'assets/images/disconnected.png',
                            width: screenWidth * 0.06,
                            height: screenWidth * 0.06,
                          ),
                          SizedBox(width: screenWidth * 0.02),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // SPACE BETWEEN HEADER AND LOGO
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

              // SPACE BETWEEN LOGO AND BUTTONS
              const Spacer(flex: 2),

              // BUTTONS
              Column(
                children: [
                  customButton(
                    context: context,
                    text: 'Join Experiment',
                    onPressed: () {},
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  customButton(
                    context: context,
                    text: 'Pair Device',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PairDeviceScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),

              // SPACE BELOW BUTTONS
              const Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }
}
