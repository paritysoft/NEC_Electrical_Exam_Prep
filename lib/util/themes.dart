import 'package:flutter/material.dart';

import 'AppColors.dart';

ThemeData light = ThemeData(
  fontFamily: 'TitilliumWeb',
  primaryColor: primary,
  brightness: Brightness.light,
  // accentColor: Colors.white,
  hintColor: Color(0xFFC3C3FF),
  pageTransitionsTheme: const PageTransitionsTheme(builders: {
    TargetPlatform.android: ZoomPageTransitionsBuilder(),
    TargetPlatform.iOS: ZoomPageTransitionsBuilder(),
    TargetPlatform.fuchsia: ZoomPageTransitionsBuilder(),
  }),
);

ThemeData dark = ThemeData(
  fontFamily: 'TitilliumWeb',
  primaryColor: primary,
  brightness: Brightness.dark,
  //accentColor: Color(0xFF252525),
  hintColor: Color(0xffc3c3c3),
  pageTransitionsTheme: const PageTransitionsTheme(builders: {
    TargetPlatform.android: ZoomPageTransitionsBuilder(),
    TargetPlatform.iOS: ZoomPageTransitionsBuilder(),
    TargetPlatform.fuchsia: ZoomPageTransitionsBuilder(),
  }),
);