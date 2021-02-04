import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vent/src/blocs/auth/auth_bloc.dart';
import 'package:vent/src/ui/pages/my_account_page.dart';
import 'package:vent/src/ui/pages/signin_page.dart';

class AccountPage extends StatefulWidget {
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  Widget build(context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
      },
      builder: (context, state) {
        print(state.toString());
        if (state is AuthInitial) {
          return Center(child: CircularProgressIndicator());
        } else if (state is AuthenticationSuccess) {
          return MyAccountPage();
        } else {
          return SiginPage();
        }
      },
    );
  }
}
