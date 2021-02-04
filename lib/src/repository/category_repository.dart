import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vent/src/models/category.dart';

class CategoryRepository {
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  Future<List<Category>> getCategories() async {
    List<Category> categories = [];
    QuerySnapshot querySnapshot =
        await _firebaseFirestore.collection('categories').orderBy('name').get();
    categories = querySnapshot.docs
        .map((doc) => Category.fromMap(doc.id, doc.data()))
        .toList();
    return categories;
  }
}
