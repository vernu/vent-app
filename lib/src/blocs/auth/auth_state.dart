part of 'auth_bloc.dart';

@immutable
abstract class AuthState extends Equatable {
  const AuthState();
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}
class Unauthenticated extends AuthState {}

class AuthenticationSuccess extends AuthState {
  final User user;
  const AuthenticationSuccess({@required this.user});
  @override
  List<Object> get props => [user.uid];
}
class AuthenticationInProgress extends AuthState{}
class AuthenticatingPhoneInProgress extends AuthState{
  final String verificationId;
  AuthenticatingPhoneInProgress({@required this.verificationId});

}

class SignUpInProgress extends AuthState {}

// class AuthLogoutRequested extends AuthState{}
