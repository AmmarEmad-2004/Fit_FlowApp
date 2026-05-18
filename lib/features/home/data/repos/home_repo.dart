import '../../data/models/workout_program_model.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/failures/failure.dart';

abstract class HomeRepo {
  Future<Either<Failure, WorkoutProgramModel>> getProgram();
}
