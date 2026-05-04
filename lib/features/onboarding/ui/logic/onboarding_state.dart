import '../../data/models/onboarding_model.dart';

class OnboardingState {
  final bool isLoading;
  final OnboardingModel? model;
  final String? selectedGoalId;
  final String? selectedAvailability;

  const OnboardingState({
    this.isLoading = false,
    this.model,
    this.selectedGoalId,
    this.selectedAvailability,
  });

  OnboardingState copyWith({
    bool? isLoading,
    OnboardingModel? model,
    String? selectedGoalId,
    String? selectedAvailability,
  }) {
    return OnboardingState(
      isLoading: isLoading ?? this.isLoading,
      model: model ?? this.model,
      selectedGoalId: selectedGoalId ?? this.selectedGoalId,
      selectedAvailability: selectedAvailability ?? this.selectedAvailability,
    );
  }
}
