class Vent{
  String id, userId, title, vent;

  Vent.fromMap(String docId, Map<String, dynamic> map){
    this.id= docId;
    this.userId = map['userId'];
    this.title = map['title'];
    this.vent = map['vent'];
  }
}