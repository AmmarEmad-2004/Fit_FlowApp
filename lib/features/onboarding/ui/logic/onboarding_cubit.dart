import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/onboarding_model.dart';
import '../../data/repos/onboarding_repo.dart';

part 'onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit(this._repo) : super(OnboardingInitial());

  final OnboardingRepo _repo;

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
    emit(
      OnboardingSuccess(
        model: current.model,
        selectedGoalId: goalId,
        selectedAvailability: current.selectedAvailability,
      ),
    );
  }

  void selectAvailability(String availability) {
    final current = state;
    if (current is! OnboardingSuccess) return;
    emit(
      OnboardingSuccess(
        model: current.model,
        selectedGoalId: current.selectedGoalId,
        selectedAvailability: availability,
      ),
    );
  }

  /// Saves the selection to Hive and returns when done.
  Future<void> persistSelection() async {
    final current = state;
    if (current is! OnboardingSuccess) return;

    await _repo.persistSelection(
      goalId: current.selectedGoalId,
      availability: current.selectedAvailability,
    );
  }

  String _defaultGoalId(OnboardingModel model, String current) {
    if (current.isNotEmpty) return current;
    return model.goals.isNotEmpty ? model.goals.first.id : 'build_muscle';
  }

  String _defaultAvailability(OnboardingModel model, String current) {
    if (current.isNotEmpty) return current;
    if (model.availabilityOptions.contains('3 Days')) {
      return '3 Days';
    }
    return model.availabilityOptions.isNotEmpty
        ? model.availabilityOptions.first
        : '3 Days';
  }
}
