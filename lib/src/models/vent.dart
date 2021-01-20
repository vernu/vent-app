class Vent{
  String id, title, vent;

  Vent.fromMap(String docId, Map<String, dynamic> map){
    this.id= docId;
    this.title = map['title'];
    this.vent = map['vent'];
  }
}