import 'package:flutter/material.dart';

class LogoHeading extends StatelessWidget {
  const LogoHeading({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          'assets/images/logo.png',
          width: 120,
          height: 120,
        ),
        const Text(
          'CallWatcher',
          style: TextStyle(
              fontSize: 36, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        const Text(
          'Watch and track calls of your every Employee',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.normal,
            color: Colors.black,
          ),
        )
      ],
    );
  }
}
