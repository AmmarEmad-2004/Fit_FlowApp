import '../../data/models/workout_program_model.dart';

abstract class HomeRepo {
  /// Fetches the full workout program (all training days + exercises) at once.
  Future<WorkoutProgramModel> getProgram();
}
