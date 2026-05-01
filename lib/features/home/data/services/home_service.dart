import '../../../../core/services/program_service.dart';
import '../../../../core/services/user_selection_service.dart';
import '../models/training_day_model.dart';
import '../models/workout_program_model.dart';

class HomeService {
  HomeService(this._programService, this._userSelection);

  final ProgramService _programService;
  final UserSelectionService _userSelection;

  /// Fetches the entire program from Firestore in one call and maps it
  /// to a [WorkoutProgramModel] containing all training days and exercises.
  Future<WorkoutProgramModel> loadProgram() async {
    final programType = _userSelection.programType ?? 'muscle';
    final daysPerWeek = _userSelection.daysPerWeek ?? 3;

    final programData = await _programService.fetchProgram(
      programType,
      daysPerWeek,
    );

    final days = programData['days'] as Map<String, dynamic>? ?? {};
    final dayIds = days.keys.toList()..sort(); // day_0, day_1, …

    final trainingDays = dayIds.map((id) {
      final raw = days[id] as Map<String, dynamic>? ?? {};
      return TrainingDayModel.fromMap(raw);
    }).toList();

    return WorkoutProgramModel(
      programType: programType,
      daysPerWeek: daysPerWeek,
      trainingDays: trainingDays,
    );
  }
}
