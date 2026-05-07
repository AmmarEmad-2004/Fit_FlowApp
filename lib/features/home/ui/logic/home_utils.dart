import '../../data/models/training_day_model.dart';
import '../../data/models/workout_plan_model.dart';

class HomeUtils {
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
