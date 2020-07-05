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
class SignInPhonePage extends StatefulWidget {
  @override
  _SignInPhonePageState createState() => _SignInPhonePageState();
}

class _SignInPhonePageState extends State<SignInPhonePage> with SingleTickerProviderStateMixin {
  GlobalKey _contentKey = GlobalKey();
  GlobalKey _formKey = GlobalKey();

  Animation<double> _animation;
  AnimationController _controller;
  Tween _tween;

  SignInPhoneBloc _signInPhoneBloc;
  bool _loading = false;

  String _phone = "";

  @override
  void initState() {
//    textControllerPhone.text = _phone;
    _signInPhoneBloc = SignInPhoneBloc();
    _signInPhoneBloc.initState();
    super.initState();
    _controller = AnimationController( vsync: this, duration: Duration(seconds: 2));
    _tween = Tween<double>(begin: 10.0, end: 180.0);
    _animation = _tween.animate(_controller);
    _animation.addListener(() {
      setState(() {
      });
    });
    _controller.forward();
  }

  @override
  void dispose() {
      _signInPhoneBloc.dispose();
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

  Widget _body() =>  ScaleTransition(scale: _controller, child: SingleChildScrollView(
        child:Column(
          key: _formKey,
          children: <Widget>[
            SizedBox(height: 150.0),
            SignUpLogo(),
            SizedBox(height: 210.0),
            appTextFieldWithoutImage(textFieldGradientColorStart,
                textFieldGradientColorEnd, "Телефон", false, (String text) {
              _phone = text;
            }),
            SizedBox(height: 20.0),
            applicationButton(buttonGradientColorStart, buttonGradientColorEnd,
                Colors.white, "Далее", () {
                  _signInPhoneBloc.signIn(_phone) ;
//                  NavigationHelper.toSignInCode(context);
                }),
            SizedBox(height: 40.0),
          ],
        ),
      ));
}
