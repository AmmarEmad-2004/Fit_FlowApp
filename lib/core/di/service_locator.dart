import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../core/services/program_service.dart';
import '../../core/services/user_selection_service.dart';
import '../../features/home/data/repos/home_repo.dart';
import '../../features/home/data/repos/home_repo_impl.dart';
import '../../features/home/data/services/home_service.dart';
import '../../features/home/ui/logic/home_cubit.dart';
import '../../features/onboarding/data/repos/onboarding_repo.dart';
import '../../features/onboarding/data/repos/onboarding_repo_impl.dart';
import '../../features/onboarding/data/services/onboarding_service.dart';
import '../../features/onboarding/ui/logic/onboarding_cubit.dart';
import '../router/app_router.dart';

final GetIt getIt = GetIt.instance;

Future<void> setupGetIt() async {
  // ── Core services ──────────────────────────────────────────────────────
  // ProgramService.create() already calls Hive.initFlutter().
  final programService = await ProgramService.create();
  getIt.registerLazySingleton<ProgramService>(() => programService);

  // Open the user-selection box (Hive is already initialised above).
  final userBox = await Hive.openBox(UserSelectionService.boxName);
  getIt.registerLazySingleton<UserSelectionService>(
    () => UserSelectionService(userBox),
  );

  // ── Onboarding ─────────────────────────────────────────────────────────
  getIt.registerLazySingleton<OnboardingService>(OnboardingService.new);
  getIt.registerLazySingleton<OnboardingRepo>(
    () => OnboardingRepoImpl(
      getIt<OnboardingService>(),
      getIt<UserSelectionService>(),
    ),
  );
  getIt.registerFactory<OnboardingCubit>(
    () => OnboardingCubit(getIt<OnboardingRepo>()),
  );

  // ── Home ───────────────────────────────────────────────────────────────
  getIt.registerLazySingleton<HomeService>(
    () => HomeService(getIt<ProgramService>(), getIt<UserSelectionService>()),
  );
  getIt.registerLazySingleton<HomeRepo>(
    () => HomeRepoImpl(getIt<HomeService>()),
  );
  getIt.registerFactory<HomeCubit>(() => HomeCubit(getIt<HomeRepo>()));

  // ── Router ─────────────────────────────────────────────────────────────
  getIt.registerLazySingleton<AppRouter>(AppRouter.new);
}
