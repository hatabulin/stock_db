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

  static void homePage(BuildContext context) =>
      Navigator.of(context).pushNamedAndRemoveUntil(
        UIRoutes.homePage,
            (Route<dynamic> route) => false,
      );
}
