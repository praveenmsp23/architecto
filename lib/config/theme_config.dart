import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

/// Theme configuration for the app
class ThemeConfig {
  // Text styles with Nunito font
  static final _baseTextStyle = GoogleFonts.nunito();
  
  static final CupertinoThemeData lightTheme = CupertinoThemeData(
    brightness: Brightness.light,
    primaryColor: CupertinoColors.systemRed,
    barBackgroundColor: CupertinoColors.systemBackground,
    scaffoldBackgroundColor: CupertinoColors.systemBackground,
    textTheme: CupertinoTextThemeData(
      primaryColor: CupertinoColors.black,
      textStyle: _baseTextStyle.copyWith(
        color: CupertinoColors.black,
        fontSize: 18,
      ),
      navTitleTextStyle: _baseTextStyle.copyWith(
        color: CupertinoColors.black,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
  );

  static final CupertinoThemeData darkTheme = CupertinoThemeData(
    brightness: Brightness.dark,
    primaryColor: CupertinoColors.systemRed,
    barBackgroundColor: CupertinoColors.black,
    scaffoldBackgroundColor: CupertinoColors.black,
    textTheme: CupertinoTextThemeData(
      primaryColor: CupertinoColors.white,
      textStyle: _baseTextStyle.copyWith(
        color: CupertinoColors.white,
        fontSize: 18,
      ),
      navTitleTextStyle: _baseTextStyle.copyWith(
        color: CupertinoColors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}