import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repos/onboarding_repo.dart';
import '../../../../core/services/user_selection_service.dart';
import 'onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  final OnboardingRepo _repo;
  // ignore: unused_field
  final UserSelectionService _userSelectionService;

  OnboardingCubit(this._repo, this._userSelectionService) : super(const OnboardingState());

  Future<void> load() async {
    emit(state.copyWith(isLoading: true));
    try {
      final data = await _repo.getOnboardingData();
      emit(state.copyWith(
        isLoading: false,
        model: data,
        selectedGoalId: data.goals.isNotEmpty ? data.goals.first.id : null,
        selectedAvailability: data.availabilityOptions.isNotEmpty ? data.availabilityOptions.first : null,
      ));
    } catch (e) {
      emit(state.copyWith(isLoading: false));
    }
  }

  void selectGoal(String goalId) {
    emit(state.copyWith(selectedGoalId: goalId));
  }

  void selectAvailability(String availability) {
    emit(state.copyWith(selectedAvailability: availability));
  }

  Future<void> completeOnboarding() async {
    // Save to user selection
  }
}
