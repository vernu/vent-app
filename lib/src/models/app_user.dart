import 'package:equatable/equatable.dart';

class AppUser extends Equatable {
  String id, name, email, profilePic;
  int numVents;
  AppUser.fromMap(this.id, Map<String, dynamic> map) {
    if (map != null) {
      this.name = map['name'];
      this.email = map['icon'];
      this.numVents = map['numVents'] ?? 0;
      this.profilePic = map['profilePic'] ?? 'defaultPic';
    }
  }
  @override
  List<Object> get props => [id, name, email, numVents];
}
