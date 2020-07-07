import 'package:flutter/material.dart';

import 'elements/textStyles.dart';

Widget SignUpLogo() {
  return Column(children: <Widget>[
    SizedBox(height: 150.0),
    Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          child: Image.asset('assets/img/img_stock_logo.png'),
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
    SizedBox(height: 20.0),
    Text(
      "Учет товаров на складе.",
      style: TextStyle(color: Colors.white),
    ),
  ]);
}

final Shader linearGradient = LinearGradient(
  colors: <Color>[Color(0xffeA441b), Color(0xffffff2a)],
).createShader(new Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));
