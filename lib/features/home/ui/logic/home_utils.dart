import '../../data/models/training_day_model.dart';
import '../../data/models/workout_plan_model.dart';
import '../../data/models/workout_program_model.dart';

/// Utility class for computing derived values from home state
class HomeUtils {
  /// Get the currently selected training day from program
  static TrainingDayModel getCurrentDay(
    WorkoutProgramModel program,
    int selectedDayIndex,
  ) {
    return program.trainingDays[selectedDayIndex];
  }

  /// Create a WorkoutPlanModel from the selected day
  static WorkoutPlanModel getCurrentPlan(
    WorkoutProgramModel program,
    int selectedDayIndex,
  ) {
    final currentDay = program.trainingDays[selectedDayIndex];
    return WorkoutPlanModel(
      label: program.programType.toUpperCase(),
      title: currentDay.day,
      duration: '${currentDay.time} min',
      exerciseCount: '${currentDay.exercises.length} exercises',
    );
  }

  /// Abbreviate a day name to 3 uppercase letters of the first word.
  /// "Upper Body" → "UPP", "Push" → "PUS", "Squat Focus" → "SQU"
  static String abbreviateDayName(String dayName) {
    final word = dayName.split(' ').first;
    return word.substring(0, word.length.clamp(0, 3)).toUpperCase();
  }

  /// Get abbreviated labels for all training days
  static List<String> getDayLabels(WorkoutProgramModel program) {
    return program.trainingDays.map((d) => abbreviateDayName(d.day)).toList();
  }
}
