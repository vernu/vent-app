import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vent/src/blocs/auth/auth_bloc.dart';

class SignupPage extends StatefulWidget {
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final GlobalKey<FormState> _signupFormKey = GlobalKey<FormState>();
  String name, email, password;

  @override
  void initState() {
    super.initState();
  }

  Widget build(context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sign up')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(8.0),
          children: [
            SizedBox(
              height: 20,
            ),
            Form(
              key: _signupFormKey,
              child: Column(children: [
                TextFormField(
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.account_circle,
                    ),
                    labelText: "Name",
                    hintText: "",
                  ),
                  validator: (val) {
                    if (val.isEmpty) {
                      return 'Please enter Name';
                    }
                    name = val;
                    return null;
                  },
                ),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.email,
                    ),
                    labelText: "Email",
                    hintText: "",
                  ),
                  validator: (val) {
                    if (val.isEmpty) {
                      return 'Please enter email';
                    }
                    email = val;
                    return null;
                  },
                ),
                TextFormField(
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.vpn_key,
                    ),
                    labelText: "Password",
                    hintText: "",
                  ),
                  validator: (val) {
                    if (val.isEmpty) {
                      return 'Please enter password';
                    }
                    if (val.length < 6) {
                      return 'Password cant be less than 6 characters';
                    }
                    password = val;
                    return null;
                  },
                ),
                TextFormField(
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.vpn_key,
                    ),
                    labelText: "Confirm Password",
                    hintText: "",
                  ),
                  validator: (val) {
                    if (val.isEmpty) {
                      return 'Please enter password';
                    }
                    if (val != password) {
                      return 'Passwords do not match';
                    }
                    password = val;
                    return null;
                  },
                ),
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    if (state is SignUpInProgress) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: CupertinoActivityIndicator(),
                        ),
                      );
                    }
                    return Row(
                      children: [
                        Expanded(
                          child: RaisedButton(
                              elevation: 4,
                              child: Text(
                                'Register',
                              ),
                              onPressed: () {
                                if (_signupFormKey.currentState.validate()) {
                                  context.read<AuthBloc>().add(
                                      SignUpWithPasswordRequested(
                                          email: email,
                                          password: password,
                                          name: name));
                                }
                              }),
                        ),
                      ],
                    );
                  },
                ),
              ]),
            )
          ],
        ),
      ),
    );
  }
}