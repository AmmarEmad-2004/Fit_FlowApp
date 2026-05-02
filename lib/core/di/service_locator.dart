import 'package:get_it/get_it.dart';

import '../../core/services/program_service.dart';
import '../../core/services/user_selection_service.dart';
import '../../features/home/data/repos/home_repo.dart';
import '../../features/home/data/repos/home_repo_impl.dart';
import '../../features/home/data/services/home_service.dart';
import '../../features/home/ui/logic/home_controller.dart';
import '../../features/onboarding/data/repos/onboarding_repo.dart';
import '../../features/onboarding/data/repos/onboarding_repo_impl.dart';
import '../../features/onboarding/data/services/onboarding_service.dart';
import '../../features/onboarding/ui/logic/onboarding_cubit.dart';
import '../router/app_router.dart';

final GetIt getIt = GetIt.instance;

Future<void> setupDependencies() async {
  final programService = await ProgramService.create();
  getIt.registerLazySingleton<ProgramService>(() => programService);
  getIt.registerLazySingleton<UserSelectionService>(UserSelectionService.new);

  getIt.registerLazySingleton<OnboardingService>(OnboardingService.new);
  getIt.registerLazySingleton<OnboardingRepo>(
    () => OnboardingRepoImpl(getIt<OnboardingService>()),
  );
  getIt.registerFactory<OnboardingCubit>(
    () =>
        OnboardingCubit(getIt<OnboardingRepo>(), getIt<UserSelectionService>()),
  );

  getIt.registerLazySingleton<HomeService>(
    () => HomeService(getIt<ProgramService>(), getIt<UserSelectionService>()),
  );
  getIt.registerLazySingleton<HomeRepo>(
    () => HomeRepoImpl(getIt<HomeService>()),
  );
  getIt.registerFactory<HomeController>(() => HomeController(getIt<HomeRepo>()));

  getIt.registerLazySingleton<AppRouter>(AppRouter.new);
}
