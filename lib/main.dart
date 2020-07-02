import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'constants/uiroutes.dart';
import 'constants/uistrings.dart';
import 'constants/uithemes.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: UIStrings.app_title,
        theme: UIThemes.mainTheme,
        initialRoute: UIRoutes.signIn,
        routes: UIRoutes.getRoutes(),
//        localizationsDelegates: [
//          GlobalMaterialLocalizations.delegate,
//          GlobalWidgetsLocalizations.delegate,
//          GlobalCupertinoLocalizations.delegate,
//        ],
        supportedLocales: [
          Locale('en'),
          Locale('ru'),
        ]
    );
  }
}