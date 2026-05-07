import 'package:equatable/equatable.dart';

import '../../data/models/workout_program_model.dart';

sealed class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {
  const HomeInitial();
}

class HomeLoading extends HomeState {
  const HomeLoading();
}

class HomeFailure extends HomeState {
  const HomeFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

class HomeSuccess extends HomeState {
  const HomeSuccess({
    required this.program,
    required this.selectedDayIndex,
    required this.selectedTabIndex,
  });

  final WorkoutProgramModel program;
  final int selectedDayIndex;
  final int selectedTabIndex;

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

  @override
  List<Object?> get props => [program, selectedDayIndex, selectedTabIndex];
}
