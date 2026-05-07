part of 'home_cubit.dart';

@immutable
sealed class HomeState {}

final class HomeInitial extends HomeState {}

final class HomeLoading extends HomeState {}

final class HomeFailure extends HomeState {
  final String message;

  HomeFailure(this.message);
}

final class HomeSuccess extends HomeState {
  final WorkoutProgramModel program;
  final int selectedDayIndex;
  final int selectedTabIndex;

  HomeSuccess({
    required this.program,
    required this.selectedDayIndex,
    required this.selectedTabIndex,
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
