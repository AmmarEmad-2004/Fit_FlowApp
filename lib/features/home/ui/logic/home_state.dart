import '../../data/models/workout_program_model.dart';

sealed class HomeState {
  const HomeState();
}

class HomeInitial extends HomeState {
  const HomeInitial();
}

class HomeLoading extends HomeState {
  const HomeLoading();
}

class HomeFailure extends HomeState {
  final String message;
  const HomeFailure(this.message);
}

class HomeSuccess extends HomeState {
  final WorkoutProgramModel program;
  final int selectedDayIndex;
  final int selectedTabIndex;

  const HomeSuccess({
    required this.program,
    this.selectedDayIndex = 0,
    this.selectedTabIndex = 0,
  });

  HomeSuccess copyWith({
    WorkoutProgramModel? program,
    int? selectedDayIndex,
    int? selectedTabIndex,
  }) {
    return HomeSuccess(
      program: program ?? this.program,
      selectedDayIndex: selectedDayIndex ?? this.selectedDayIndex,
      selectedTabIndex: selectedTabIndex ?? this.selectedTabIndex,
    );
  }
}
