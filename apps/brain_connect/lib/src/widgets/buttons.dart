import 'package:flutter/material.dart';

// Function that returns a shared ElevatedButton
ElevatedButton customButton({
  required BuildContext context,
  required String text,
  required VoidCallback onPressed,
}) {
  final screenWidth = MediaQuery.of(context).size.width;
  final screenHeight = MediaQuery.of(context).size.height;

  final ButtonStyle sharedButtonStyle = ElevatedButton.styleFrom(
    fixedSize: Size(screenWidth * 0.8, screenHeight * 0.07),
    padding: EdgeInsets.symmetric(
      vertical: screenHeight * 0.01,
      horizontal: screenWidth * 0.05,
    ),
    backgroundColor: const Color.fromRGBO(38, 71, 51, 1),
    shape: const RoundedRectangleBorder(
      side: BorderSide(color: Colors.black, width: 2),
      borderRadius: BorderRadius.all(Radius.circular(15)),
    ),
  );

  return ElevatedButton(
    onPressed: onPressed,
    style: sharedButtonStyle,
    child: Text(
      text,
      style: const TextStyle(
        fontSize: 22,
        fontFamily: 'Inter',
        fontWeight: FontWeight.bold,
        color: Color.fromRGBO(16, 164, 55, 1),
      ),
    ),
  );
}
