import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/workout_program_model.dart';
import '../../data/repos/home_repo.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit(this._repo) : super(HomeInitial());

  final HomeRepo _repo;

  Future<void> load() async {
    emit(HomeLoading());
    try {
      final program = await _repo.getProgram();
      emit(
        HomeSuccess(program: program, selectedDayIndex: 0, selectedTabIndex: 0),
      );
    } catch (_) {
      emit(HomeFailure('Unable to load your plan. Please try again.'));
    }
  }

  void selectDay(int index) {
    final current = state;
    if (current is! HomeSuccess) return;

    final maxIndex = current.program.trainingDays.length - 1;
    if (maxIndex < 0) return;
    final clamped = index.clamp(0, maxIndex);

    emit(current.copyWith(selectedDayIndex: clamped));
  }

  void selectTab(int index) {
    final current = state;
    if (current is! HomeSuccess) return;

    emit(current.copyWith(selectedTabIndex: index));
  }
}
