import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../di/service_locator.dart';
import '../../features/home/ui/logic/home_cubit.dart';
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
        builder: (context, state) => BlocProvider(
          create: (context) => getIt<HomeCubit>()..load(),
          child: const HomeScreen(),
        ),
      ),
    ],
  );
}
