import '../../data/models/training_day_model.dart';
import '../../data/models/workout_plan_model.dart';

class HomeUtils {
  static const List<String> _weekdayInitials = [
    'M',
    'T',
    'W',
    'T',
    'F',
    'S',
    'S',
  ];

  static List<String> weekdayInitials() => List.of(_weekdayInitials);

  /// Distributes active training days across a 7-day week using fixed rules.
  static List<bool> weeklyBlueprint(int activeDays) {
    if (activeDays <= 0) return List<bool>.filled(7, false);

    switch (activeDays.clamp(1, 5)) {
      case 1:
        return [true, false, false, false, false, false, false];
      case 2:
        return [true, false, false, true, false, false, false];
      case 3:
        return [true, false, true, false, true, false, false];
      case 4:
        return [true, false, true, false, true, false, true];
      case 5:
        return [true, true, false, true, true, false, true];
      default:
        return List<bool>.filled(7, false);
    }
  }

  static List<String> dayLabels(List<TrainingDayModel> days) {
    return days.map((day) => _shortLabel(day.day)).toList();
  }

  static WorkoutPlanModel planForDay(TrainingDayModel day) {
    return WorkoutPlanModel(
      label: 'SESSION',
      title: day.day,
      duration: '${day.time} min',
      exerciseCount: '${day.exercises.length} Exercises',
    );
  }

  static String _shortLabel(String value) {
    final cleaned = value.trim();
    if (cleaned.isEmpty) return 'DAY';

    final words = cleaned.split(RegExp(r'\s+'));
    if (words.length == 1) {
      final end = cleaned.length < 3 ? cleaned.length : 3;
      return cleaned.substring(0, end).toUpperCase();
    }

    final letters = words.map((word) => word[0]).take(3).join();
    return letters.toUpperCase();
  }
}
