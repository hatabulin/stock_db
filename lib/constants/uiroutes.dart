import 'package:flutter/material.dart';
import 'package:stockdb/ui/home/homePage.dart';
import 'package:stockdb/ui/signin/signInPhonePage.dart';

/// Маршруты для навигации.
class UIRoutes {

  static const String signIn = '/signin';
  static const String homePage = '/homePage';

  static Map<String, Widget Function(BuildContext)> getRoutes () {
    return <String, WidgetBuilder> {
      signIn: (BuildContext context) => SignInPhonePage(),
      homePage: (BuildContext context) => HomePage(),
    };
  }
}
