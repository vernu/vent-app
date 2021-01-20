import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class MyAccountPage extends StatefulWidget {
  _SigninPageState createState() => _SigninPageState();
}

class _SigninPageState extends State<MyAccountPage> {
  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
  }

  Widget build(context) {
    return ListView(
      children: [
        Text('id: ${_auth.currentUser.uid}'),
        Text('name: ${_auth.currentUser.displayName}'),
        Text('email: ${_auth.currentUser.email}'),
        Text('phone: ${_auth.currentUser.phoneNumber}'),
        Text(
            'createdAt: ${_auth.currentUser.metadata.creationTime.toIso8601String()}'),
        Text('providerData: ${_auth.currentUser.providerData.toString()}'),
        _auth.currentUser.isAnonymous
            ? RaisedButton(
                onPressed: () async {
                  await _auth.currentUser.delete();
                },
                child: Text('Delete Anonymous account'),
              )
            : Container(),
        RaisedButton(
          onPressed: () async {
            await _auth.currentUser.updateEmail('test@test.com');
            await _auth.currentUser.updateProfile(displayName: 'test acc');
          },
          child: Text('Update'),
        ),
        _auth.currentUser.emailVerified
            ? Container()
            : RaisedButton(
                onPressed: () async {
                  await _auth.currentUser.sendEmailVerification();
                },
                child: Text('Verify email'),
              ),
        RaisedButton(
          onPressed: () async {
            if (_auth.currentUser.isAnonymous) {
              await _auth.currentUser.delete();
            } else {
              GoogleSignIn _googleSignIn = GoogleSignIn();

              if (await _googleSignIn.isSignedIn()) {
                await _googleSignIn.disconnect();
                await _googleSignIn.signOut();
              }
              await _auth.signOut();
            }
          },
          child: Text('Sign out'),
        )
      ],
    );
  }
}
