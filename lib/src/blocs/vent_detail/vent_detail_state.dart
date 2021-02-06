part of 'vent_detail_bloc.dart';

enum CommentsLoadingStatus { Initial, Loading, Loaded, LoadingFailed }

class VentDetailState {
  final CommentsLoadingStatus commentsLoadingStatus;
  final List<Comment> ventComments;
  const VentDetailState(
      {@required this.commentsLoadingStatus, this.ventComments = const []});
}
