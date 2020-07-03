import 'package:flutter/material.dart';

class UIThemes {

  // Основная тема приложения
  static ThemeData mainTheme = ThemeData(
    fontFamily: "SF Pro Display",
    scaffoldBackgroundColor: Color(0xff03FFFFFF)
  );

  static const black = Color(0xFF000000);
  static const transparent = Color(0x00000000);
  static const primaryColor = Color(0xff4a4fed);
  static const primaryContrastingColor = backgroundColor;
  static const backgroundColor = Color(0xFFffffff);
  static const backgroundHalfContrastingColor = Color(0xFFc3c3c7);
  static const backgroundContrastingColor = Color(0xFF242a42);
  static const accentColor = Color(0xFF43cea2);
  static const accentColorShadow = Color(0x8031c77f);
  static const backgroundSecondaryColor = Color(0xFF757d9c);


  static const buttonPrimaryColor = Color(0xff43cea2);
  static const buttonSecondaryColor = Color(0xff8f99bf);
  static const loginTextColor = Color(0xff242a42);
  static const menuBgColorStart = Color.fromRGBO(17, 28, 95, 1.0);
  static const menuBgColorEnd = Color.fromRGBO(2, 9, 53, 1.0);
  static const pinLoginColor = Color.fromRGBO(165, 172, 218, 1.0);
  static const buttonBackgroundColor = Color(0xFFe3e3ec);
  static const errorColor = Color(0xFFea568a);

  // login
  static TextStyle loginHeaderTextStyle() =>
      TextStyle(
        color: backgroundHalfContrastingColor,
        fontSize: 35.0,
      );

  static TextStyle loginTextTextStyle() =>
      TextStyle(
        color: backgroundHalfContrastingColor,
        fontSize: 20.0,
      );

  static TextStyle loginFlatButtonTextStyle() =>
      TextStyle(
        color: backgroundHalfContrastingColor,
        fontSize: 15.0,
      );

  // common
  static TextStyle pageTitleTextStyle() =>
      TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
      );

  static TextStyle button16TextStyle() =>
      TextStyle(
        color: Colors.white,
        fontSize: 16.0,
      );

  static TextStyle button12TextStyle() =>
      TextStyle(
        color: Colors.white,
        fontSize: 12.0,
      );

  // normal
  static TextStyle normal20TextStyle() =>
      TextStyle(
        color: Colors.black,
        fontSize: 20.0,
      );

  static TextStyle normal16TextStyle() =>
      TextStyle(
        color: Colors.black,
        fontSize: 16.0,
      );

  static TextStyle normal14TextStyle() =>
      TextStyle(
        color: Colors.black,
        fontSize: 14.0,
      );

  static TextStyle normal12TextStyle() =>
      TextStyle(
        color: Colors.black,
        fontSize: 12.0,
      );

  // home
  static TextStyle balanceTextStyle() =>
      TextStyle(
        color: Colors.black,
        fontSize: 40.0,
        fontWeight: FontWeight.bold,
      );

  static TextStyle balanceLabelTextStyle() =>
      TextStyle(
        color: Colors.black26,
        fontSize: 10.0,
        fontWeight: FontWeight.bold,
      );
}