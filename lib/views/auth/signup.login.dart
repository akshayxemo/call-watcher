import 'package:call_watcher_demo/core/widgets/logo/logo_heading.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SignUpLoginPage extends StatelessWidget {
  const SignUpLoginPage({super.key});

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
            Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Handle Sign Up action
                    context.go('/home/employee');
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50), // Full width
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Employee Sign In',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    // Handle Sign Up action
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50), // Full width
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    elevation: 0,
                  ),
                  child: const Text(
                    'Admin Sign In',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                const SizedBox(height: 30.0),
                const Text(
                  "Don't have an account?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 16.0),
                OutlinedButton(
                  onPressed: () {
                    // Handle Login action
                  },
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50), // Full width
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                    side: const BorderSide(color: Colors.blue, width: 2),
                  ),
                  child: const Text(
                    'Register Here',
                    style: TextStyle(fontSize: 18, color: Colors.blue),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ));
  }
}
