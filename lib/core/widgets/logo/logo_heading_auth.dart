import 'package:flutter/material.dart';

class LogoHeadingAuth extends StatelessWidget {
  const LogoHeadingAuth({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          'assets/images/logo.png',
          width: 24,
          height: 24,
        ),
        const SizedBox(width: 10),
        const Text(
          'CallWatcher',
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ],
    );
  }
}
