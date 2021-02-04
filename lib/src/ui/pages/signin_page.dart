import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vent/src/blocs/auth/auth_bloc.dart';
import 'package:vent/src/ui/pages/signup_page.dart';

class SiginPage extends StatefulWidget {
  _SigninPageState createState() => _SigninPageState();
}

class _SigninPageState extends State<SiginPage> {
  final _signinFormKey = GlobalKey<FormState>();
  final _phoneVerificationFormKey = GlobalKey<FormState>();
  String name, email, password, phoneNumber;
  String smsCode;

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
            BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                print(state.toString());
                if (state is AuthenticationInProgress)
                  return CircularProgressIndicator();

                return RaisedButton(
                    color: Theme.of(context).primaryColor,
                    elevation: 4,
                    child: Text(
                      'Sign in',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      if (_signinFormKey.currentState.validate()) {
                        context.read<AuthBloc>().add(
                            SignInWithPasswordRequested(
                                email: email, password: password));
                      }
                    });
              },
            ),
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
                        Navigator.pushNamed(context, '/sign_up');
                      })
              ]),
        ),

        RaisedButton(
          onPressed: () =>
              context.read<AuthBloc>().add(SignInAnonymouslyRequested()),
          child: Text('Sigin with Anonymously'),
        ),
        RaisedButton(
          onPressed: () => {showPhoneSigninDialog()},
          child: Text('Sigin with phone'),
        ),
        RaisedButton(
          onPressed: () {
            context.read<AuthBloc>().add(SignInWithGoogleRequested());
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
        BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthenticatingPhoneInProgress) {
              smsCodeEntryDialog(state.verificationId);
            }
          },
          child: Container(),
        )
      ],
    );
  }

  void showPhoneSigninDialog() {
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
                        BlocBuilder<AuthBloc, AuthState>(
                          builder: (context, state) {
                            if (state is AuthenticationInProgress) {
                              return CircularProgressIndicator();
                            }
                            return RaisedButton(
                                onPressed: () async {
                                  if (_phoneVerificationFormKey.currentState
                                      .validate()) {
                                    context.read<AuthBloc>().add(
                                        SignInWithPhoneRequested(
                                            phoneNumber: phoneNumber));

                                    Navigator.pop(context);
                                  }
                                },
                                child: Text('Continue'));
                          },
                        )
                      ]),
                    ],
                  )),
            ],
          );
        });
  }

  void smsCodeEntryDialog(verificationId) {
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
                    BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) {
                        // if(state is WaitingForPhoneVerificationCode){
                        //   return CircularProgressIndicator();
                        // }
                        return RaisedButton(
                            onPressed: () {
                              context.read<AuthBloc>().add(
                                  PhoneVerificationCodeSubmitted(
                                      verificationId: verificationId,
                                      smsCode: smsCode));
                            },
                            child: Text('Continue'));
                      },
                    )
                  ]),
                ],
              )),
            ],
          );
        });
  }
}
