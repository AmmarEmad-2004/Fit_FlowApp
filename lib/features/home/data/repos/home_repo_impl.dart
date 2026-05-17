import '../models/workout_program_model.dart';
import '../services/home_service.dart';
import 'home_repo.dart';

class HomeRepoImpl implements HomeRepo {
  HomeRepoImpl(this._service);

  final HomeService _service;

  @override
  Future<WorkoutProgramModel> getProgram() => _service.loadProgram();
}
