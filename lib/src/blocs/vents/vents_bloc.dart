import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:vent/src/models/vent.dart';
import 'package:vent/src/repository/vent_repository.dart';

part 'vents_event.dart';
part 'vents_state.dart';

class VentsBloc extends Bloc<VentsEvent, VentsState> {
  VentsBloc() : super(VentsState());

  @override
  Stream<VentsState> mapEventToState(
    VentsEvent event,
  ) async* {
    if (event is VentsLoadRequested) {
      yield this.state.copyWith(status: Status.Loading);
      try {
        List<Vent> vents = await VentRepository().getVents(
            userId: event.userId,
            categoryId: event.categoryId,
            tags: event.tags);
        yield VentsState(status: Status.Loaded, vents: vents);
      } catch (e) {
        yield this
            .state
            .copyWith(status: Status.LoadingFail, error: e.toString());
      }
    }
  }
}
