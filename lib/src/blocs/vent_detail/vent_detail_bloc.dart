import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:vent/src/models/comment.dart';
import 'package:vent/src/models/vent.dart';
import 'package:vent/src/repository/vent_repository.dart';

part 'vent_detail_event.dart';
part 'vent_detail_state.dart';

class VentDetailBloc extends Bloc<VentDetailEvent, VentDetailState> {
  VentDetailBloc()
      : super(VentDetailState(
            commentsLoadingStatus: CommentsLoadingStatus.Initial));

  @override
  Stream<VentDetailState> mapEventToState(
    VentDetailEvent event,
  ) async* {
    if (event is VentCommentsLoadRequested) {
      yield VentDetailState(
        commentsLoadingStatus: CommentsLoadingStatus.Loading,
      );
      try {
        List<Comment> comments =
            await VentRepository().getVentComments(event.vent.id);
        yield VentDetailState(
            commentsLoadingStatus: CommentsLoadingStatus.Loaded,
            ventComments: comments);
      } catch (e) {
        yield VentDetailState(
          commentsLoadingStatus: CommentsLoadingStatus.LoadingFailed,
        );
      }
    }
  }
}
