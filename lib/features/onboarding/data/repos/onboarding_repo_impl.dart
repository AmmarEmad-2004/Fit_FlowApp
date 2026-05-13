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
  void persistSelection({
    required String goalId,
    required String availability,
  }) {
    final programType = _mapGoalToProgram(goalId);
    final daysPerWeek = _parseDays(availability);

    _selection.setProgramSelection(
      programType: programType,
      daysPerWeek: daysPerWeek,
      goal: goalId,
    );
  }

  String _mapGoalToProgram(String goalId) {
    switch (goalId) {
      case 'build_muscle':
        return 'muscle';
      case 'get_strong':
        return 'strong';
      case 'general_fitness':
        return 'general';
      default:
        return 'muscle';
    }
  }

  int _parseDays(String availability) {
    final match = RegExp(r'\d+').firstMatch(availability);
    if (match == null) return 3;
    final value = int.tryParse(match.group(0) ?? '3') ?? 3;
    return value < 2 ? 2 : value;
  }
}
