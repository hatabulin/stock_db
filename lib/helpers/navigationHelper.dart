import 'package:flutter/material.dart';
import 'package:stockdb/constants/uiroutes.dart';

/// Методы для переходов между экранами/страницами.
class NavigationHelper {

  ///
  /// SignIn
  /// 
  static void toSignIn(BuildContext context) =>
      Navigator.of(context).pushNamedAndRemoveUntil(
        UIRoutes.signIn,
            (Route<dynamic> route) => false,
      );

  static void toSignInPhone(BuildContext context) =>
      Navigator.of(context).pushNamedAndRemoveUntil(
        UIRoutes.signInPhone,
            (Route<dynamic> route) => false,
//        arguments: SetPinCodeArguments(),
      );
}
