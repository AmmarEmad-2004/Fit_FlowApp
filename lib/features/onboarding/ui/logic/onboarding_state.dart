part of 'onboarding_cubit.dart';

@immutable
sealed class PlansState {}

final class OnboardingInitial extends PlansState {}

final class OnboardingLoading extends PlansState {}

final class OnboardingSuccess extends PlansState {
  final OnboardingModel model;
  final String selectedGoalId;
  final String selectedAvailability;

  OnboardingSuccess({
    required this.model,
    required this.selectedGoalId,
    required this.selectedAvailability,
  });
}

final class OnboardingFailure extends PlansState {
  final String message;

  OnboardingFailure(this.message);
}
