import 'package:flutter/material.dart';

import 'appStyle.dart';

Widget applicationButton(Color colorUp, Color colorDown, Color colorText,
    String text, EmptyCallback callback) {
  return Container(margin: const EdgeInsets.only(left: 61.0, right: 61.0),
    width: double.infinity,
    height: 44.0,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10.0),
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        stops: [0.1, 0.9],
        colors: [
          colorUp,
          colorDown,
        ],
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          spreadRadius: 5,
          blurRadius: 7,
          offset: Offset(0, 3), // changes position of shadow
        ),
      ],
    ),
    child: FlatButton(
      child: Text(
        text,
        style: TextStyle(
          fontSize: 16.0,
          color: colorText,
          fontFamily: 'Bold',
          fontWeight: FontWeight.w600,
        ),
      ),
      textColor: colorText,
      color: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      onPressed: () {
        callback();
      },
    ),
  );
}
