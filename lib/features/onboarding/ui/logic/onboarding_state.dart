part of 'onboarding_cubit.dart';

@immutable
sealed class OnboardingState {}

final class OnboardingInitial extends OnboardingState {}

final class OnboardingLoading extends OnboardingState {}

final class OnboardingFailure extends OnboardingState {
  final String message;

  OnboardingFailure(this.message);
}

final class OnboardingSuccess extends OnboardingState {
  final OnboardingModel model;
  final String selectedGoalId;
  final String selectedAvailability;

  OnboardingSuccess({
    required this.model,
    required this.selectedGoalId,
    required this.selectedAvailability,
  });

  OnboardingSuccess copyWith({
    OnboardingModel? model,
    String? selectedGoalId,
    String? selectedAvailability,
  }) {
    return OnboardingSuccess(
      model: model ?? this.model,
      selectedGoalId: selectedGoalId ?? this.selectedGoalId,
      selectedAvailability: selectedAvailability ?? this.selectedAvailability,
    );
  }
}
