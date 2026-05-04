import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repos/home_repo.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepo _homeRepo;

  HomeCubit(this._homeRepo) : super(const HomeInitial());

  Future<void> load() async {
    emit(const HomeLoading());
    try {
      final program = await _homeRepo.getProgram();
      emit(HomeSuccess(program: program));
    } catch (e) {
      emit(HomeFailure(e.toString()));
    }
  }

  void selectDay(int index) {
    if (state is HomeSuccess) {
      final successState = state as HomeSuccess;
      emit(successState.copyWith(selectedDayIndex: index));
    }
  }

  void selectTab(int index) {
    if (state is HomeSuccess) {
      final successState = state as HomeSuccess;
      emit(successState.copyWith(selectedTabIndex: index));
    }
  }
}
