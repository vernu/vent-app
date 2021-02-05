import 'package:equatable/equatable.dart';

class Vent extends Equatable {
  final String id;
  String userId, title, vent;
  int viewCount, commentCount;
  List<String> tags;
  DateTime createdAt;

  Vent({this.id, this.title, this.vent});
  Vent.fromMap(this.id, Map<String, dynamic> map) {
    // this.id= docId;
    this.userId = map['userId'];
    this.title = map['title'];
    this.vent = map['vent'];
    this.viewCount = map['viewCount'] ?? 0;
    this.commentCount = map['commentCount'] ?? 0;
    // this.tags = map['tags'] ?? [];
    this.createdAt =
        map['createdAt'] != null ? map['createdAt'].toDate() : null;
  }

  @override
  List<Object> get props => [id, userId, title, vent, tags];
}
