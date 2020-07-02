import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'elements/appStyle.dart';

Widget editFieldStyle(String hint,int maxLength,bool upperCase, TextCallback callback) {
  TextCapitalization textCap = TextCapitalization.none;
  if (upperCase) textCap = TextCapitalization.characters;
  return TextField(
    textCapitalization: textCap,
    inputFormatters: [
      LengthLimitingTextInputFormatter(maxLength),],
    decoration: InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey),
    ),
    onChanged: (text) {
      callback(text);
    },
  );
}

Widget editFieldEmailStyle(String hint, TextCallback callback) {
  return TextFormField(
    keyboardType: TextInputType.emailAddress,
    inputFormatters: [
      LengthLimitingTextInputFormatter(20),],
    decoration: InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey),
    ),
    onChanged: (text) {
      callback(text);
    },
  );
}

Widget editFieldNumStyle(String hint, TextCallback callback) {
  return TextFormField(
    keyboardType: TextInputType.number,
    inputFormatters: [
      LengthLimitingTextInputFormatter(10),],
    decoration: InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey),
    ),
    onChanged: (text) {
      callback(text);
    },
  );
}

Widget editFieldPhoneStyle(String hint, TextCallback callback) {
  return TextFormField(
    keyboardType: TextInputType.phone,
    inputFormatters: [
      LengthLimitingTextInputFormatter(20),],
    decoration: InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey),
    ),
    onChanged: (text) {
      callback(text);
    },
  );
}
