import 'package:equatable/equatable.dart';

import '../../data/models/onboarding_model.dart';

sealed class OnboardingState extends Equatable {
  const OnboardingState();

  @override
  List<Object?> get props => [];
}

class OnboardingInitial extends OnboardingState {
  const OnboardingInitial();
}

class OnboardingLoading extends OnboardingState {
  const OnboardingLoading();
}

class OnboardingFailure extends OnboardingState {
  const OnboardingFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

class OnboardingSuccess extends OnboardingState {
  const OnboardingSuccess({
    required this.model,
    required this.selectedGoalId,
    required this.selectedAvailability,
  });

  final OnboardingModel model;
  final String selectedGoalId;
  final String selectedAvailability;

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

  @override
  List<Object?> get props => [model, selectedGoalId, selectedAvailability];
}
