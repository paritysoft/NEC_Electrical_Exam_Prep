import 'dart:math';

import 'package:flutter/material.dart';

class AppColors {

  static const  Map<int, Color> color = {
    50: Color.fromRGBO(66, 165, 245, .1),
    100: Color.fromRGBO(66, 165, 245, .2),
    200: Color.fromRGBO(66, 165, 245, .3),
    300: Color.fromRGBO(66, 165, 245, .4),
    400: Color.fromRGBO(66, 165, 245, .5),
    500: Color.fromRGBO(66, 165, 245, .6),
    600: Color.fromRGBO(66, 165, 245, .7),
    700: Color.fromRGBO(66, 165, 245, .8),
    800: Color.fromRGBO(66, 165, 245, .9),
    900: Color.fromRGBO(66, 165, 245, 1),
  };
}

MaterialColor primary = MaterialColor(0xFF481F3A, AppColors.color);
MaterialColor background = MaterialColor(0xFFe8e4ff, AppColors.color);
MaterialColor navigationBottom = MaterialColor(0xFF661d97, AppColors.color);
MaterialColor bottomNav = MaterialColor(0xFFFFFFFF, AppColors.color);


const Color white = Color(0xFFFFFFFF);
const Color bgColor = Color(0xFF4448FF);


Color randomColor() {
  return Color(0xFFFFFFFF & Random().nextInt(0xFFFFFFFF)).withOpacity(0.4);
}