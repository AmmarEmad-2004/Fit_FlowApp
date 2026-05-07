import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/services/user_selection_service.dart';
import '../../data/models/onboarding_model.dart';
import '../../data/repos/onboarding_repo.dart';
import 'onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit(this._repo, this._selection)
    : super(OnboardingState.initial());

  final OnboardingRepo _repo;
  final UserSelectionService _selection;

  Future<void> load() async {
    emit(state.copyWith(isLoading: true, clearError: true));
    try {
      final model = await _repo.getOnboardingData();
      final goalId = _defaultGoalId(model, state.selectedGoalId);
      final availability = _defaultAvailability(
        model,
        state.selectedAvailability,
      );

      emit(
        state.copyWith(
          isLoading: false,
          model: model,
          selectedGoalId: goalId,
          selectedAvailability: availability,
          clearError: true,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: 'Unable to load onboarding data.',
        ),
      );
    }
  }

  void selectGoal(String goalId) {
    emit(state.copyWith(selectedGoalId: goalId));
  }

  void selectAvailability(String availability) {
    emit(state.copyWith(selectedAvailability: availability));
  }

  void persistSelection() {
    final model = state.model;
    if (model == null) return;

    final goalId = state.selectedGoalId;
    final availability = state.selectedAvailability;

    final programType = _mapGoalToProgram(goalId);
    final daysPerWeek = _parseDays(availability);

    _selection.setProgramSelection(
      programType: programType,
      daysPerWeek: daysPerWeek,
      goal: goalId,
    );
  }

  String _defaultGoalId(OnboardingModel model, String current) {
    if (current.isNotEmpty) return current;
    return model.goals.isNotEmpty ? model.goals.first.id : 'build_muscle';
  }

  String _defaultAvailability(OnboardingModel model, String current) {
    if (current.isNotEmpty) return current;
    return model.availabilityOptions.isNotEmpty
        ? model.availabilityOptions.first
        : '3 Days';
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
