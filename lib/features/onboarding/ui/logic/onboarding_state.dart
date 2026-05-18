part of 'onboarding_cubit.dart';

@immutable
sealed class PlansState {}

final class PlansInitial extends PlansState {}

final class PlansLoading extends PlansState {}

final class PlansSuccess extends PlansState {
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
