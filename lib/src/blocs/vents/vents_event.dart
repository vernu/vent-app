part of 'vents_bloc.dart';

abstract class VentsEvent extends Equatable {
  const VentsEvent();

  @override
  List<Object> get props => [];
}

class VentsLoadRequested extends VentsEvent{}