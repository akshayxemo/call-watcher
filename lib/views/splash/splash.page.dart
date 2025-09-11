import 'package:call_watcher_demo/core/widgets/logo/logo_heading.animated.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  @override
  void initState() {
    super.initState();
    navigateToNext();
  }


  Future<void> navigateToNext() async {
    await Future.delayed(const Duration(seconds: 3));
    if (mounted) {
      // Navigate to the next page, e.g., login or home
      // For example: context.go('/login');
      context.go('/auth');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          color: Colors.white,
          alignment: Alignment.center,
          padding: const EdgeInsets.all(16.0),
          child: const Center(
            child: LogoHeadingAnimated()
          ),
        ),
    );
  }
}
