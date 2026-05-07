import 'package:equatable/equatable.dart';

import '../../data/models/onboarding_model.dart';

class OnboardingState extends Equatable {
  const OnboardingState({
    required this.isLoading,
    required this.model,
    required this.selectedGoalId,
    required this.selectedAvailability,
    required this.errorMessage,
  });

  final bool isLoading;
  final OnboardingModel? model;
  final String selectedGoalId;
  final String selectedAvailability;
  final String? errorMessage;

  factory OnboardingState.initial() => const OnboardingState(
    isLoading: true,
    model: null,
    selectedGoalId: '',
    selectedAvailability: '',
    errorMessage: null,
  );

  OnboardingState copyWith({
    bool? isLoading,
    OnboardingModel? model,
    String? selectedGoalId,
    String? selectedAvailability,
    String? errorMessage,
    bool clearError = false,
  }) {
    return OnboardingState(
      isLoading: isLoading ?? this.isLoading,
      model: model ?? this.model,
      selectedGoalId: selectedGoalId ?? this.selectedGoalId,
      selectedAvailability: selectedAvailability ?? this.selectedAvailability,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    model,
    selectedGoalId,
    selectedAvailability,
    errorMessage,
  ];
}
