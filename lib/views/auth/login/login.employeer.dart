import 'package:call_watcher/core/widgets/logo/logo_heading.dart';
import 'package:flutter/material.dart';

class LoginEmployeePage extends StatelessWidget {
  const LoginEmployeePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
      alignment: Alignment.center,
      height: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 60.0),
            const LogoHeading(),
            const SizedBox(height: 24.0),
          ],
        ),
      ),
    ));
  }
}
