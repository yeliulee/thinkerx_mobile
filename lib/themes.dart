import 'dart:math';

import 'package:flutter/material.dart';

class AppThemes {
  static int tintValue(int value, double factor) {
    return max(0, min((value + ((255 - value) * factor)).round(), 255));
  }

  static Color tintColor(Color color, double factor) {
    return Color.fromRGBO(tintValue(color.red, factor), tintValue(color.green, factor), tintValue(color.blue, factor), 1);
  }

  static int shadeValue(int value, double factor) {
    return max(0, min(value - (value * factor).round(), 255));
  }

  static Color shadeColor(Color color, double factor) {
    return Color.fromRGBO(shadeValue(color.red, factor), shadeValue(color.green, factor), shadeValue(color.blue, factor), 1);
  }

  static MaterialColor generateMaterialColor(Color color) {
    return MaterialColor(color.value, {
      50: tintColor(color, 0.9),
      100: tintColor(color, 0.8),
      200: tintColor(color, 0.6),
      300: tintColor(color, 0.4),
      400: tintColor(color, 0.2),
      500: color,
      600: shadeColor(color, 0.1),
      700: shadeColor(color, 0.2),
      800: shadeColor(color, 0.3),
      900: shadeColor(color, 0.4),
    });
  }

  static ThemeData _themeBlue() {
    return ThemeData(
      primarySwatch: Colors.blue,
      primaryColor: Colors.blue,
      accentColor: Colors.blueAccent,
      scaffoldBackgroundColor: Colors.white,
      buttonTheme: ButtonThemeData(),
    );
  }

  static ThemeData _themePink() {
    return ThemeData(
      brightness: Brightness.light,
      primarySwatch: Colors.pink,
      primaryColor: Colors.pink,
      accentColor: Colors.pinkAccent,
      scaffoldBackgroundColor: Colors.white,
    );
  }

  static ThemeData _themeOrange() {
    return ThemeData(
      brightness: Brightness.light,
      primarySwatch: Colors.orange,
      primaryColor: Colors.orange,
      accentColor: Colors.orangeAccent,
      scaffoldBackgroundColor: Colors.white,
    );
  }

  static ThemeData _themeRed() {
    return ThemeData(
      brightness: Brightness.light,
      primarySwatch: Colors.red,
      primaryColor: Colors.red,
      accentColor: Colors.redAccent,
      scaffoldBackgroundColor: Colors.white,
    );
  }

  static ThemeData _themeCyan() {
    return ThemeData(
      brightness: Brightness.light,
      primarySwatch: Colors.cyan,
      primaryColor: Colors.cyan,
      accentColor: Colors.cyanAccent,
      scaffoldBackgroundColor: Colors.white,
    );
  }

  static ThemeData _themeGreen() {
    return ThemeData(
      brightness: Brightness.light,
      primarySwatch: Colors.green,
      primaryColor: Colors.green,
      accentColor: Colors.greenAccent,
      scaffoldBackgroundColor: Colors.white,
    );
  }

  static ThemeData _themePurple() {
    return ThemeData(
      brightness: Brightness.light,
      primarySwatch: Colors.purple,
      primaryColor: Colors.purple,
      accentColor: Colors.purpleAccent,
      scaffoldBackgroundColor: Colors.white,
    );
  }

  static ThemeData _themePinkLight() {
    return ThemeData(
      brightness: Brightness.light,
      primarySwatch: generateMaterialColor(Colors.pink[300]),
      primaryColor: Colors.pink[300],
      accentColor: Colors.pink[200],
      scaffoldBackgroundColor: Colors.white,
    );
  }

  static ThemeData _themePurpleLight() {
    return ThemeData(
      brightness: Brightness.light,
      primarySwatch: generateMaterialColor(Colors.purple[300]),
      primaryColor: Colors.purple[300],
      accentColor: Colors.purple[200],
      scaffoldBackgroundColor: Colors.white,
    );
  }

  static ThemeData _themeGreenLight() {
    return ThemeData(
      brightness: Brightness.light,
      primarySwatch: generateMaterialColor(Color(0xFF7ABD9A)),
      primaryColor: Color(0xFF7ABD9A),
      accentColor: Color(0xFFA7CBBA),
      scaffoldBackgroundColor: Colors.white,
    );
  }

  static Map<String, ThemeData> _themes = {
    "blue": _themeBlue(),
    "pink": _themePink(),
    "orange": _themeOrange(),
    "red": _themeRed(),
    "cyan": _themeCyan(),
    "green": _themeGreen(),
    "purple": _themePurple(),
    "pinkLight": _themePinkLight(),
    "purpleLight": _themePurpleLight(),
    "greenLight": _themeGreenLight(),
  };

  static ThemeData getTheme({String themeName = 'blue'}) {
    return _themes[themeName];
  }

  static final all = _themes;
}
