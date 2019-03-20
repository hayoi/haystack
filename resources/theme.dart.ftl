import 'package:flutter/material.dart';

enum ThemeName { DARK, LIGHT }

class AppTheme {
  static final AppTheme _singleton = new AppTheme._internal();
  static ThemeName _themeName = ThemeName.LIGHT;

  factory AppTheme() {
    return _singleton;
  }

  AppTheme._internal();

  static void configure(ThemeName themeName) {
    _themeName = themeName;
  }

  ThemeData get appTheme {
    switch (_themeName) {
      case ThemeName.DARK:
        return _buildDarkTheme();
      default: // Flavor.PRO:
        return _buildLightTheme();
    }
  }

  TextTheme _buildTextTheme(TextTheme base) {
    return base.copyWith(
      title: base.title.copyWith(
        fontFamily: 'GoogleSans',
      ),
    );
  }

  ThemeData _buildDarkTheme() {
    const Color primaryColor = Colors.blue;
    final ThemeData base = new ThemeData.dark();
    return base.copyWith(
      primaryColor: primaryColor,
      buttonColor: primaryColor,
      indicatorColor: Colors.white,
      accentColor: Colors.blueAccent,
      canvasColor: Colors.black38,
      scaffoldBackgroundColor: Colors.black38,
      backgroundColor: Colors.black38,
      errorColor: const Color(0xFFB00020),
      buttonTheme: const ButtonThemeData(
        textTheme: ButtonTextTheme.primary,
      ),
      textTheme: _buildTextTheme(base.textTheme),
      primaryTextTheme: _buildTextTheme(base.primaryTextTheme),
      accentTextTheme: _buildTextTheme(base.accentTextTheme),
    );
  }

  ThemeData _buildLightTheme() {
    const Color primaryColor = Colors.lightBlue;
    final ThemeData base = new ThemeData.light();
    return base.copyWith(
      primaryColor: primaryColor,
      buttonColor: primaryColor,
      indicatorColor: Colors.white,
      splashColor: Colors.white24,
      splashFactory: InkRipple.splashFactory,
      accentColor: Colors.lightBlueAccent,
      canvasColor: Colors.white,
      scaffoldBackgroundColor: Colors.white,
      backgroundColor: Colors.white,
      errorColor: const Color(0xFFB00020),
      buttonTheme: const ButtonThemeData(
        textTheme: ButtonTextTheme.primary,
      ),
      textTheme: _buildTextTheme(base.textTheme),
      primaryTextTheme: _buildTextTheme(base.primaryTextTheme),
      accentTextTheme: _buildTextTheme(base.accentTextTheme),
    );
  }
}
