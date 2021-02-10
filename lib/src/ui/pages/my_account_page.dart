import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vent/src/blocs/auth/auth_bloc.dart';

class MyAccountPage extends StatefulWidget {
  _MyAccountPage createState() => _MyAccountPage();
}

class _MyAccountPage extends State<MyAccountPage> with AutomaticKeepAliveClientMixin {
  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
  }

  Widget build(context) {
    super.build(context);
    return BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
      if (state is AuthenticationSuccess)
        return ListView(
          padding: EdgeInsets.all(8),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(
                  CupertinoIcons.profile_circled,
                  size: 100,
                ),
                Expanded(
                  child: Column(
                    children: [
                      Text(
                          '${state.user.isAnonymous ? "Anonymous" : state.user.displayName}',
                          style: Theme.of(context).textTheme.headline5.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).accentColor)),
                      state.user.isAnonymous
                          ? SizedBox()
                          : FlatButton(
                              onPressed: () {}, child: Text('Edit Profile'))
                    ],
                  ),
                ),
                RaisedButton(
                  onPressed: () {
                    context.read<AuthBloc>().add(SignOutRequested());
                  },
                  child: Text('Sign out'),
                )
              ],
            ),
            SizedBox(height: 10),
            Divider(),
            SizedBox(height: 10),
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
          ],
        );
    });
  }

  @override
  bool get wantKeepAlive => false;
}
