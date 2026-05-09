import '../../data/models/workout_program_model.dart';

abstract class HomeRepo {
  Future<WorkoutProgramModel> getProgram();
}
