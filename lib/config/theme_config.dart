import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemeConfig {
  static final _baseTextStyle = GoogleFonts.nunito();

  static final CupertinoThemeData lightTheme = CupertinoThemeData(
    brightness: Brightness.light,
    primaryColor: CupertinoColors.systemRed,
    textTheme: CupertinoTextThemeData(
      textStyle: _baseTextStyle.copyWith(
        color: CupertinoColors.black,
        fontSize: 16,
      ),
      navActionTextStyle: _baseTextStyle.copyWith(
        color: CupertinoColors.black,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    ),
  );

  static final CupertinoThemeData darkTheme = CupertinoThemeData(
    brightness: Brightness.dark,
    primaryColor: CupertinoColors.systemRed,
    textTheme: CupertinoTextThemeData(
      textStyle: _baseTextStyle.copyWith(
        color: CupertinoColors.white,
        fontSize: 16,
      ),
      navActionTextStyle: _baseTextStyle.copyWith(
        color: CupertinoColors.white,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    ),
  );

  // Colors
  static Color backgroundSurfaceColor(BuildContext context) {
    final brightness = CupertinoTheme.of(context).brightness;
    return brightness == Brightness.light
        ? Color(0xFFF2F2F7)
        : Color(0xFF2C2C2C);
  }

  static Color backgroundInputColor(BuildContext context) {
    final brightness = CupertinoTheme.of(context).brightness;
    return brightness == Brightness.light
        ? CupertinoColors.systemGrey6
        : Color(0xFF1C1C1E);
  }

  static Color borderColor(BuildContext context) {
    final brightness = CupertinoTheme.of(context).brightness;
    return brightness == Brightness.light
        ? Color(0xFFD1D1D6)
        : Color(0xFF8E8E93);
  }

  static Color accentErrorColor(BuildContext context) {
    return CupertinoColors.systemRed;
  }

  static Color textSecondaryColor(BuildContext context) {
    final brightness = CupertinoTheme.of(context).brightness;
    return brightness == Brightness.light
        ? CupertinoColors.systemGrey
        : CupertinoColors.systemGrey;
  }

  static Color iconSecondaryColor(BuildContext context) {
    final brightness = CupertinoTheme.of(context).brightness;
    return brightness == Brightness.light
        ? Color(0xFF000000).withAlpha(204)
        : Color(0xFFFFFFFF).withAlpha(204);
  }

  static Color navBackgroundColor(BuildContext context) {
    final brightness = CupertinoTheme.of(context).brightness;
    return brightness == Brightness.light
        ? Color(0xFFF2F2F7)
        : Color(0xFF2C2C2C);
  }

  static Color navSelectedItemColor(BuildContext context) {
    final brightness = CupertinoTheme.of(context).brightness;
    return brightness == Brightness.light
        ? Color(0xFFFFFFFF)
        : Color(0xFF3A3A3C);
  }

  static Color loaderOnPrimaryColor() {
    return Color(0xFF3A3A3C);
  }

  // Border Radiuses
  static BorderRadius get radiusDefault => BorderRadius.circular(8.0);
  static BorderRadius get radiusInput => BorderRadius.circular(12.0);
  static BorderRadius get radiusButton => BorderRadius.circular(8.0);
  static BorderRadius get radiusPill => BorderRadius.circular(30.0);

  static double get borderWidth => 1.0;

  static BorderSide standardBorder(BuildContext context) {
    return BorderSide(
      color: borderColor(context),
      width: borderWidth,
    );
  }

  static BorderSide errorBorder(BuildContext context) {
    return BorderSide(
      color: accentErrorColor(context).withAlpha(179),
      width: borderWidth,
    );
  }

  // Spacing
  static const double spacingLarge = 24.0;
  static const double spacingMedium = 16.0;
  static const double spacingSmall = 8.0;
  static const double spacingTiny = 4.0;

  // Animation Durations
  static const Duration durationNormal = Duration(milliseconds: 300);
  static const Duration durationFast = Duration(milliseconds: 200);

  // Text Styles
  static TextStyle textHeadingLarge(BuildContext context) {
    return _baseTextStyle.copyWith(
      fontSize: 28,
      fontWeight: FontWeight.w800,
      color: CupertinoTheme.of(context).textTheme.textStyle.color,
    );
  }

  static TextStyle textHeadingMedium(BuildContext context) {
    return _baseTextStyle.copyWith(
      fontSize: 20,
      color: textSecondaryColor(context),
      fontWeight: FontWeight.w300,
    );
  }

  static TextStyle textButton(BuildContext context) {
    return _baseTextStyle.copyWith(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: CupertinoColors.white,
    );
  }

  static TextStyle textError(BuildContext context) {
    return _baseTextStyle.copyWith(
      fontSize: 12,
      color: accentErrorColor(context),
    );
  }
}
