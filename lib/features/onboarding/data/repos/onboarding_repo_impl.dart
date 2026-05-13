import '../models/onboarding_model.dart';
import '../services/onboarding_service.dart';
import '../../../../core/services/user_selection_service.dart';
import 'onboarding_repo.dart';

class OnboardingRepoImpl implements OnboardingRepo {
  OnboardingRepoImpl(this._service, this._selection);

  final OnboardingService _service;
  final UserSelectionService _selection;

  @override
  Future<OnboardingModel> getOnboardingData() {
    return _service.loadOnboardingData();
  }

  @override
  Future<void> persistSelection({
    required String goalId,
    required String availability,
  }) async {
    final programType = _mapGoalToProgram(goalId);
    final daysPerWeek = _parseDays(availability);

    await _selection.save(
      programType: programType,
      daysPerWeek: daysPerWeek,
    );
  }

  String _mapGoalToProgram(String goalId) {
    return switch (goalId) {
      'build_muscle'    => 'muscle',
      'get_strong'      => 'strong',
      'general_fitness' => 'general',
      _                 => 'muscle',
    };
  }

  int _parseDays(String availability) {
    final match = RegExp(r'\d+').firstMatch(availability);
    if (match == null) return 3;
    final value = int.tryParse(match.group(0) ?? '3') ?? 3;
    return value < 2 ? 2 : value;
  }
}
