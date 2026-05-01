
import 'package:fit_flow/core/di/service_locator.dart';
import 'package:fit_flow/core/router/app_router.dart';
import 'package:flutter/material.dart';

class FitFlowApp extends StatelessWidget {
  const FitFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF2F6CF6),
      brightness: Brightness.light,
    );

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'FitFlow',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: colorScheme,
        scaffoldBackgroundColor: const Color(0xFFF6F8FC),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
        ),
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
        fontFamily: 'Roboto',
      ),
      routerConfig: getIt<AppRouter>().router,
    );
  }
}