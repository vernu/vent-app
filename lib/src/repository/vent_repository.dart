import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:vent/src/models/app_user.dart';
import 'package:vent/src/models/vent_category.dart';
import 'package:vent/src/models/comment.dart';
import 'package:vent/src/models/vent.dart';
import 'package:vent/src/repository/user_repository.dart';

class VentRepository {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<List<Vent>> getVents(
      {String userId,
      String categoryId,
      List<String> tags,
      int limit = 50,
      String orderByField = 'createdAt',
      bool descending = true}) async {
    CollectionReference ref = _firebaseFirestore.collection('vents');
    Query query = ref;
    QuerySnapshot querySnapshot;
    List<Vent> vents = [];

    try {
      if (userId != null) {
        query = ref.where('userId', isEqualTo: userId);
      }
      if (categoryId != null) {
        query = ref.where('categoryId', isEqualTo: categoryId);
      }
      if (tags != null && tags.length > 0) {
        query = ref.where('tags', arrayContainsAny: tags);
      }
      querySnapshot = await query
          .orderBy(orderByField, descending: descending)
          .limit(limit)
          .get();

      // for (QueryDocumentSnapshot q in querySnapshot.docs) {
      //   AppUser user =
      //       await UserRepository().getASingleUser(id: q.data()['userId']);
      //   VentCategory category = await CategoryRepository()
      //       .getASingleCategory(id: q.data()['categoryId']);
      //   vents.add(Vent.fromMap(q.id, q.data(), user: user, category: category));
      // }
      vents = querySnapshot.docs
          .map((v) => Vent.fromMap(
                v.id,
                v.data(),
              ))
          .toList();
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

      // comments = querySnapshot.docs
      //     .map((v) => Comment.fromMap(v.id, v.data()))
      //     .toList();
      for (QueryDocumentSnapshot q in querySnapshot.docs) {
        AppUser user =
            await UserRepository().getASingleUser(id: q.get('userId'));
        comments.add(Comment.fromMap(q.id, q.data(), user: user));
      }
    } catch (e) {
      print(e.toString());
      throw Exception(e);
    }
    return comments;
  }

  Future<bool> addVentComment(String ventId, {@required String comment}) async {
    try {
      await _firebaseFirestore.runTransaction((transaction) async {
        DocumentSnapshot freshVentSnapshot = await transaction
            .get(_firebaseFirestore.collection('/vents').doc(ventId));

        transaction.set(
            _firebaseFirestore.collection('/vents/$ventId/ventComments').doc(),
            {
              'userId': _firebaseAuth.currentUser != null
                  ? _firebaseAuth.currentUser.uid
                  : null,
              'userName': _firebaseAuth.currentUser.displayName,
              'comment': comment,
              'likeCount': 0,
              'replyCount': 0,
              'createdAt': FieldValue.serverTimestamp()
            });

        transaction.update(freshVentSnapshot.reference,
            {'commentCount': FieldValue.increment(1)});
      });
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    } finally {}
  }

  Future<void> deleteVentComment(Comment comment) async {
    // await _firebaseFirestore.collection('vents').doc(ventDocId).delete();

    try {
      await _firebaseFirestore.runTransaction((transaction) async {
        DocumentSnapshot ventCommentSnapshot = await _firebaseFirestore
            .collection('vents/${comment.ventId}/ventComments')
            .doc(comment.id)
            .get();

        DocumentSnapshot freshUserSnapshot = await transaction
            .get(_firebaseFirestore.collection('users').doc(comment.userId));

        if (ventCommentSnapshot.exists) {
          transaction.delete(ventCommentSnapshot.reference);

          if (freshUserSnapshot.exists) {
            transaction.update(freshUserSnapshot.reference,
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
      VentCategory category,
      List<String> tags = const []}) async {
    try {
      await _firebaseFirestore.runTransaction((transaction) async {
        List<DocumentSnapshot> tagSnapshots = [];
        tags.forEach((tag) async {
          DocumentSnapshot freshTagSnapshot = await transaction
              .get(_firebaseFirestore.collection('tags').doc(tag));

          tagSnapshots.add(freshTagSnapshot);
        });

        DocumentSnapshot freshUserSnapshot = await transaction.get(
            _firebaseFirestore
                .collection('users')
                .doc(_firebaseAuth.currentUser.uid));

        DocumentSnapshot freshVentsSnapshot =
            await transaction.get(_firebaseFirestore.collection('vents').doc());
        transaction.set(freshVentsSnapshot.reference, {
          'userId': _firebaseAuth.currentUser.uid,
          'userName': _firebaseAuth.currentUser.displayName,
          'title': title,
          'vent': vent,
          'categoryId': category != null ? category.id : null,
          'categoryName': category != null ? category.name : null,
          'tags': tags,
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp()
        });
        tagSnapshots.forEach((tagSnapshot) async {
          if (tagSnapshot.exists) {
            transaction.update(
                tagSnapshot.reference, {'ventCount': FieldValue.increment(1)});
          } else {
            transaction.set(tagSnapshot.reference, {'ventCount': 1});
          }
        });

        if (freshUserSnapshot.exists) {
          transaction.update(freshUserSnapshot.reference,
              {'numVents': FieldValue.increment(1)});
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
      VentCategory category,
      List<String> tags = const []}) async {
    await _firebaseFirestore.collection('vents').doc(docId).update({
      'title': title,
      'vent': vent,
      'categoryId': category != null ? category.id : null,
      'tags': tags,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> deleteVent(Vent vent) async {
    // await _firebaseFirestore.collection('vents').doc(vent.id).delete();
    try {
      await _firebaseFirestore.runTransaction((transaction) async {
        List<DocumentSnapshot> tagSnapshots = [];
        vent.tags.forEach((tag) async {
          DocumentSnapshot freshTagSnapshot = await transaction
              .get(_firebaseFirestore.collection('tags').doc(tag));

          tagSnapshots.add(freshTagSnapshot);
        });
        DocumentSnapshot ventDocSnapshot = await transaction
            .get(_firebaseFirestore.collection('vents').doc(vent.id));
        DocumentSnapshot freshUserSnapshot = await transaction
            .get(_firebaseFirestore.collection('users').doc(vent.userId));
        if (ventDocSnapshot.exists) {
          transaction.delete(ventDocSnapshot.reference);

          tagSnapshots.forEach((tagSnapshot) async {
            if (tagSnapshot.exists) {
              if (tagSnapshot.get('ventCount') > 1) {
                transaction.update(tagSnapshot.reference,
                    {'ventCount': FieldValue.increment(-1)});
              } else {
                transaction.delete(tagSnapshot.reference);
              }
            }
          });

          if (freshUserSnapshot.exists) {
            transaction.update(freshUserSnapshot.reference,
                {'numVents': FieldValue.increment(-1)});
          }
        } else {
          print('document snapshot doesnt exist');
        }
      });
    } catch (e) {
      print(e);
    } finally {}
  }

  reportVent({String ventId}) async {
    _firebaseFirestore.collection('/reportedVents').add({
      'ventId': ventId,
      'userId': _firebaseAuth.currentUser != null
          ? _firebaseAuth.currentUser.uid
          : null,
      'createdAt': FieldValue.serverTimestamp()
    });
  }

  reportVentComment({String ventId, String commentId}) async {
    _firebaseFirestore.collection('/reportedVentComments').add({
      'ventId': ventId,
      'commentId': commentId,
      'userId': _firebaseAuth.currentUser != null
          ? _firebaseAuth.currentUser.uid
          : null,
      'createdAt': FieldValue.serverTimestamp()
    });
  }
}
