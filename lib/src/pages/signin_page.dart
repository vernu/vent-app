import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SiginPage extends StatefulWidget {
  _SigninPageState createState() => _SigninPageState();
}

class _SigninPageState extends State<SiginPage> {
  @override
  void initState() {
    super.initState();
  }

  Widget build(context) {
    return ListView(
      children: [
        RaisedButton(
          onPressed: () {},
          child: Text('Sigin with phone'),
        )
      ],
    );
  }

  Future _verifyUser(String phoneNumber, BuildContext context) async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (credential) =>
            {onVerificationCompleted(credential)},
        verificationFailed: (e) => {onVerificationFailed(e)},
        codeSent: (str, i) => {print(str)},
        codeAutoRetrievalTimeout: (str) => {print(str)});
  }

  void onVerificationCompleted(PhoneAuthCredential phoneAuthCredential) {
    print(phoneAuthCredential.providerId);
  }

  void onVerificationFailed(FirebaseAuthException firebaseAuthException) {
    print(firebaseAuthException.message);
  }
}
