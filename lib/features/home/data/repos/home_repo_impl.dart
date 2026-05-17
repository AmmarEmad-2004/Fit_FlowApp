import 'package:dartz/dartz.dart';

import '../../../../core/failures/error_handler.dart';
import '../../../../core/failures/failure.dart';
import '../models/workout_program_model.dart';
import '../services/home_service.dart';
import 'home_repo.dart';

class HomeRepoImpl implements HomeRepo {
  HomeRepoImpl(this._service);

  final HomeService _service;

  @override
  Future<Either<Failure, WorkoutProgramModel>> getProgram() async {
    try {
      final program = await _service.loadProgram();
      return Right(program);
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }
}
