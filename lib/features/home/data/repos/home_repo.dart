import 'package:dartz/dartz.dart';

import '../../../../core/failures/failure.dart';
import '../../data/models/workout_program_model.dart';

abstract class HomeRepo {
  Future<Either<Failure, WorkoutProgramModel>> getProgram();
}
