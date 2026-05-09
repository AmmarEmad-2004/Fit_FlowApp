import 'training_day_model.dart';

class WorkoutProgramModel {
  

  final String programType;
  final int daysPerWeek;

  final List<TrainingDayModel> trainingDays;
  const WorkoutProgramModel({
    required this.programType,
    required this.daysPerWeek,
    required this.trainingDays,
  });
}
