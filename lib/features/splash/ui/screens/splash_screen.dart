import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/services/user_selection_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigate();
  }

  Future<void> _navigate() async {
    // Show splash for at least 2 seconds.
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    final selection = getIt<UserSelectionService>();
    if (selection.hasSelection) {
      context.go('/home');
    } else {
      context.go('/onboarding');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF2F6CF6), Color(0xFF255BDB)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/logo.png', width: 120, height: 120),
                const SizedBox(height: 28),
                const Text(
                  'FitFlow',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 42,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -1.2,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Elevate your movement',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.72),
                    fontSize: 14,
                    letterSpacing: 2.8,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
