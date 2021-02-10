import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:vent/src/models/app_user.dart';

class UserRepository {
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  Future<AppUser> getASingleUser({@required String id}) async {
    AppUser appUser;

    try {
      DocumentSnapshot docSnapshot =
          await _firebaseFirestore.collection('users').doc(id).get();
      if (docSnapshot.exists) {
        appUser = AppUser.fromMap(docSnapshot.id, docSnapshot.data());
      }

      return appUser;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
