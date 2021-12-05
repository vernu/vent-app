import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:vent/src/blocs/auth/auth_bloc.dart';

class SignupPage extends StatefulWidget {
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final GlobalKey<FormState> _signupFormKey = GlobalKey<FormState>();
  String name, email, phoneNumber, password;

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
            BlocListener<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state is AuthenticationSuccess) {
                  Navigator.popAndPushNamed(context, '/');
                }
                if (state is Unauthenticated) {
                  final snackBar = SnackBar(content: Text('Signup Failed!'));
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
              },
              child: Container(),
            ),
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
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    prefixText: '+251',
                    prefixIcon: Icon(
                      Icons.phone,
                    ),
                    labelText: "Phone no.",
                  ),
                  validator: (val) {
                    if (val.isEmpty) {
                      return 'Please enter phone no.';
                    } else if (val.length < 9) {
                      return 'invalid format';
                    }
                    phoneNumber = val;
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
                    return Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                  child: Text(
                                    'Register',
                                  ),
                                  onPressed: () {
                                    if (_signupFormKey.currentState
                                        .validate()) {
                                      context.read<AuthBloc>().add(
                                          SignUpWithPasswordRequested(
                                              email: email,
                                              phoneNumber: '+251$phoneNumber',
                                              password: password,
                                              name: name));
                                    }
                                  }),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                icon: Icon(FontAwesomeIcons.google),
                                onPressed: () {
                                  context
                                      .read<AuthBloc>()
                                      .add(SignInWithGoogleRequested());
                                },
                                label: Text('Continue with Google'),
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.red)),
                              ),
                            ),
                          ],
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
