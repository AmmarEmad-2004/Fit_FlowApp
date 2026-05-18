import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/onboarding_model.dart';
import '../../data/repos/onboarding_repo.dart';

part 'onboarding_state.dart';

class OnboardingCubit extends Cubit<PlansState> {
  OnboardingCubit(this._repo) : super(OnboardingInitial());

  final OnboardingRepo _repo;

  Future<void> load() async {
    emit(OnboardingLoading());
    final result = await _repo.getOnboardingData();

    result.fold((failure) => emit(OnboardingFailure(failure.message)), (model) {
      final current = state;
      final goalId = _defaultGoalId(
        model,
        current is PlansSuccess ? current.selectedGoalId : '',
      );
      final availability = _defaultAvailability(
        model,
        current is PlansSuccess ? current.selectedAvailability : '',
      );

      emit(
        PlansSuccess(
          model: model,
          selectedGoalId: goalId,
          selectedAvailability: availability,
        ),
      );
    });
  }

  void selectGoal(String goalId) {
    final current = state;
    if (current is! PlansSuccess) return;
    emit(
      PlansSuccess(
        model: current.model,
        selectedGoalId: goalId,
        selectedAvailability: current.selectedAvailability,
      ),
    );
  }

  void selectAvailability(String availability) {
    final current = state;
    if (current is! PlansSuccess) return;
    emit(
      PlansSuccess(
        model: current.model,
        selectedGoalId: current.selectedGoalId,
        selectedAvailability: availability,
      ),
    );
  }

  void persistSelection() {
    final current = state;
    if (current is! PlansSuccess) return;

    final result = _repo.persistSelection(
      goalId: current.selectedGoalId,
      availability: current.selectedAvailability,
    );

    result.fold((failure) => emit(PlansFailure(failure.message)), (_) {});
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
