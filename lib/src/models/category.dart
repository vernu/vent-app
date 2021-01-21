class Category{
  String id, name, icon;

  Category.fromMap(String docId, Map<String, dynamic> map){
    this.id= docId;
    this.name = map['name'];
    this.icon = map['icon'];
  }
}