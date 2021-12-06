import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';
import 'package:time_formatter/time_formatter.dart';
import 'package:vent/src/blocs/auth/auth_bloc.dart';

class MyAccountPage extends StatefulWidget {
  _MyAccountPage createState() => _MyAccountPage();
}

class _MyAccountPage extends State<MyAccountPage>
    with AutomaticKeepAliveClientMixin {
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
                              color: Theme.of(context).colorScheme.secondary)),
                      state.user.isAnonymous
                          ? SizedBox()
                          : FlatButton(
                              onPressed: () {}, child: Text('Edit Profile'))
                    ],
                  ),
                ),
                ElevatedButton(
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
            Text('phone: ${_auth.currentUser.phoneNumber ?? ''}'),
            Text(
                'signed up: ${formatTime(_auth.currentUser.metadata.creationTime.millisecondsSinceEpoch)}'),
            _auth.currentUser.isAnonymous
                ? ElevatedButton(
                    onPressed: () async {
                      await _auth.currentUser.delete();
                    },
                    child: Text('Delete Anonymous account'),
                  )
                : Container(),
            // RaisedButton(
            //   onPressed: () async {
            //     await _auth.currentUser.updateEmail('test@test.com');
            //     await _auth.currentUser.updateProfile(displayName: 'test acc');
            //   },
            //   child: Text('Update'),
            // ),
            _auth.currentUser.emailVerified
                ? Container()
                : ElevatedButton(
                    onPressed: () async {
                      await _auth.currentUser.sendEmailVerification();
                    },
                    child: Text('Verify email'),
                  ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/vents',
                    arguments: {'userId': _auth.currentUser.uid});
              },
              child: Text('My Vents'),
            ),
            ElevatedButton(
              onPressed: () {
                Share.share(
                    'check out this cool vent app https://play.google.com/store/apps/details?id=com.vernu.vent');
              },
              child: Text('invite a friend'),
            ),
          ],
        );
      else
        return CircularProgressIndicator();
    });
  }

  @override
  bool get wantKeepAlive => false;
}
