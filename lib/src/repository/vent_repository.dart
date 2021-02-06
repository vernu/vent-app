import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:vent/src/models/comment.dart';
import 'package:vent/src/models/vent.dart';

class VentRepository {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<List<Vent>> getLatestVents({int limit = 50}) async {
    List<Vent> vents = [];
    try {
      QuerySnapshot querySnapshot = await _firebaseFirestore
          .collection('vents')
          .orderBy('createdAt', descending: true)
          .limit(limit)
          .get();

      vents =
          querySnapshot.docs.map((v) => Vent.fromMap(v.id, v.data())).toList();
    } catch (e) {
      print(e.toString());
      throw Exception(e);
    }
    return vents;
  }

  Future<Vent> getASingleVent(String docId) async {
    Vent vent;
    DocumentSnapshot documentSnapshot =
        await _firebaseFirestore.collection('vents').doc(docId).get();
    if (documentSnapshot.exists) {
      vent = Vent.fromMap(documentSnapshot.id, documentSnapshot.data());
    } else {
      // vent doesnt exist
    }

    return vent;
  }

  Future<List<Comment>> getVentComments(String ventId, {int limit = 50}) async {
    List<Comment> comments = [];
    try {
      QuerySnapshot querySnapshot = await _firebaseFirestore
          .collection('vents/$ventId/ventComments')
          .orderBy('createdAt', descending: true)
          .limit(limit)
          .get();

      comments = querySnapshot.docs
          .map((v) => Comment.fromMap(v.id, v.data()))
          .toList();
    } catch (e) {
      print(e.toString());
      throw Exception(e);
    }
    return comments;
  }

  Future<bool> addVentComment(String ventId, {@required String comment}) async {
    try {
      await _firebaseFirestore.runTransaction((transaction) async {
        transaction.set(
            _firebaseFirestore.collection('/vents/$ventId/ventComments').doc(),
            {
              'userId': _firebaseAuth.currentUser != null
                  ? _firebaseAuth.currentUser.uid
                  : null,
              'comment': comment,
              'likeCount': 0,
              'replyCount': 0,
              'createdAt': FieldValue.serverTimestamp()
            });
        transaction.update(_firebaseFirestore.collection('/vents').doc(ventId),
            {'commentCount': FieldValue.increment(1)});
      });
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    } finally {}
  }

  void addVentView(String ventId) {
    _firebaseFirestore.collection('/vents/$ventId/ventViews').add({
      'userId': _firebaseAuth.currentUser != null
          ? _firebaseAuth.currentUser.uid
          : null,
      'createdAt': FieldValue.serverTimestamp()
    }).then((value) {
      _firebaseFirestore
          .collection('vents')
          .doc(ventId)
          .update({'viewCount': FieldValue.increment(1)});
    });
  }

  Future<bool> addVent(
      {@required String title,
      @required String vent,
      List<String> tags = const []}) async {
    try {
      _firebaseFirestore.runTransaction((transaction) async {
        transaction.set(_firebaseFirestore.collection('vents').doc(), {
          'userId': _firebaseAuth.currentUser.uid,
          'title': title,
          'vent': vent,
          'tags': tags,
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp()
        });
        DocumentSnapshot userDocSnapshot = await _firebaseFirestore
            .collection('users')
            .doc(_firebaseAuth.currentUser.uid)
            .get();
        if (userDocSnapshot.exists) {
          transaction.update(
              userDocSnapshot.reference, {'numVents': FieldValue.increment(1)});
        }
      });
      return true;
    } catch (e) {
      return false;
    } finally {}
  }

  Future<void> updateVent(String docId,
      {@required String title,
      @required String vent,
      List<String> tags = const []}) async {
    await _firebaseFirestore.collection('vents').doc(docId).update({
      'title': title,
      'vent': vent,
      'tags': tags,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> deleteVent(Vent vent) async {
    // await _firebaseFirestore.collection('vents').doc(ventDocId).delete();

    try {
      await _firebaseFirestore.runTransaction((transaction) async {
        DocumentSnapshot ventDocSnapshot =
            await _firebaseFirestore.collection('vents').doc(vent.id).get();
        if (ventDocSnapshot.exists) {
          transaction.delete(ventDocSnapshot.reference);
          DocumentSnapshot userDocSnapshot = await _firebaseFirestore
              .collection('users')
              .doc(vent.userId)
              .get();

          if (userDocSnapshot.exists) {
            transaction.update(userDocSnapshot.reference,
                {'numVents': FieldValue.increment(-1)});
          }
        } else {
          print('document snanpshot doesnt exist');
        }
      });
    } catch (e) {
      print(e);
    } finally {}
  }
}
