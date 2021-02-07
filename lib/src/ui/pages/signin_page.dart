import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vent/src/blocs/auth/auth_bloc.dart';

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
      padding: EdgeInsets.all(8),
      children: [
        SizedBox(
          height: 20,
        ),
        Text(
          'Sign in',
          style: Theme.of(context).textTheme.headline4,
        ),
        SizedBox(
          height: 10,
        ),
        Form(
          key: _signinFormKey,
          child: Column(children: [
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

                password = val;
                return null;
              },
            ),
            Row(
              children: [
                FlatButton(
                  onPressed: () {},
                  child: Text('Forgot Password?'),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) {
                    print(state.toString());
                    if (state is AuthenticationInProgress)
                      return Center(child: CupertinoActivityIndicator());

                    return RaisedButton(
                        elevation: 4,
                        child: Text(
                          'Sign in',
                        ),
                        onPressed: () {
                          if (_signinFormKey.currentState.validate()) {
                            context.read<AuthBloc>().add(
                                SignInWithPasswordRequested(
                                    email: email, password: password));
                          }
                        });
                  }),
                ),
              ],
            ),
          ]),
        ),
        Padding(
          padding: const EdgeInsets.all(24.0),
          child: RichText(
            text: TextSpan(
                text: "Don't have an account?  ",
                children: [
                  TextSpan(
                      text: 'Register',
                      style: TextStyle(
                          fontSize: 18,
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.bold),
                      recognizer: new TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.pushNamed(context, '/sign_up');
                        })
                ],
                style: Theme.of(context).textTheme.bodyText1),
          ),
        ),

        Center(child: Text('OR')),

        RaisedButton(
          onPressed: () =>
              context.read<AuthBloc>().add(SignInAnonymouslyRequested()),
          child: Text('Sign in with Anonymously'),
        ),
        RaisedButton(
          onPressed: () => {showPhoneSigninDialog()},
          child: Text('Sign in with phone'),
        ),
        RaisedButton(
          onPressed: () {
            context.read<AuthBloc>().add(SignInWithGoogleRequested());
          },
          child: Text('Sign in with Google'),
        ),
        // RaisedButton(
        //   onPressed: () async {
        //     final AccessToken accessToken = await FacebookAuth.instance.login();
        //     FacebookAuthCredential facebookAuthCredential =
        //         FacebookAuthProvider.credential(accessToken.token);
        //     await _firebaseAuth.signInWithCredential(facebookAuthCredential);
        //   },
        //   child: Text('Sign in with Facebook'),
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
