import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:vent/src/repository/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthRepository _authRepository = AuthRepository();
  StreamSubscription<User> _userSubscription;

  AuthBloc() : super(AuthInitial()) {
    _userSubscription = _authRepository.user.listen(
      (user) => add(AuthUserChanged(user)),
    );
  }

  @override
  Future<void> close() {
    _userSubscription?.cancel();
    return super.close();
  }

  @override
  Stream<AuthState> mapEventToState(
    AuthEvent event,
  ) async* {
    print(event);
    if (event is AuthUserChanged) {
      // User user = AuthRepository().getCurrentUser();
      if (event.user != null) {
        yield AuthenticationSuccess(user: event.user);
      } else {
        yield Unauthenticated();
      }
    } else if (event is SignInAnonymouslyRequested) {
      yield AuthenticationInProgress();
      UserCredential userCredential =
          await AuthRepository().signinAnonymously();
      yield AuthenticationSuccess(user: userCredential.user);
    } else if (event is SignInWithPasswordRequested) {
      yield AuthenticationInProgress();

      UserCredential userCredential = await AuthRepository()
          .signinWithPassword(email: event.email, password: event.password);

      if (userCredential != null) {
        yield AuthenticationSuccess(user: userCredential.user);
      } else {
        yield Unauthenticated();
      }
    } else if (event is SignInWithGoogleRequested) {
      yield AuthenticationInProgress();
      UserCredential userCredential = await AuthRepository().signinWithGoogle();
      if (userCredential != null) {
        yield AuthenticationSuccess(user: userCredential.user);
      } else {
        yield Unauthenticated();
      }
    } else if (event is SignInWithPhoneRequested) {
      var result = await AuthRepository().verifyPhone(event.phoneNumber);
      if (result == null) {
        //failed
      } else if (result is UserCredential) {
        //signin success
        yield AuthenticationSuccess(user: result.user);
      } else if (result is String) {
        //code sent
        yield AuthenticatingPhoneInProgress(verificationId: result);
      }
    } else if (event is PhoneVerificationCodeSubmitted) {
      UserCredential userCredential = await AuthRepository()
          .verifySMSCode(event.verificationId, event.smsCode);
      if (userCredential != null) {
        yield AuthenticationSuccess(user: userCredential.user);
      } else {
        yield Unauthenticated();
      }
    } else if (event is SignUpWithPasswordRequested) {
      yield SignUpInProgress();

      UserCredential userCredential = await AuthRepository()
          .signUpWithEmailAndPassword(event.email, event.password,
              name: event.name);

      if (userCredential != null) {
        yield AuthenticationSuccess(user: userCredential.user);
      } else {
        yield Unauthenticated();
      }
    } else if (event is SignOutRequested) {
      AuthRepository().signOut();
      yield Unauthenticated();
    } else {}
  }
}
