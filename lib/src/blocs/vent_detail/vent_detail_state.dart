part of 'vent_detail_bloc.dart';

enum CommentsLoadingStatus { Initial, Loading, Loaded, LoadingFailed }

class VentDetailState {
  final CommentsLoadingStatus commentsLoadingStatus;
  final List<Comment> ventComments;
  final bool submittingComment;
  VentDetailState(
      {this.commentsLoadingStatus = CommentsLoadingStatus.Initial,
      this.ventComments = const [],
      this.submittingComment = false});

  VentDetailState copyWith(
      {commentsLoadingStatus, ventComments, submittingComment}) {
    return VentDetailState(
        commentsLoadingStatus:
            commentsLoadingStatus ?? this.commentsLoadingStatus,
        ventComments: ventComments ?? this.ventComments,
        submittingComment: submittingComment ?? this.submittingComment);
  }
}
