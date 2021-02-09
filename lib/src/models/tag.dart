import 'package:equatable/equatable.dart';

class Tag extends Equatable {
  String id, tag;
  int ventCount;
  DateTime createdAt;
  Tag({this.id, this.tag, this.ventCount});
  Tag.fromMap(this.id, Map<String, dynamic> map) {
    this.tag = this.id;
    this.ventCount = map['ventCount'] ?? 0;
    this.createdAt =
        map['createdAt'] != null ? map['createdAt'].toDate() : null;
  }
  @override
  List<Object> get props => [id, tag, ventCount];
}
