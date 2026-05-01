import '../../data/models/onboarding_model.dart';

class OnboardingState {
  const OnboardingState({
    required this.isLoading,
    required this.model,
    required this.selectedGoalId,
    required this.selectedAvailability,
  });

  factory OnboardingState.initial() {
    return const OnboardingState(
      isLoading: true,
      model: null,
      selectedGoalId: '',
      selectedAvailability: '',
    );
  }

  final bool isLoading;
  final OnboardingModel? model;
  final String selectedGoalId;
  final String selectedAvailability;

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
