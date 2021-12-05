import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'home_nav_state.dart';

class HomeNavCubit extends Cubit<HomeNavState> {
  HomeNavCubit() : super(HomeNavState());

  void changeCurrentIndex(int index) {
    emit(HomeNavState(selectedIndex: index));
  }

  void goToSigninTabIfUnAuthenticated() {
    FirebaseAuth _instance = FirebaseAuth.instance;
    int index = _instance.currentUser != null ? 0 : 2;
    emit(HomeNavState(selectedIndex: index));
  }
}
