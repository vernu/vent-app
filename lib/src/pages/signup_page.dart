import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SignupPage extends StatefulWidget {
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GlobalKey<FormState> _signupFormKey = GlobalKey<FormState>();
  String name, email, password;
  bool _isRegistering = false;

  @override
  void initState() {
    super.initState();
  }

  Widget build(context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sign up')),
      body: SafeArea(
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: _signupFormKey,
                child: Column(children: [
                  TextFormField(
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.account_circle,
                        color: Theme.of(context).primaryColor,
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
                        color: Theme.of(context).primaryColor,
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
                        color: Theme.of(context).primaryColor,
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
                        color: Theme.of(context).primaryColor,
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
                  _isRegistering
                      ? CircularProgressIndicator()
                      : RaisedButton(
                          color: Theme.of(context).primaryColor,
                          elevation: 4,
                          child: Text(
                            'Register',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            if (_signupFormKey.currentState.validate()) {
                              _register();
                            }
                          }),
                ]),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _register() async {
    setState(() {
      _isRegistering = true;
    });

    try {
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      userCredential.user.sendEmailVerification();
      await userCredential.user.updateProfile(displayName: name);
    } on FirebaseAuthException catch (e) {
      print(e.code);
      if (e.code == 'weak-password') {
      } else if (e.code == 'email-already-in-use') {}
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        _isRegistering = false;
      });
    }
  }
}
