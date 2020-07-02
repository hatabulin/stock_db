import 'package:flutter/material.dart';

import '../ui/signin/signInPage.dart';

/// Маршруты для навигации.
class UIRoutes {

  static const String signIn = '/signin';
  static const String usePinCode = '/signin/usepincode';


  static Map<String, Widget Function(BuildContext)> getRoutes () {
    return <String, WidgetBuilder> {
      signIn: (BuildContext context) => SignInPage(),
      usePinCode: (BuildContext context) => SignInPage(), //UsePinCodePage(),
    };
  }
}
