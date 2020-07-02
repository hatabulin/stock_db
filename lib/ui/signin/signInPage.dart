import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:stockdb/constants/uiimages.dart';
import 'package:stockdb/constants/uistrings.dart';
import 'package:stockdb/constants/uithemes.dart';
import 'package:stockdb/dialogs/tappableDialog.dart';
import 'package:stockdb/helpers/navigationHelper.dart';

import '../widgets/elements/activityIndicatorWidget.dart';
import 'signInBloc.dart';

enum AuthMethod {
  login,
  phone,
}

/// Страница авторизации.
class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {

  AuthMethod _authMethod = AuthMethod.login;

  MaskedTextController _loginEditingController;
  MaskedTextController _phoneEditingController;
  TextEditingController _passwordEditingController;

  FocusNode _loginFocusNode = FocusNode();
  FocusNode _passwordFocusNode = FocusNode();

  GlobalKey _contentKey = GlobalKey();
  GlobalKey _formKey = GlobalKey();

  double heightForLogo = 0;

  SignInBloc _signInBloc;

  String _loginErrorText;
  String _passwordErrorText;

  bool _loading = false;

  @override
  void initState() {
    super.initState();

    _loginEditingController = MaskedTextController(mask: '0000000000');
    _phoneEditingController = MaskedTextController(mask: '+38 (000) 000-00-00');
    _passwordEditingController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final mediaQuery = MediaQuery.of(context);
      final RenderBox formRenderBox =
          _formKey.currentContext.findRenderObject();
      setState(() {
        heightForLogo = mediaQuery.size.height - formRenderBox.size.height;
      });
    });

    _signInBloc = SignInBloc();
  }

  @override
  void dispose() {
    _phoneEditingController.dispose();
    _loginEditingController.dispose();
    _passwordEditingController.dispose();
    _loginFocusNode.dispose();
    _passwordFocusNode.dispose();
    _signInBloc.dispose();
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
              stream: _signInBloc.stream,
              initialData: SignInInitState(),
              builder: (BuildContext context, snapshot) {
                if (snapshot.data is SignInLoadingState) {
                  _loading = true;
                  return _body();
                } else if (snapshot.data is SignInSuccessState) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    NavigationHelper.fromSignInToUsePinCode(context);
                  });
                  return _body();
                } else if (snapshot.data is SignInErrorState) {
                  _loading = false;
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _showIncorrectCredentials(
                        (snapshot.data as SignInErrorState).error);
                  });
                  return _body();
                } else {
                  return _body();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _body() => SingleChildScrollView(
        child: Column(
          children: <Widget>[
            if (heightForLogo != null) _logo(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 26.0),
              child: Column(
                key: _formKey,
                children: <Widget>[
                  _buildLoginTypePicker(),
                  SizedBox(height: 10.0),
                  _buildLoginTextField(),
                  _passwordTextField(),
                  SizedBox(height: 20.0),
                  Text(
                    UIStrings.sign_in_need_accept,
                    style: UIThemes.loginTextTextStyle().copyWith(
                      fontSize: 14.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20.0),
                  _submitButton(),
                  SizedBox(height: 20.0),
                  FlatButton(
                    child: Text(UIStrings.sign_in_where_get_login,
                        style: UIThemes.loginFlatButtonTextStyle()),
                    onPressed: () {
                      _aboutLoginAndPasswordDialog(context);
                    },
                    padding: EdgeInsets.all(15),
                  ),
                  /// TODO Временно скрыто. Включить после рефакторинга
                  /// экранов запроса и изменения пароля
                  /*
                FlatButton(
                  child: Text (
                    UIStrings.sign_in_recover_login,
                    style: UIThemes.loginFlatButtonTextStyle()
                  ),
                  onPressed: () {
                    NavigationHelper.toRestorePassword(context);
                  },
                  padding: EdgeInsets.all(15),
                ),*/

                  SizedBox(height: 40.0),
                ],
              ),
            ),
          ],
        ),
      );

  Widget _logo() =>
      TappableDialog(
        child: SizedBox(
          height: heightForLogo,
          child: Image.asset(
            UIImages.logo_new,
            width: MediaQuery.of(context).size.width / 3,
          ),
        ),
        onTap: () {
          if(kDebugMode) {
            _loginEditingController.text = '31.52.141694';
            _passwordEditingController.text = '7910';
          }
        },
      );

  Widget _buildLoginTypePicker() {
    var selectedDecoration = BoxDecoration(
      color: UIThemes.primaryColor,
    );
    var unselectedDecoration = BoxDecoration(
      color: UIThemes.transparent,
      boxShadow: [
        BoxShadow(
          color: UIThemes.black.withOpacity(0.23),
        ),
        BoxShadow(
          color: UIThemes.primaryContrastingColor,
          spreadRadius: -6.0,
          blurRadius: 6.0,
        ),
      ],
    );
    var selectedTextColor = UIThemes.primaryContrastingColor;
    var unselectedTextColor = UIThemes.backgroundHalfContrastingColor;

    return Row(
      children: <Widget>[
        Expanded(
          child: TappableDialog(
            child: Container(
              decoration: _authMethod != AuthMethod.login ? BoxDecoration(
                color: UIThemes.backgroundColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8.0),
                  bottomLeft: Radius.circular(8.0),
                ),
              ) : null,
              child: Container(
                padding: EdgeInsets.all(20.0),
                alignment: Alignment.center,
                decoration: (_authMethod == AuthMethod.login ? selectedDecoration : unselectedDecoration).copyWith(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8.0),
                    bottomLeft: Radius.circular(8.0),
                  ),
                ),
                child: Text(
                  UIStrings.sign_in_login,
                  style: TextStyle(
                    color: _authMethod == AuthMethod.login ? selectedTextColor : unselectedTextColor,
                  ),
                ),
              ),
            ),
            onTap: () {
              _loginErrorText = null;
              FocusScope.of(context).unfocus();
              setState(() {
                _authMethod = AuthMethod.login;
              });
              WidgetsBinding.instance.addPostFrameCallback((dur) {
                _loginEditingController.text = '';
                _phoneEditingController.text = '';
              });
            },
          ),
        ),
        Expanded(
          child: TappableDialog(
            child: Container(
              decoration: _authMethod != AuthMethod.phone ? BoxDecoration(
                color: UIThemes.backgroundColor,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(8.0),
                  bottomRight: Radius.circular(8.0),
                ),
              ) : null,
              child: Container(
                padding: EdgeInsets.all(20.0),
                alignment: Alignment.center,
                decoration: (_authMethod == AuthMethod.phone ? selectedDecoration : unselectedDecoration).copyWith(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(8.0),
                    bottomRight: Radius.circular(8.0),
                  ),
                ),
                child: Text(
                  UIStrings.sign_in_phone,
                  style: TextStyle(
                    color: _authMethod == AuthMethod.phone ? selectedTextColor : unselectedTextColor,
                  ),
                ),
              ),
            ),
            onTap: () {
              _loginErrorText = null;
              FocusScope.of(context).unfocus();
              setState(() {
                _authMethod = AuthMethod.phone;
              });
              WidgetsBinding.instance.addPostFrameCallback((dur) {
                _loginEditingController.text = '';
                _phoneEditingController.text = '';
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildLoginTextField() {
    var decoration = InputDecoration(
      labelText:  _authMethod == AuthMethod.login
          ? UIStrings.sign_in_login
          : UIStrings.sign_in_phone,
      labelStyle: TextStyle(
        color: UIThemes.backgroundHalfContrastingColor,
      ),
      hintText: _authMethod == AuthMethod.login
          ? UIStrings.sign_in_login_mask_hint
          : UIStrings.sign_in_phone_mask_hint,
      errorText: _loginErrorText,
      hintStyle: TextStyle(
        color: UIThemes.backgroundHalfContrastingColor,
      ),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: UIThemes.backgroundHalfContrastingColor),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: UIThemes.backgroundColor),
      ),
    );
    var onChanged = (newText) {
      if(_loginErrorText != null) {
        setState(() {
          _loginErrorText = null;
        });
      }
    };
    var onSubmitted = (text) {
      _passwordFocusNode.requestFocus();
    };
    var style = TextStyle(
      color: UIThemes.backgroundColor,
    );
    if(_authMethod == AuthMethod.phone) {
      return TextField(
        focusNode: _loginFocusNode,
        controller: _phoneEditingController,
        decoration: decoration,
        style: style,
        onChanged: onChanged,
        onSubmitted: onSubmitted,
        textInputAction: TextInputAction.next,
        keyboardType: TextInputType.phone,
      );
    } else {
      return TextField(
        focusNode: _loginFocusNode,
        controller: _loginEditingController,
        decoration: decoration,
        style: style,
        onChanged: onChanged,
        onSubmitted: onSubmitted,
        textInputAction: TextInputAction.next,
        keyboardType: TextInputType.number,
      );
    }
  }


  Widget _passwordTextField() =>
      TextField(
        focusNode: _passwordFocusNode,
        controller: _passwordEditingController,
        decoration: InputDecoration(
          labelText: UIStrings.sign_in_password,
          labelStyle: TextStyle(
            color: UIThemes.backgroundHalfContrastingColor,
          ),
          hintText: UIStrings.sign_in_password_hint,
          errorText: _passwordErrorText,
          hintStyle: TextStyle(
            color: UIThemes.backgroundHalfContrastingColor,
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: UIThemes.backgroundHalfContrastingColor),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: UIThemes.backgroundColor),
          ),
        ),
        style: TextStyle(
          color: UIThemes.backgroundColor,
        ),
        obscureText: true,
        onChanged: (text) {
          if(_passwordErrorText != null) {
            setState(() {
              _passwordErrorText = null;
            });
          }
        },
        onSubmitted: (text) {
          _login();
        },
        textInputAction: TextInputAction.done,
      );


  Widget _submitButton() =>
      TappableDialog(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 60.0, vertical: 16.0),
          child: _loading ? ActivityIndicatorWidget() : Text(
            UIStrings.common_enter,
            style: TextStyle(
              fontWeight: FontWeight.w800,
              color: UIThemes.primaryContrastingColor,
            ),
          ),
          decoration: BoxDecoration(
            color: UIThemes.primaryColor,
            borderRadius: BorderRadius.circular(40.0),
          ),
        ),
        onTap: () {
          _login();
        },
      );

  Widget _buildIncorrectCredentials(String error) {
    return Container(
      decoration: BoxDecoration(
          color: UIThemes.backgroundColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(45.0),
            topRight: Radius.circular(45.0),
          )),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(height: 30.0),
          Text(
            UIStrings.common_error,
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 22.0,
            ),
          ),
          SizedBox(height: 14.0),
          Text(error),
          SizedBox(height: 20.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: TappableDialog(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 60.0, vertical: 16.0),
                alignment: Alignment.center,
                child: Text(
                  UIStrings.common_done.toUpperCase(),
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: UIThemes.primaryContrastingColor,
                    fontSize: 17.0,
                  ),
                ),
                decoration: BoxDecoration(
                    color: UIThemes.accentColor,
                    borderRadius: BorderRadius.circular(40.0),
                    boxShadow: [
                      BoxShadow(
                        color: UIThemes.accentColorShadow,
                        offset: Offset(0.0, 10.0),
                        blurRadius: 10.0,
                      )
                    ]),
              ),
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          SizedBox(height: 30.0),
        ],
      ),
    );
  }

  Future _aboutLoginAndPasswordDialog(BuildContext context) =>
      showDialog(
        context: context,
        builder: (BuildContext context) =>
            AlertDialog(
              title: Text(UIStrings.appName),
              content: Text(UIStrings.sign_in_where_get_login_text),
              actions: <Widget>[

                FlatButton(
                  child: Text(UIStrings.common_ok),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),

              ],
            ),
      );


  void _login() async {
    FocusScope.of(context).unfocus();

    _loginErrorText = null;
    _passwordErrorText = null;

    if (_authMethod == AuthMethod.login) {
      if (_loginEditingController.text.isEmpty) _loginErrorText = UIStrings.sign_in_login_hint;
    } else {
      if (_phoneEditingController.text.isEmpty) _loginErrorText = UIStrings.sign_in_phone_hint;
    }

    if (_passwordEditingController.text.isEmpty) {
      _passwordErrorText = UIStrings.sign_in_password_hint ;
    }

    if (_loginErrorText != null || _passwordErrorText != null) {
      setState(() {}); // to update errors
      return;
    }

    var user = _authMethod == AuthMethod.login
        ? _loginEditingController.text
    // TODO Узнать нужный формат телефона (сейчас 79161234567)
        : _phoneEditingController.text.replaceAll(RegExp(r'\D'), '');

    _signInBloc.login(
        user,
        _passwordEditingController.text
    );
  }

  void _showIncorrectCredentials(String error) async {
    FocusScope.of(context).unfocus();
    await showModalBottomSheet(
      context: _contentKey.currentContext,
      isScrollControlled: true,
      backgroundColor: UIThemes.transparent,
      builder: (context) => _buildIncorrectCredentials(error),
    );
  }
}
