import 'dart:async';
//import 'package:stockdb/services/authentication.dart';

class SignInBloc {
  final _streamController = StreamController<SignInState>();
  Stream<SignInState> get stream => _streamController.stream;

  // Авторизация пользователя и получение токена
  Future<void> login(String user, String password) async {
    if (!_streamController.isClosed) _streamController.sink.add(SignInState._loading());
    String userId = "";
//    userId = await auth.signIn(user, password);
    print('Signed in: $userId');
  }
  

  void dispose() {
    _streamController.close();
  }
}


class SignInState {
  SignInState();
  factory SignInState._init() = SignInInitState;
  factory SignInState._loading() = SignInLoadingState;
  factory SignInState._success() = SignInSuccessState;
  factory SignInState._error(String error) = SignInErrorState;
}

class SignInInitState extends SignInState {}

class SignInLoadingState extends SignInState {}

class SignInSuccessState extends SignInState {}

class SignInErrorState extends SignInState {
  final String error;
  SignInErrorState(this.error);
}