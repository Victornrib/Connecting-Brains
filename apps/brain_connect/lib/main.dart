import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:brain_connect/src/views/participant/home_screen.dart';
import 'package:brain_connect/src/models/device_state.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => DeviceState())],
      child: const BrainConnect(),
    ),
  );
}

class BrainConnect extends StatelessWidget {
  const BrainConnect({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const ParticipantHomeScreen(),
    );
  }
}
