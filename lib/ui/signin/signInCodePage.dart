import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stockdb/constants/uiimages.dart';
import 'package:stockdb/ui/widgets/elements/appStyle.dart';
import 'package:stockdb/ui/widgets/elements/buttonStyles.dart';
import 'package:stockdb/ui/widgets/elements/textStyles.dart';
import 'package:stockdb/ui/widgets/logoWidget.dart';
import 'signInPhoneBloc.dart';

/// Страница авторизации.
class SignInCodePage extends StatefulWidget {
  @override
  _SignInCodePageState createState() => _SignInCodePageState();
}

class _SignInCodePageState extends State<SignInCodePage> {
  GlobalKey _contentKey = GlobalKey();
  GlobalKey _formKey = GlobalKey();

  SignInPhoneBloc _signInCodeBloc;
  bool _loading = false;
  final _code = List<int>();

  String _phone = "";

  @override
  void initState() {
//    textControllerPhone.text = _phone;
    _signInCodeBloc = SignInPhoneBloc();
    _signInCodeBloc.initState();

    for (var i = 1; i < 6; i++) {
      _code.add(0);
    }
    super.initState();
  }

  @override
  void dispose() {
    _signInCodeBloc.dispose();
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
                stream: _signInCodeBloc.stream,
                initialData: SignInInitState(),
                builder: (BuildContext context, snapshot) {
                  if (snapshot.data is SignInLoadingState) {
                    _loading = true;
                    return _body();
                  } else if (snapshot.data is SignInSuccessState) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {});
                    return _body();
                  } else if (snapshot.data is SignInErrorState) {
                    _loading = false;
                    WidgetsBinding.instance.addPostFrameCallback((_) {
//                          _showIncorrectCredentials((snapshot.data as SignInErrorState).error);
                    });
                    return _body();
                  } else {
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
            SizedBox(height: 150.0),
            SignUpLogo(),
            SizedBox(height: 100.0),
            Container(
              height: 30,
              margin: const EdgeInsets.only(left: 85.0, right: 85.0),
              child: Text(
                  "Введите код который мы отправили на указаный вами номер телефона",
                  textAlign: TextAlign.center,
                  style: new TextStyle(
                    decoration: TextDecoration.none,
                    color: Colors.white,
                    decorationColor: Colors.white,
                    decorationStyle: TextDecorationStyle.solid,
                  )),
            ),
            SizedBox(height: 30.0),
            _codeWidget(),
            SizedBox(height: 70.0),
            applicationButton(buttonGradientColorStart, buttonGradientColorEnd,
                Colors.white, "Войти", () {
              _signInCodeBloc.signIn(_phone);
            }),
            SizedBox(height: 40.0)
          ],
        ),
      );

  Widget _codeWidget() {
    return Container(
        margin: const EdgeInsets.only(left: 61.0, right: 61.0),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          appTextCodeField(textCodeFieldGradientColorStart,
              textCodeFieldGradientColorEnd, "_", false, (String text) {
            _code[0] = int.parse(text);
          }),
          SizedBox(width: 5.0),
          appTextCodeField(textCodeFieldGradientColorStart,
              textCodeFieldGradientColorEnd, "_", false, (String text) {
            _code[1] = int.parse(text);
          }),
          SizedBox(width: 5.0),
          appTextCodeField(textCodeFieldGradientColorStart,
              textCodeFieldGradientColorEnd, "_", false, (String text) {
            _code[2] = int.parse(text);
          }),
          SizedBox(width: 5.0),
          appTextCodeField(textCodeFieldGradientColorStart,
              textCodeFieldGradientColorEnd, "_", false, (String text) {
            _code[3] = int.parse(text);
          }),
          SizedBox(width: 5.0),
          appTextCodeField(textCodeFieldGradientColorStart,
              textCodeFieldGradientColorEnd, "_", false, (String text) {
            _code[4] = int.parse(text);
          }),
          SizedBox(width: 5.0),
          appTextCodeField(textCodeFieldGradientColorStart,
              textCodeFieldGradientColorEnd, "_", false, (String text) {
            _code[5] = int.parse(text);
          }),
        ]));
  }
}
