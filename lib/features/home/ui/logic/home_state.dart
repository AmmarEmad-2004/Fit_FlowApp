import '../../data/models/workout_program_model.dart';

/// Sealed states — pure data containers
sealed class HomeState {
  const HomeState();
}

class HomeInitial extends HomeState {
  const HomeInitial();
}

class HomeLoading extends HomeState {
  const HomeLoading();
}

class HomeSuccess extends HomeState {
  const HomeSuccess({
    required this.program,
    this.selectedDayIndex = 0,
    this.selectedTabIndex = 0,
  });

  final WorkoutProgramModel program;
  final int selectedDayIndex;
  final int selectedTabIndex;

  HomeSuccess copyWith({int? selectedDayIndex, int? selectedTabIndex}) {
    return HomeSuccess(
      program: program,
      selectedDayIndex: selectedDayIndex ?? this.selectedDayIndex,
      selectedTabIndex: selectedTabIndex ?? this.selectedTabIndex,
    );
  }
}

class HomeFailure extends HomeState {
  const HomeFailure({required this.message});
  final String message;
}
