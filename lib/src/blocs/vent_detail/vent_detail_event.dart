part of 'vent_detail_bloc.dart';

abstract class VentDetailEvent extends Equatable {
  const VentDetailEvent();

  @override
  List<Object> get props => [];
}

class VentCommentsLoadRequested extends VentDetailEvent {
  final Vent vent;
  VentCommentsLoadRequested({@required this.vent});
}
