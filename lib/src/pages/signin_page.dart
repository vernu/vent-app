import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:vent/src/pages/signup_page.dart';

class SiginPage extends StatefulWidget {
  _SigninPageState createState() => _SigninPageState();
}

class _SigninPageState extends State<SiginPage> {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final _signinFormKey = GlobalKey<FormState>();
  final _phoneVerificationFormKey = GlobalKey<FormState>();
  String name, email, password, phoneNumber;
  bool _isSigningIn = false;
  bool isVerifyingPhone = false;
  bool isSendingSmsCode = false;
  bool smsCodeSent = false;
  String smsCode;
  String phoneVerificationId;

  @override
  void initState() {
    super.initState();
  }

  Widget build(context) {
    return ListView(
      children: [
        Form(
          key: _signinFormKey,
          child: Column(children: [
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

                password = val;
                return null;
              },
            ),
            _isSigningIn
                ? CircularProgressIndicator()
                : RaisedButton(
                    color: Theme.of(context).primaryColor,
                    elevation: 4,
                    child: Text(
                      'Sign in',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      if (_signinFormKey.currentState.validate()) {
                        _signin();
                      }
                    }),
          ]),
        ),
        RichText(
          text: new TextSpan(
              text: "Don't have an account? ",
              style: TextStyle(fontSize: 16, color: Colors.black),
              children: [
                new TextSpan(
                    text: 'Register',
                    style: TextStyle(
                        fontSize: 18,
                        color: Theme.of(context).primaryColor,
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.bold),
                    recognizer: new TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (context) => SignupPage()));
                      })
              ]),
        ),

        RaisedButton(
          onPressed: () => {_firebaseAuth.signInAnonymously()},
          child: Text('Sigin with Anonymously'),
        ),
        RaisedButton(
          onPressed: () => {_phoneSigninDialog()},
          child: Text('Sigin with phone'),
        ),
        RaisedButton(
          onPressed: () {
            _signinWithGoogle();
          },
          child: Text('Sigin with Google'),
        ),
        // RaisedButton(
        //   onPressed: () async {
        //     final AccessToken accessToken = await FacebookAuth.instance.login();
        //     FacebookAuthCredential facebookAuthCredential =
        //         FacebookAuthProvider.credential(accessToken.token);
        //     await _firebaseAuth.signInWithCredential(facebookAuthCredential);
        //   },
        //   child: Text('Sigin with Facebook'),
        // ),
      ],
    );
  }

  void _signin() async {
    setState(() {
      _isSigningIn = true;
    });

    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      print(e.code);
      if (e.code == 'user-not-found') {
      } else if (e.code == 'invalid-email') {
      } else if (e.code == 'wrong-password') {}
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        _isSigningIn = false;
      });
    }
  }

  void _signinWithGoogle() async {
    try {
      final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final GoogleAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      if (userCredential.additionalUserInfo.isNewUser) {
        _storeUserData(
            userCredential.user.displayName, userCredential.user.email, null);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future _verifyPhone(String phoneNumber, BuildContext context) async {
    setState(() {
      isVerifyingPhone = true;
    });

    await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (phoneAuthCredential) =>
            {onVerificationCompleted(phoneAuthCredential)},
        verificationFailed: (e) => {onVerificationFailed(e)},
        codeSent: (verificationId, resendToken) {
          // print('code sent');
          setState(() {
            smsCodeSent = true;
            phoneVerificationId = verificationId;
          });

          _smsCodeEntryDialog();
        },
        codeAutoRetrievalTimeout: (verificationId) => {});
    setState(() {
      isVerifyingPhone = false;
    });
  }

  void onVerificationCompleted(PhoneAuthCredential phoneAuthCredential) async {
    UserCredential userCredential =
        await _firebaseAuth.signInWithCredential(phoneAuthCredential);
    if (userCredential.additionalUserInfo.isNewUser) {
      _storeUserData(null, null, phoneNumber);
    }
  }

  void onVerificationFailed(FirebaseAuthException firebaseAuthException) {
    print(firebaseAuthException.message);
  }

  void _phoneSigninDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            titlePadding: EdgeInsets.all(2),
            contentPadding: EdgeInsets.all(8),
            elevation: 8,
            title: Text('Enter your name and phone number'),
            children: [
              Form(
                  key: _phoneVerificationFormKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      TextFormField(
                        keyboardType: TextInputType.name,
                        decoration:
                            InputDecoration(labelText: 'Name', hintText: ''),
                        validator: (val) {
                          if (val.isEmpty) {
                            return 'please enter a name';
                          }

                          name = val;
                          return null;
                        },
                      ),
                      TextFormField(
                        keyboardType: TextInputType.phone,
                        initialValue: '+251',
                        decoration: InputDecoration(
                            labelText: 'Phone Number',
                            hintText: '+251912345678'),
                        validator: (val) {
                          if (val.isEmpty) {
                            return 'please enter a valid phone number';
                          }
                          if (val.length < 10) {
                            return 'phone number cant be less than 10 digits';
                          }
                          phoneNumber = val;
                          return null;
                        },
                      ),
                      Row(children: [
                        isVerifyingPhone
                            ? CircularProgressIndicator()
                            : RaisedButton(
                                onPressed: () async {
                                  if (_phoneVerificationFormKey.currentState
                                      .validate()) {
                                    await _verifyPhone(phoneNumber, context);
                                    Navigator.pop(context);
                                  }
                                },
                                child: Text('Continue'))
                      ]),
                    ],
                  )),
            ],
          );
        });
  }

  void _smsCodeEntryDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            titlePadding: EdgeInsets.all(2),
            contentPadding: EdgeInsets.all(8),
            elevation: 8,
            title: Text('Enter the sms code you received'),
            children: [
              Form(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                        labelText: 'Verification Code', hintText: ''),
                    onChanged: (val) {
                      setState(() {
                        smsCode = val;
                      });
                    },
                  ),
                  Row(children: [
                    isSendingSmsCode
                        ? CircularProgressIndicator()
                        : RaisedButton(
                            onPressed: () async {
                              setState(() {
                                isSendingSmsCode = true;
                              });
                              PhoneAuthCredential phoneAuthCredential =
                                  PhoneAuthProvider.credential(
                                      verificationId: phoneVerificationId,
                                      smsCode: smsCode);
                              UserCredential userCredential =
                                  await _firebaseAuth.signInWithCredential(
                                      phoneAuthCredential);
                              if (userCredential.additionalUserInfo.isNewUser) {
                                await userCredential.user.updateProfile(displayName: name);
                                //update name email phoneNumber,
                                await _storeUserData(name, null, phoneNumber);
                              }
                              setState(() {
                                isSendingSmsCode = true;
                              });
                              Navigator.pop(context);
                            },
                            child: Text('Continue'))
                  ]),
                ],
              )),
            ],
          );
        });
  }

  //store users data to user collection
  _storeUserData(name, email, phoneNumber) async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    DocumentReference docRef = firebaseFirestore
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
