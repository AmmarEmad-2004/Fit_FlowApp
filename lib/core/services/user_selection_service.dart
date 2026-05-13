/// Service to store user selections from onboarding
class UserSelectionService {
  String? _selectedProgramType;
  int? _selectedDaysPerWeek;
  String? _selectedGoal;

  String? get programType => _selectedProgramType;
  int? get daysPerWeek => _selectedDaysPerWeek;
  String? get goal => _selectedGoal;

  void setProgramSelection({
    required String programType,
    required int daysPerWeek,
    required String goal,
  }) {
    _selectedProgramType = programType;
    _selectedDaysPerWeek = daysPerWeek;
    _selectedGoal = goal;
  }

  void clear() {
    _selectedProgramType = null;
    _selectedDaysPerWeek = null;
    _selectedGoal = null;
  }
}
