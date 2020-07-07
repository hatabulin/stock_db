import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class SignInPhoneBloc {

  static  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final _streamController = StreamController<SignInState>();
  Stream<SignInState> get stream => _streamController.stream;

  static String _status;
//  AuthCredential _phoneAuthCredential;
  static String _verificationId = "";
  static String  _code;

  Future<void> initState() async {

//    if (!_streamController.isClosed)
//      _streamController.sink.add(SignInState._loading());
    if (!_streamController.isClosed)
      _streamController.sink.add(SignInState._enter());
//    if (!_streamController.isClosed)
//      _streamController.sink.add(RoutesState._loading());
  }

  void dispose() {
    _streamController.close();
  }

  //
  // Listeners
  //
  static PhoneCodeSent codeSentListener = (String verificationId, [int forceResendingToken]) async {
    _verificationId = verificationId;
    print("codeSentListener. verificationId " + verificationId);
  };

  static PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeoutListener = (String verificationId) {
    _verificationId = verificationId;
    print("codeAutoRetrievalTimeoutListener. Auto retrieval time out");
  };

  static PhoneVerificationCompleted verificationCompletedListener = (AuthCredential auth) {
    print("verificationCompletedListener Auto retrieving verification code");
    signInWithCredential(auth);
  };

  static PhoneVerificationFailed verificationFailedListener = (AuthException authException) {
    print("verificationFailedListener. ${authException.message}");
    if (authException.message.contains('not authorized')){
      print("verificationFailedListener. Something has gone wrong, please try later");
    } else if (authException.message.contains('Network')){
      print("verificationFailedListener. Please check your internet connection and try again");
    } else{
      print("verificationFailedListener. Something has gone wrong, please try later");
    }
  };

  Future<void> enterPhone() async {
    _streamController.sink.add(SignInState._phone());
  }

  Future<void> enterCode() async {
    _streamController.sink.add(SignInState._code());
  }

  Future<void> signIn(String phone) async {
    if (!_streamController.isClosed)
      _streamController.sink.add(SignInState._loading());

    firebaseAuth.verifyPhoneNumber(
        phoneNumber: "+380505166993",
        timeout: Duration(milliseconds: 10000),
        verificationCompleted: verificationCompletedListener,
        verificationFailed: verificationFailedListener,
        codeSent: codeSentListener,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeoutListener);
  }

  Future <void> _signInWithCode() async {
    AuthCredential auth = PhoneAuthProvider.getCredential(verificationId: _verificationId, smsCode: _code);
    signInWithCredential(auth );
  }

  static signInWithCredential(AuthCredential auth){
    firebaseAuth.signInWithCredential(auth).then((AuthResult value) {
      if (value.user != null) {
        print("signInWithCredential successful,"  );
      } else {
        print("signInWithCredential Invalid code/invalid authentication");
      }
    }).catchError((error) {
      print("signInWithCredential wrong, please try late " + error.toString());
    });
  }
}

class SignInState {
  SignInState();

  factory SignInState._init() = SignInInitState;

  factory SignInState._loading() = SignInLoadingState;

  factory SignInState._enter() = SignInEnterState;

  factory SignInState._phone() = SignInPhoneState;

  factory SignInState._code() = SignInCodeState;

  factory SignInState._success() = SignInSuccessState;

  factory SignInState._error(String error) = SignInErrorState;
}

class SignInInitState extends SignInState {}

class SignInLoadingState extends SignInState {}

class SignInEnterState extends SignInState {}

class SignInPhoneState extends SignInState {}

class SignInCodeState extends SignInState {}

class SignInSuccessState extends SignInState {}

class SignInErrorState extends SignInState {
  final String error;

  SignInErrorState(this.error);
}
