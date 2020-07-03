import 'dart:ui';

import 'package:flutter/material.dart';

import 'appStyle.dart';

class ShadowText extends StatelessWidget {
  ShadowText(this.data, {this.style}) : assert(data != null);

  final String data;
  final TextStyle style;

  Widget build(BuildContext context) {
    return new ClipRect(
      child: new Stack(
        children: [
          new Positioned(
            top: 2.0,
            left: 2.0,
            child: new Text(
              data,
              style: style.copyWith(color: Colors.yellow.withOpacity(0.7)),
            ),
          ),
          new BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
            child: new Text(data, style: style),
          ),
        ],
      ),
    );
  }
}

Widget appTextFieldWithoutImage(
    colorLeft, colorRight, String hint, bool hideText, TextCallback callback) {
  return Container(
    margin: const EdgeInsets.only(left: 61.0, right: 61.0),
    decoration: BoxDecoration(
      borderRadius: const BorderRadius.all(const Radius.circular(10.0)),
      gradient: LinearGradient(
          colors: [colorLeft, colorRight],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          spreadRadius: 5,
          blurRadius: 7,
          offset: Offset(0, 3), // changes position of shadow
        ),
      ],
    ),
    height: 44.0,
    child: TextFormField(
      keyboardType: TextInputType.phone,
      cursorColor: primaryColor,
      obscureText: hideText,
      autofocus: false,
      style: new TextStyle(color: appWhiteTextColor),
      decoration: InputDecoration(
        border: InputBorder.none,
        contentPadding: EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
//        contentPadding: EdgeInsets.zero,
        hintText: hint,
        hintStyle: TextStyle(color: appTextHintColor),
      ),
      onChanged: (text) {
        callback(text);
      },
    ),
  );
}
