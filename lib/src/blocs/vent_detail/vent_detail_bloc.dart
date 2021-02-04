import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'vent_detail_event.dart';
part 'vent_detail_state.dart';

class VentDetailBloc extends Bloc<VentDetailEvent, VentDetailState> {
  VentDetailBloc() : super(VentDetailInitial());

  @override
  Stream<VentDetailState> mapEventToState(
    VentDetailEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
