import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthRepository {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  GoogleSignIn _googleSignIn = GoogleSignIn();

  Stream<User> get user {
    return _firebaseAuth.authStateChanges().map((firebaseUser) {
      return firebaseUser;
    });
  }

  // User getCurrentUser() {
  //   User user = _firebaseAuth.currentUser;
  //   return user;
  // }

  Future<UserCredential> signinAnonymously() async {
    return await _firebaseAuth.signInAnonymously();
  }

  Future<UserCredential> signinWithPassword({email, password}) async {
    UserCredential userCredential;
    String errorMessage;
    try {
      userCredential = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      errorMessage = e.code;
      // print(e.code);
      // if (e.code == 'user-not-found') {
      // } else if (e.code == 'invalid-email') {
      // } else if (e.code == 'wrong-password') {
      // }
    } catch (e) {
      print(e);
    } finally {}
    return userCredential;
  }

  Future<UserCredential> signinWithGoogle() async {
    UserCredential userCredential;
    try {
      final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final GoogleAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      if (userCredential.additionalUserInfo.isNewUser) {
        _storeUserData(
            name: userCredential.user.displayName,
            email: userCredential.user.email);
      }
    } catch (e) {
      print(e.toString());
    } finally {}
    return userCredential;
  }

  Future<dynamic> verifyPhone(String phoneNumber) async {
    await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (phoneAuthCredential) async {
          UserCredential userCredential =
              await _firebaseAuth.signInWithCredential(phoneAuthCredential);
          if (userCredential.additionalUserInfo.isNewUser) {
            _storeUserData(phoneNumber: phoneNumber);
          }
          return userCredential;
        },
        verificationFailed: (FirebaseAuthException firebaseAuthException) {
          print(firebaseAuthException.message);
          return null;
        },
        codeSent: (verificationId, resendToken) {
          // _smsCodeEntryDialog();
          return verificationId;
        },
        codeAutoRetrievalTimeout: (verificationId) => {});
  }

  Future<UserCredential> verifySMSCode(phoneVerificationId, smsCode,
      {String name, phoneNumber}) async {
    UserCredential userCredential;
    PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
        verificationId: phoneVerificationId, smsCode: smsCode);
    userCredential =
        await _firebaseAuth.signInWithCredential(phoneAuthCredential);
    if (userCredential == null) {
      //wrong sms code
    }
    if (userCredential.additionalUserInfo.isNewUser) {
      await userCredential.user.updateDisplayName(name);
      //update name email phoneNumber,
      await _storeUserData(name: name, phoneNumber: phoneNumber);
    }
    return userCredential;
  }

  Future<void> signOut() async {
    if (_firebaseAuth.currentUser.isAnonymous) {
      await _firebaseAuth.currentUser.delete();
    } else {
      if (await _googleSignIn.isSignedIn()) {
        await _googleSignIn.disconnect();
        await _googleSignIn.signOut();
      }
      await _firebaseAuth.signOut();
    }
  }

  signUpWithEmailAndPassword(email, phoneNumber, password,
      {@required String name}) async {
    UserCredential userCredential;
    try {
      userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      userCredential.user.sendEmailVerification();
      await userCredential.user.updateDisplayName(name);
    } on FirebaseAuthException catch (e) {
      print(e.code);
      if (e.code == 'weak-password') {
      } else if (e.code == 'email-already-in-use') {}
    } catch (e) {
      print(e);
    } finally {
      _storeUserData(name: name, phoneNumber: phoneNumber, email: email);
    }
    return userCredential;
  }

  //store users data to users collection
  _storeUserData({String name, String email, String phoneNumber}) async {
    DocumentReference docRef = _firebaseFirestore
        .collection('users')
        .doc(_firebaseAuth.currentUser.uid);
    DocumentSnapshot docSnapshot = await docRef.get();
    if (!docSnapshot.exists) {
      await docRef.set({
        'name': name,
        'email': email,
        'phone': phoneNumber,
        'createdAt': _firebaseAuth.currentUser.metadata.creationTime,
      });
    }
  }
}
