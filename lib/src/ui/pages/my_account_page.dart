import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vent/src/blocs/auth/auth_bloc.dart';

class MyAccountPage extends StatefulWidget {
  _MyAccountPage createState() => _MyAccountPage();
}

class _MyAccountPage extends State<MyAccountPage> {
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
        BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            return RaisedButton(
              onPressed: () {
                context.read<AuthBloc>().add(SignOutRequested());
              },
              child: Text('Sign out'),
            );
          },
        )
      ],
    );
  }
}
