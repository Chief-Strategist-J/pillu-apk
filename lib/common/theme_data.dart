import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PilluThemeData {
  static final primarySwatch = Colors.pink;
  static final visualDensity = VisualDensity.adaptivePlatformDensity;
  static final fontFamily = GoogleFonts.jost().fontFamily;

  /// EXTRA COLOR
  static final cardColor = Colors.white;
  static final Color dividerColor = Color(0xFFCCDEFF);
  static final Color errorColor = Colors.red;

  static final double globalBorderRadiusForInputField = 24;

  /// Button Style Attributes
  static final double globalActiveButtonRadius = 24;
  static final BorderSide globalActiveButtonBoarderSide = BorderSide.none;
  static final double globalActiveButtonHeight = 48;

  static final iconTheme = IconThemeData(color: Colors.black);

  static final inputDecorationTheme = InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(globalBorderRadiusForInputField)),
      borderSide: BorderSide(color: dividerColor, width: 0.7),
    ),
    disabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(globalBorderRadiusForInputField)),
      borderSide: BorderSide(color: dividerColor, width: 0.7),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(globalBorderRadiusForInputField)),
      borderSide: BorderSide(color: dividerColor, width: 0.7),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(globalBorderRadiusForInputField)),
      borderSide: BorderSide(color: errorColor, width: 0.7),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(globalBorderRadiusForInputField)),
      borderSide: BorderSide(color: primarySwatch, width: 0.7),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(globalBorderRadiusForInputField)),
      borderSide: BorderSide(color: errorColor, width: 0.7),
    ),
  );

  static ThemeData get lightThemeData {
    return ThemeData(
      primarySwatch: primarySwatch,
      fontFamily: fontFamily,
      cardColor: cardColor,
      dividerColor: dividerColor,
      iconTheme: iconTheme,
      visualDensity: visualDensity,
      inputDecorationTheme: inputDecorationTheme,
    );
  }
}
