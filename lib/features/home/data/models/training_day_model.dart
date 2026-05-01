import 'exercise_model.dart';

class TrainingDayModel {
  const TrainingDayModel({
    required this.day,
    required this.time,
    required this.exercises,
  });

  /// e.g. "Upper Body", "Push", "Squat Focus"
  final String day;

  /// Total session duration in minutes
  final int time;

  final List<ExerciseModel> exercises;

  factory TrainingDayModel.fromMap(Map<String, dynamic> map) {
    final exercisesList = map['exercises'] as List<dynamic>? ?? [];
    return TrainingDayModel(
      day: map['day'] as String? ?? 'Training Day',
      time: (map['time'] as num?)?.toInt() ?? 45,
      exercises: exercisesList.map((e) {
        final ex = e as Map<String, dynamic>;
        return ExerciseModel(
          name: ex['name'] as String? ?? 'Unknown Exercise',
          targetArea: ex['targetArea'] as String? ?? '—',
          reps: ex['reps'] as String? ?? '—',
        );
      }).toList(),
    );
  }
}
