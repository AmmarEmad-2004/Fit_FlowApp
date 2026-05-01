import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repos/home_repo.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit(this._repo) : super(const HomeInitial());

  final HomeRepo _repo;

  // ── Load ────────────────────────────────────────────────────────────────────

  Future<void> load() async {
    emit(const HomeLoading());
    try {
      final program = await _repo.getProgram();
      if (program.trainingDays.isEmpty) {
        throw Exception(
          'No training days found in Firestore.\n'
          'Make sure you uploaded data with: node lib/firebase-upload/index.js',
        );
      }
      emit(HomeSuccess(program: program));
    } catch (e, st) {
      // ignore: avoid_print
      print('HomeCubit.load() error:\n$e\n$st');
      emit(HomeFailure(
        message: 'Error: ${e.toString().replaceAll('Exception: ', '')}',
      ));
    }
  }

  // ── Select training day ─────────────────────────────────────────────────────

  /// [index] maps directly to [WorkoutProgramModel.trainingDays] — no conversion.
  void selectDay(int index) {
    final s = state;
    if (s is HomeSuccess) emit(s.copyWith(selectedDayIndex: index));
  }

  // ── Select bottom-nav tab ───────────────────────────────────────────────────

  void selectTab(int index) {
    final s = state;
    if (s is HomeSuccess) emit(s.copyWith(selectedTabIndex: index));
  }
}
