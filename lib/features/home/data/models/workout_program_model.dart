import 'training_day_model.dart';

class WorkoutProgramModel {
  const WorkoutProgramModel({
    required this.programType,
    required this.daysPerWeek,
    required this.trainingDays,
  });

  /// e.g. "muscle", "strong", "general"
  final String programType;
  final int daysPerWeek;

  /// All training days for this program, ordered by day index
  final List<TrainingDayModel> trainingDays;
}
