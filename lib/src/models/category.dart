import 'package:equatable/equatable.dart';

class Category extends Equatable {
  String id, name, icon;
  Category({this.id, this.name, this.icon});
  Category.fromMap(this.id, Map<String, dynamic> map) {
    // this.id= docId;
    this.name = map['name'];
    this.icon = map['icon'];
  }
  @override
  List<Object> get props => [id, name, icon];
}
