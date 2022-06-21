import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme() => ThemeData(
      fontFamily: 'Gotham',
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: Color(0xFF02003D),
        onPrimary: Color(0XFFFFFFFF),
        secondary: Color(0XFF02003D),
        onSecondary: Color(0XFFFFFFFF),
        error: Color(0XFFB00020),
        onError: Color(0xFFFFFFFF),
        background: Color(0XFFFFFFFF),
        onBackground: Color(0xFF000000),
        surface: Color(0XFFFAFBFF),
        onSurface: Color(0XFF000000),
      ),
      scaffoldBackgroundColor: const Color(0XFFFFFFFF),
      brightness: Brightness.light);

  static ThemeData darkTheme() => ThemeData(
      fontFamily: 'Gotham',
      colorScheme: const ColorScheme(
        brightness: Brightness.dark,
        primary: Color(0xFF4E09FF),
        onPrimary: Color(0XFFFFFFFF),
        secondary: Color(0XFF4E09FF),
        onSecondary: Color(0XFFFFFFFF),
        error: Color(0XFFCF6679),
        onError: Color(0XFF000000),
        background: Color(0XFF0B0B0B),
        onBackground: Color(0xFFFFFFFF),
        surface: Color(0XFF111111),
        onSurface: Color(0XFFFFFFFF),
      ),
      scaffoldBackgroundColor: const Color(0XFF0B0B0B),
      brightness: Brightness.dark);
}
