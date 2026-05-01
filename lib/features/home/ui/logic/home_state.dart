import '../../data/models/training_day_model.dart';
import '../../data/models/workout_plan_model.dart';
import '../../data/models/workout_program_model.dart';

/// Sealed states — no flat copyWith pattern.
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

  /// The currently selected training day
  TrainingDayModel get currentDay => program.trainingDays[selectedDayIndex];

  /// A WorkoutPlanModel computed from the selected day — used by PlanCard
  WorkoutPlanModel get currentPlan => WorkoutPlanModel(
        label: program.programType.toUpperCase(),
        title: currentDay.day,
        duration: '${currentDay.time} min',
        exerciseCount: '${currentDay.exercises.length} exercises',
      );

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
