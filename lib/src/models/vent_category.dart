import 'package:equatable/equatable.dart';

class VentCategory extends Equatable {
  String id, name, icon;
  VentCategory({this.id, this.name, this.icon});
  VentCategory.fromMap(this.id, Map<String, dynamic> map) {
    // this.id= docId;
    this.name = map['name'];
    this.icon = map['icon'];
  }
  @override
  List<Object> get props => [id, name, icon];
}
