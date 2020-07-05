import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:stockdb/constants/uiimages.dart';
import 'package:stockdb/constants/uistrings.dart';
import 'package:stockdb/constants/uithemes.dart';
import 'package:stockdb/dialogs/tappableDialog.dart';
import 'package:stockdb/helpers/navigationHelper.dart';
import 'package:stockdb/ui/widgets/elements/appStyle.dart';
import 'package:stockdb/ui/widgets/elements/buttonStyles.dart';
import 'package:stockdb/ui/widgets/elements/textStyles.dart';
import 'package:stockdb/ui/widgets/logoWidget.dart';

import '../widgets/elements/activityIndicatorWidget.dart';
import 'signInPhoneBloc.dart';

/// Страница авторизации.
class SignInWelcomePage extends StatefulWidget {
  @override
  _SignInWelcomePageState createState() => _SignInWelcomePageState();
}

class _SignInWelcomePageState extends State<SignInWelcomePage> {
  GlobalKey _contentKey = GlobalKey();
  GlobalKey _formKey = GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
        value: SystemUiOverlayStyle.light,
        child: Scaffold(
            body: Stack(
                fit: StackFit.expand,
                key: _contentKey,
                children: <Widget>[
                  Positioned.fill(
                    child: Image.asset(
                      UIImages.login_background,
                      fit: BoxFit.cover,
                      alignment: Alignment.topCenter,
                    ),
                  ),
                  _body(),
                ])));
  }

  Widget _body() => SingleChildScrollView(
        child: Column(
          key: _formKey,
          children: <Widget>[
            SizedBox(height: 150.0),
            SignUpLogo(),
            SizedBox(height: 270.0),
            applicationButton(buttonGradientColorStart, buttonGradientColorEnd,
                Colors.white, "Войти", () {
                  NavigationHelper.toSignInPhone(context);
                }),
            SizedBox(height: 40.0),
          ],
        ),
      );

}
