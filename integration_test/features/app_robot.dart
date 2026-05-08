import 'package:fit_flow/core/di/service_locator.dart';
import 'package:fit_flow/core/router/app_router.dart';
import 'package:fit_flow/core/services/program_service.dart';
import 'package:fit_flow/core/services/user_selection_service.dart';
import 'package:fit_flow/features/home/data/repos/home_repo.dart';
import 'package:fit_flow/features/home/data/repos/home_repo_impl.dart';
import 'package:fit_flow/features/home/data/services/home_service.dart';
import 'package:fit_flow/features/home/ui/logic/home_cubit.dart';
import 'package:fit_flow/features/onboarding/data/repos/onboarding_repo.dart';
import 'package:fit_flow/features/onboarding/data/repos/onboarding_repo_impl.dart';
import 'package:fit_flow/features/onboarding/data/services/onboarding_service.dart';
import 'package:fit_flow/features/onboarding/ui/logic/onboarding_cubit.dart';
import 'package:fit_flow/fit_flow_app.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockProgramService extends Mock implements ProgramService {}

class AppRobot {
  AppRobot(this.tester);

  final WidgetTester tester;

  static Future<void> registerTestDependencies() async {
    final programService = MockProgramService();
    when(
      () => programService.fetchProgram(
        any(),
        any(),
        forceRefresh: any(named: 'forceRefresh'),
      ),
    ).thenAnswer(
      (_) async => {
        'programType': 'muscle',
        'daysPerWeek': 3,
        'days': {
          'day_0': {
            'day': 'Day 1',
            'time': 45,
            'exercises': [
              {'name': 'Push Ups', 'targetArea': 'Chest', 'reps': '12'},
            ],
          },
          'day_1': {
            'day': 'Day 2',
            'time': 50,
            'exercises': [
              {'name': 'Squats', 'targetArea': 'Legs', 'reps': '10'},
            ],
          },
        },
      },
    );

    await getIt.reset();
    getIt.registerLazySingleton<ProgramService>(() => programService);
    getIt.registerLazySingleton<UserSelectionService>(UserSelectionService.new);

    getIt.registerLazySingleton<OnboardingService>(OnboardingService.new);
    getIt.registerLazySingleton<OnboardingRepo>(
      () => OnboardingRepoImpl(getIt<OnboardingService>()),
    );
    getIt.registerFactory<OnboardingCubit>(
      () => OnboardingCubit(
        getIt<OnboardingRepo>(),
        getIt<UserSelectionService>(),
      ),
    );

    getIt.registerLazySingleton<HomeService>(
      () => HomeService(getIt<ProgramService>(), getIt<UserSelectionService>()),
    );
    getIt.registerLazySingleton<HomeRepo>(
      () => HomeRepoImpl(getIt<HomeService>()),
    );
    getIt.registerFactory<HomeCubit>(() => HomeCubit(getIt<HomeRepo>()));

    getIt.registerLazySingleton<AppRouter>(AppRouter.new);
  }

  static void resetRouterAndSelection() {
    if (getIt.isRegistered<UserSelectionService>()) {
      getIt<UserSelectionService>().clear();
    }
    if (getIt.isRegistered<AppRouter>()) {
      getIt.unregister<AppRouter>();
      getIt.registerLazySingleton<AppRouter>(AppRouter.new);
    }
  }

  Future<void> launchApp() async {
    await tester.pumpWidget(const FitFlowApp());
    await tester.pump(const Duration(seconds: 3));
    await _pumpUntilFound(find.text('Select Your Goal'));
  }

  Future<void> selectGoal(String goalTitle) async {
    final finder = find.text(goalTitle);
    await _scrollUntilVisible(finder);
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }

  Future<void> selectAvailability(String availability) async {
    final finder = find.text(availability);
    await _scrollUntilVisible(finder);
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }

  Future<void> tapContinue() async {
    final finder = find.text('Continue');
    await _scrollUntilVisible(finder);
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }

  Future<void> _scrollUntilVisible(Finder finder) async {
    if (finder.evaluate().isNotEmpty) return;
    final scrollable = find.byType(SingleChildScrollView);
    if (scrollable.evaluate().isEmpty) return;
    await tester.scrollUntilVisible(finder, 200, scrollable: scrollable);
  }

  Future<void> _pumpUntilFound(
    Finder finder, {
    Duration timeout = const Duration(seconds: 8),
    Duration step = const Duration(milliseconds: 100),
  }) async {
    final end = DateTime.now().add(timeout);
    while (DateTime.now().isBefore(end)) {
      await tester.pump(step);
      if (finder.evaluate().isNotEmpty) return;
    }
  }

  void expectOnboardingLoaded() {
    expect(find.text('Select Your Goal'), findsOneWidget);
  }

  void expectRecommendedVisible() {
    expect(find.text('Recommended'), findsOneWidget);
  }

  void expectHomeLoaded() {
    expect(find.text('Weekly Blueprint'), findsOneWidget);
    expect(find.text('Good Morning'), findsOneWidget);
  }
}
