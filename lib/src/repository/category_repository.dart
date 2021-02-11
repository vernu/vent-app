import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:vent/src/models/vent_category.dart';

class CategoryRepository {
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  Future<List<VentCategory>> getCategories() async {
    List<VentCategory> categories = [];
    QuerySnapshot querySnapshot =
        await _firebaseFirestore.collection('categories').orderBy('name').get();
    categories = querySnapshot.docs
        .map((doc) => VentCategory.fromMap(doc.id, doc.data()))
        .toList();
    return categories;
  }

  Future<VentCategory> getASingleCategory({@required String id}) async {
    VentCategory category;

    try {
      DocumentSnapshot docSnapshot =
          await _firebaseFirestore.collection('categories').doc(id).get();
      if (docSnapshot.exists) {
        category = VentCategory.fromMap(docSnapshot.id, docSnapshot.data());
      }

      return category;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
