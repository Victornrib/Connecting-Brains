import 'package:flutter/material.dart';
import 'src/views/participant/home_screen.dart';

void main() {
  runApp(BrainConnect());
}

class BrainConnect extends StatelessWidget {
  const BrainConnect({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: ParticipantHomeScreen());
  }
}
