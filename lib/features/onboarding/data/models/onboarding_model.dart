import 'goal_model.dart';

class OnboardingModel {
  const OnboardingModel({
    required this.goals,
    required this.availabilityOptions,
    required this.recoveryHint,
  });

  final List<GoalModel> goals;
  final List<String> availabilityOptions;
  final String recoveryHint;
}
