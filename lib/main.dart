import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'authenticate/authentication_bloc.dart';
import 'authenticate/authentication_event.dart';
import 'authenticate/authentication_state.dart';
import 'constants/uiroutes.dart';
import 'constants/uistrings.dart';
import 'constants/uithemes.dart';
import 'data/user_repository.dart';
import 'login/loginPage.dart';
import 'ui/splash/splash_page.dart';
import 'ui/userdetail/edit_user_detail.dart';

class SimpleBlocDelegate extends BlocDelegate {
  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print(transition.toString());
  }

  @override
  void onError(Bloc bloc, Object error, StackTrace stacktrace) {
    super.onError(bloc, error, stacktrace);
    print(error);
  }

  @override
  void onEvent(Bloc bloc, Object event) {
    super.onEvent(bloc, event);
    print(event);
  }
}

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

  WidgetsFlutterBinding.ensureInitialized();
  BlocSupervisor.delegate = SimpleBlocDelegate();
  UserRepository userRepository = UserRepository();
  runApp(BlocProvider(
    create: (context) => AuthenticationBloc(userRepository)..add(AppStarted()),
    child: MyApp(userRepository: userRepository),
  ));
//  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  final UserRepository _userRepository;

  MyApp({Key key, @required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  UserRepository get userRepository => widget._userRepository;
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: UIStrings.app_title,
        theme: UIThemes.mainTheme,
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state is Uninitialized) {
            return SplashPage();
          } else if (state is Unauthenticated) {
            return LoginPage(
              userRepository: userRepository,
            );
          } else if (state is Authenticated) {
            return EditUserDetail();
          } else {
            return SplashPage();
          }
          ;
        },
      ),
//        initialRoute: UIRoutes.signIn,
//        initialRoute: UIRoutes.loginPage,
//        routes: UIRoutes.getRoutes(),
    );
  }
}