import 'package:equatable/equatable.dart';

class Vent extends Equatable {
  final String id;
  String userId, title, vent;
  List<String> tags;

  Vent({this.id, this.title, this.vent});
  Vent.fromMap(this.id, Map<String, dynamic> map) {
    // this.id= docId;
    this.userId = map['userId'];
    this.title = map['title'];
    this.vent = map['vent'];
    // this.tags = map['tags'] != null ? map['tags'] : [];
  }

  @override
  List<Object> get props => [id, userId, title, vent, tags];
}
