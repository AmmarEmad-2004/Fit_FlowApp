import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/services/user_selection_service.dart';
import '../../data/repos/onboarding_repo.dart';
import 'onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit(this._repo, this._userSelectionService)
    : super(OnboardingState.initial());

  final OnboardingRepo _repo;
  final UserSelectionService _userSelectionService;

  Future<void> load() async {
    emit(state.copyWith(isLoading: true));
    final model = await _repo.getOnboardingData();
    emit(
      state.copyWith(
        isLoading: false,
        model: model,
        selectedGoalId: model.goals.first.id,
        selectedAvailability: model.availabilityOptions[1],
      ),
    );
  }

  void selectGoal(String goalId) {
    emit(state.copyWith(selectedGoalId: goalId));
  }

  void selectAvailability(String value) {
    emit(state.copyWith(selectedAvailability: value));
  }

  /// Save user selections and prepare for home screen
  Future<void> completeOnboarding() async {
    final goal = state.selectedGoalId;
    final availability = state.selectedAvailability;

    // Parse availability to daysPerWeek (e.g. "3 Days" → 3, "5+ Days" → 5)
    final raw = availability.split(' ').first.replaceAll('+', '');
    final daysPerWeek = int.tryParse(raw) ?? 3;

    // Get program type from selected goal (map goal to program type)
    final programType = _mapGoalToProgramType(goal);

    // Save to UserSelectionService
    _userSelectionService.setProgramSelection(
      programType: programType,
      daysPerWeek: daysPerWeek,
      goal: goal,
    );
  }

  /// Map goal ID to Firestore program type document name
  String _mapGoalToProgramType(String goalId) {
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
}
