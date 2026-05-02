import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repos/home_repo.dart';
import 'home_presenter.dart';
import 'home_state.dart';

/// Thin BLoC wrapper around HomePresenter
class HomeCubit extends Cubit<HomeState> {
  HomeCubit(HomeRepo repo)
    : _presenter = HomePresenter(repo),
      super(const HomeInitial());

  final HomePresenter _presenter;

  /// Load program from repo via presenter
  Future<void> load() async {
    emit(const HomeLoading());
    final newState = await _presenter.loadProgram();
    emit(newState);
  }

  /// Select training day
  void selectDay(int index) {
    final s = state;
    if (s is HomeSuccess) {
      emit(_presenter.selectDay(s, index));
    }
  }

  /// Select bottom-nav tab
  void selectTab(int index) {
    final s = state;
    if (s is HomeSuccess) {
      emit(_presenter.selectTab(s, index));
    }
  }
}
