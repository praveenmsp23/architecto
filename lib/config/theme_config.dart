import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

/// Theme configuration for the app
class ThemeConfig {
  // Text styles with Nunito font
  static final _baseTextStyle = GoogleFonts.nunito();
  
  static const Color _lightNavPillBackground = CupertinoColors.systemGrey6;
  static const Color _darkNavPillBackground = Color(0xFF2C2C2C);
  
  static final CupertinoThemeData lightTheme = CupertinoThemeData(
    brightness: Brightness.light,
    primaryColor: CupertinoColors.systemRed,
    primaryContrastingColor: CupertinoColors.white,
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
      tabLabelTextStyle: _baseTextStyle.copyWith(
        fontSize: 12,
      ),
      actionTextStyle: _baseTextStyle.copyWith(
        color: CupertinoColors.systemRed,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    ),
  );

  static final CupertinoThemeData darkTheme = CupertinoThemeData(
    brightness: Brightness.dark,
    primaryColor: CupertinoColors.systemRed,
    primaryContrastingColor: CupertinoColors.black,
    barBackgroundColor: Color(0xFF121212),
    scaffoldBackgroundColor: Color(0xFF121212),
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
      tabLabelTextStyle: _baseTextStyle.copyWith(
        fontSize: 12,
      ),
      actionTextStyle: _baseTextStyle.copyWith(
        color: CupertinoColors.systemRed,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    ),
  );
  
  static Color getNavPillBackgroundColor(BuildContext context) {
    final brightness = CupertinoTheme.of(context).brightness;
    return brightness == Brightness.light 
        ? _lightNavPillBackground 
        : _darkNavPillBackground;
  }
  
  static Color getNavIconColor(BuildContext context) {
    final theme = CupertinoTheme.of(context);
    final textColor = theme.textTheme.textStyle.color ?? CupertinoColors.black;
    return textColor.withAlpha(204);
  }
  
  static BorderSide getStandardBorder(BuildContext context) {
    return BorderSide(
      color: getNavPillBackgroundColor(context),
      width: 1.5,
    );
  }
}