import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class LogoHeadingAnimated extends StatelessWidget {
  const LogoHeadingAnimated({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          'assets/images/logo.png',
          width: 120,
          height: 120,
        ).animate().fadeIn(duration: 800.ms).scale(
            begin: const Offset(0.8, 0.8),
            end: const Offset(1.0, 1.0),
            duration: 800.ms,
            curve: Curves.easeOut),
        const Text(
          'CallWatcher',
          style: TextStyle(
              fontSize: 36, fontWeight: FontWeight.bold, color: Colors.black),
        ).animate().fadeIn(duration: 800.ms).slideY(
            begin: 0.5, end: 0, duration: 800.ms, curve: Curves.easeOut),
        const Text(
          'Watch and track calls of your every Employee',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.normal,
            color: Colors.black,
          ),
        ).animate().fadeIn(duration: 800.ms).slideY(
            begin: 0.5,
            end: 0,
            duration: 800.ms,
            delay: 200.ms,
            curve: Curves.easeOut),
      ],
    );
  }
}
