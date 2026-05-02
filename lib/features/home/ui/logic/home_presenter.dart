import '../../data/repos/home_repo.dart';
import 'home_state.dart';

/// Pure presenter layer - no BLoC/Cubit, just logic
class HomePresenter {
  HomePresenter(this._repo);

  final HomeRepo _repo;

  // ── Load Program ────────────────────────────────────────────────────────────

  Future<HomeState> loadProgram() async {
    try {
      final program = await _repo.getProgram();

      if (program.trainingDays.isEmpty) {
        throw Exception(
          'No training days found in Firestore.\n'
          'Make sure you uploaded data with: node firebase-upload/index.js',
        );
      }

      return HomeSuccess(program: program);
    } catch (e) {
      final errorMsg = e.toString().replaceAll('Exception: ', '');
      return HomeFailure(message: 'Error: $errorMsg');
    }
  }

  // ── Select Day ──────────────────────────────────────────────────────────────

  HomeSuccess selectDay(HomeSuccess current, int dayIndex) {
    return current.copyWith(selectedDayIndex: dayIndex);
  }

  // ── Select Tab ──────────────────────────────────────────────────────────────

  HomeSuccess selectTab(HomeSuccess current, int tabIndex) {
    return current.copyWith(selectedTabIndex: tabIndex);
  }
}
