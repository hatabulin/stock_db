import 'package:flutter/material.dart';
import 'package:stockdb/ui/signin/signInPhonePage.dart';

/// Маршруты для навигации.
class UIRoutes {

  static const String signIn = '/signin';

  static Map<String, Widget Function(BuildContext)> getRoutes () {
    return <String, WidgetBuilder> {
      signIn: (BuildContext context) => SignInPhonePage(),
    };
  }
}
