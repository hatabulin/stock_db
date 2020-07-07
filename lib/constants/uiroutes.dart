import 'package:flutter/material.dart';
import 'package:stockdb/login/loginPage.dart';
import 'package:stockdb/ui/signin/signInCodePage.dart';
import 'package:stockdb/ui/signin/signInPhonePage.dart';
import 'package:stockdb/ui/signin/signInWelcomePage.dart';

/// Маршруты для навигации.
class UIRoutes {

  static const String signIn = '/signin';
  static const String signInPhone = '/signin/signInPhone';
  static const String signInCode = '/signin/signInCode';
  static const String loginPage = '/login/loginPage';

  static Map<String, Widget Function(BuildContext)> getRoutes () {
    return <String, WidgetBuilder> {
      signIn: (BuildContext context) => SignInWelcomePage(),
      signInPhone: (BuildContext context) => SignInPhonePage(),
      signInCode: (BuildContext context) => SignInCodePage(),
      loginPage: (BuildContext context) => LoginPage(),
    };
  }
}
