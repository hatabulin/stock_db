import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stockdb/constants/uiimages.dart';
import 'package:stockdb/helpers/navigationHelper.dart';
import 'package:stockdb/ui/widgets/elements/appStyle.dart';
import 'package:stockdb/ui/widgets/elements/buttonStyles.dart';
import 'package:stockdb/ui/widgets/elements/textStyles.dart';
import 'package:stockdb/ui/widgets/logoWidget.dart';
import 'signInPhoneBloc.dart';

/// Страница авторизации.
class SignInPhonePage extends StatefulWidget {
  @override
  SignInPhonePageState createState() => SignInPhonePageState();
}

class SignInPhonePageState extends State<SignInPhonePage>
    with SingleTickerProviderStateMixin {
  GlobalKey _contentKey = GlobalKey();
  GlobalKey _formKey = GlobalKey();

  Animation<double> _animation;
  AnimationController _controller;
  Tween _tween;

  SignInPhoneBloc _signInPhoneBloc;
  bool _loading = false;
  String _phone = "";
  final _code = List<int>();

  @override
  void initState() {
    _signInPhoneBloc = SignInPhoneBloc();
    _signInPhoneBloc.initState();
    super.initState();

    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    _tween = Tween<double>(begin: 10.0, end: 180.0);
    _animation = _tween.animate(_controller);
    _animation.addListener(() {
      setState(() {});
    });
//    _controller.forward();

    for (var i = 1; i < 6; i++) {
      _code.add(0);
    }
  }

  @override
  void dispose() {
    _signInPhoneBloc.dispose();
    _controller.dispose();

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
                  SignUpLogo(),
//                  _rrr(),
                  _enterPhoneBloc() //_body()
                ])));
  }


  Widget _rrr() {
    return Container(
      child: ConstrainedBox(
        constraints: BoxConstraints.tight(Size.fromHeight(200)),
//        child: getViewAsPerState(state),
      ),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(62))),
    );
  }

  Widget _enterPhoneBloc() {
    return StreamBuilder(
      stream: _signInPhoneBloc.stream,
      initialData: SignInEnterState,
      builder: (BuildContext context, snapshot) {
        if (snapshot.data is SignInLoadingState) {
          return _loadingWidget();
        } else if (snapshot.data is SignInEnterState) {
          return _bodyEnter();
        } else if (snapshot.data is SignInPhoneState) {
          _controller.forward();
          return _bodyPhoneNumber();
        } else if (snapshot.data is SignInCodeState) {
          return _bodyEnterCode();
        } else
          return _loadingWidget();
      },
    );
  }

  Widget _bodyEnter() => Column(
//          key: _formKey,
        children: <Widget>[
          SizedBox(height: 470.0),
          applicationButton(buttonGradientColorStart, buttonGradientColorEnd,
              Colors.white, "Войти", () {
            _signInPhoneBloc.enterPhone();
          }),
          SizedBox(height: 40.0),
        ],
      );

  Widget _bodyPhoneNumber() => SingleChildScrollView( child:ScaleTransition(
        scale: _controller,
        child: Column(
          key: _formKey,
          children: <Widget>[
            SizedBox(height: 410.0),
            appTextFieldWithoutImage(textFieldGradientColorStart,
                textFieldGradientColorEnd, "Телефон", false, (String text) {
              _phone = text;
            }),
            SizedBox(height: 20.0),
            applicationButton(buttonGradientColorStart, buttonGradientColorEnd,
                Colors.white, "Далее", () {
              _signInPhoneBloc.enterCode();
            }),
            SizedBox(height: 40.0),
          ],
        ),
  ));

  Widget _bodyEnterCode() => SingleChildScrollView(
          child: Column(
        key: _formKey,
        children: <Widget>[
          SizedBox(height: 300.0),
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
                NavigationHelper.homePage(context);
          }),
          SizedBox(height: 40.0)
        ],
      ));

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

  Widget _loadingWidget() => Center(child: CircularProgressIndicator());
}
