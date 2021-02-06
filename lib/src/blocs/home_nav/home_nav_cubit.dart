import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'home_nav_state.dart';

class HomeNavCubit extends Cubit<HomeNavState> {
  HomeNavCubit() : super(HomeNavState());

  void changeCurrentIndex(int index) {
    emit(HomeNavState(selectedIndex: index));
  }
}
