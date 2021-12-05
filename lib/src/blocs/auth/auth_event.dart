part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent {}

class AuthUserChanged extends AuthEvent {
  final User user;
  AuthUserChanged(this.user);
}

class SignInAnonymouslyRequested extends AuthEvent {}

class SignInWithPasswordRequested extends AuthEvent {
  final String email, password;
  SignInWithPasswordRequested({@required this.email, @required this.password});
}

class SignInWithGoogleRequested extends AuthEvent {}

class SignInWithPhoneRequested extends AuthEvent {
  final String phoneNumber;
  SignInWithPhoneRequested({@required this.phoneNumber});
}

class PhoneVerificationCodeSubmitted extends AuthEvent {
  final String verificationId;
  final String smsCode;
  PhoneVerificationCodeSubmitted(
      {@required this.verificationId, @required this.smsCode});
}

class SignUpWithPasswordRequested extends AuthEvent {
  final String email, phoneNumber, password, name;
  SignUpWithPasswordRequested(
      {@required this.email, @required this.phoneNumber, @required this.password, this.name});
}


class SignOutRequested extends AuthEvent {}
