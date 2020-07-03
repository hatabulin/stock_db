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

import '../widgets/elements/activityIndicatorWidget.dart';
import 'signInPhoneBloc.dart';

/// Страница авторизации.
class SignInPhonePage extends StatefulWidget {
  @override
  _SignInPhonePageState createState() => _SignInPhonePageState();
}

class _SignInPhonePageState extends State<SignInPhonePage> {
  GlobalKey _contentKey = GlobalKey();
  GlobalKey _formKey = GlobalKey();

  SignInPhoneBloc _signInPhoneBloc;
  bool _loading = false;

  String _phone = "";

  @override
  void initState() {
//    textControllerPhone.text = _phone;
    _signInPhoneBloc = SignInPhoneBloc();
    super.initState();
  }

  @override
  void dispose() {
    setState(() {
      _signInPhoneBloc.dispose();
    });
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
                  StreamBuilder(
                    stream: _signInPhoneBloc.stream,
                    initialData: SignInInitState(),
                    builder: (BuildContext context, snapshot) {
                      if (snapshot.data is SignInLoadingState) {
                        _loading = true;
                        return _body();
                      }
                      else if (snapshot.data is SignInSuccessState) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
//                          NavigationHelper.fromSignInToUsePinCode(context);
                        });
                        return _body();
                      }
                      else if (snapshot.data is SignInErrorState) {
                        _loading = false;
                        WidgetsBinding.instance.addPostFrameCallback((_) {
//                          _showIncorrectCredentials((snapshot.data as SignInErrorState).error);
                        });
                        return _body();
                      }
                      else {
                        return _body();
                      }
                    },
                  ),
            ])));
  }

  Widget _body() => SingleChildScrollView(
        child: Column(
          key: _formKey,
          children: <Widget>[
            SizedBox(height: 200.0),
            _signUpLogo(),
            SizedBox(height: 20.0),
            Text(
              "Учет товаров на складе.",
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 120.0),
            appTextFieldWithoutImage(textFieldGradientColorStart,
                textFieldGradientColorEnd, "Телефон", false, (String text) {
              _phone = text;
            }),
            SizedBox(height: 20.0),
            applicationButton(buttonGradientColorStart, buttonGradientColorEnd,
                Colors.white, "Далее", () {}),
            SizedBox(height: 40.0),
          ],
        ),
      );

  Widget _signUpLogo() {
    return InkWell(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            child: Image.asset('assets/images/img_stock_logo.png'),
            height: 44,
          ),
          Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: ShadowText("Cклад",
                  style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 44,
                      fontWeight: FontWeight.bold,
                      foreground: new Paint()..shader = linearGradient))
//                        color: Colors.white)),
              )
        ],
      ),
    );
  }

  final Shader linearGradient = LinearGradient(
    colors: <Color>[Color(0xffeA441b), Color(0xffffff2a)],
  ).createShader(new Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));
}
