part of 'home_nav_cubit.dart';

class HomeNavState extends Equatable {
  final int selectedIndex; 
  const HomeNavState({this.selectedIndex=0});

  @override
  List<Object> get props => [selectedIndex];
}

