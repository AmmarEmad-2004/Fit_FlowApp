import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../di/service_locator.dart';
import '../../features/home/ui/logic/home_controller.dart';
import '../../features/home/ui/screens/home_screen.dart';
import '../../features/onboarding/ui/logic/onboarding_cubit.dart';
import '../../features/onboarding/ui/screens/onboarding_screen.dart';
import '../../features/splash/ui/screens/splash_screen.dart';

class AppRouter {
  AppRouter();

  late final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => BlocProvider(
          create: (context) => getIt<OnboardingCubit>()..load(),
          child: const OnboardingScreen(),
        ),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => ChangeNotifierProvider(
          create: (context) => getIt<HomeController>()..load(),
          child: const HomeScreen(),
        ),
      ),
    ],
  );
}
