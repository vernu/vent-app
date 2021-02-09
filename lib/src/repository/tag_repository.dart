import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vent/src/models/tag.dart';

class TagRepository {
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  Future<List<Tag>> getTags() async {
    List<Tag> tags = [];
    QuerySnapshot querySnapshot = await _firebaseFirestore
        .collection('tags')
        .orderBy('ventCount', descending: true)
        .get();
    tags = querySnapshot.docs
        .map((doc) => Tag.fromMap(doc.id, doc.data()))
        .toList();
    return tags;
  }
}
