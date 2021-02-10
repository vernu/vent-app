import 'package:equatable/equatable.dart';
import 'package:vent/src/models/app_user.dart';

class Vent extends Equatable {
  final String id;
  String userId, categoryId, title, vent;
  AppUser user;
  int viewCount, commentCount;
  List<String> tags;
  DateTime createdAt;

  Vent.fromMap(this.id, Map<String, dynamic> map, {user}) {
    // this.id= docId;
    this.userId = map['userId'];
    this.user = user ?? null;
    this.categoryId = map['categoryId'];
    this.title = map['title'];
    this.vent = map['vent'];
    this.viewCount = map['viewCount'] ?? 0;
    this.commentCount = map['commentCount'] ?? 0;
    this.tags = map['tags'] != null ? List.from(map['tags']) : [];
    this.createdAt =
        map['createdAt'] != null ? map['createdAt'].toDate() : null;
  }

  @override
  List<Object> get props => [id, userId, title, vent, tags];
}
