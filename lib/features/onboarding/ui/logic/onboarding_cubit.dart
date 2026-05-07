import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/services/user_selection_service.dart';
import '../../data/models/onboarding_model.dart';
import '../../data/repos/onboarding_repo.dart';

part 'onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit(this._repo, this._selection) : super(OnboardingInitial());

  final OnboardingRepo _repo;
  final UserSelectionService _selection;

  Future<void> load() async {
    emit(OnboardingLoading());
    try {
      final model = await _repo.getOnboardingData();
      final current = state;
      final goalId = _defaultGoalId(
        model,
        current is OnboardingSuccess ? current.selectedGoalId : '',
      );
      final availability = _defaultAvailability(
        model,
        current is OnboardingSuccess ? current.selectedAvailability : '',
      );

      emit(
        OnboardingSuccess(
          model: model,
          selectedGoalId: goalId,
          selectedAvailability: availability,
        ),
      );
    } catch (_) {
      emit(OnboardingFailure('Unable to load onboarding data.'));
    }
  }

  void selectGoal(String goalId) {
    final current = state;
    if (current is! OnboardingSuccess) return;
    emit(current.copyWith(selectedGoalId: goalId));
  }

  void selectAvailability(String availability) {
    final current = state;
    if (current is! OnboardingSuccess) return;
    emit(current.copyWith(selectedAvailability: availability));
  }

  void persistSelection() {
    final current = state;
    if (current is! OnboardingSuccess) return;

    final goalId = current.selectedGoalId;
    final availability = current.selectedAvailability;

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
