import 'package:flutter/material.dart';

import 'app_colors.dart';

@immutable
class AppTheme{
  static const colors = AppColors();

  const AppTheme._();

  static ThemeData define() {
    return ThemeData(
      fontFamily: "EFRegular",
      primaryColor: const Color(0xffC6AD70),
      hintColor: const Color(0xff252525),
      focusColor: const Color(0xff181818),
    );
  }
}