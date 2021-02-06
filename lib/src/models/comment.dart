import 'package:equatable/equatable.dart';

class Comment extends Equatable {
  final String id;
  String userId, ventId, comment;
  int likeCount, replyCount;
  DateTime createdAt;

  Comment.fromMap(this.id, Map<String, dynamic> map) {
    // this.id= docId;
    this.userId = map['userId'];
    this.ventId = map['ventId'];
    this.comment = map['comment'];
    this.likeCount = map['likeCount'] ?? 0;
    this.replyCount = map['replyCount'] ?? 0;
    this.createdAt =
        map['createdAt'] != null ? map['createdAt'].toDate() : null;
  }

  @override
  List<Object> get props => [id, ventId, comment];
}
