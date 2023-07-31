import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colors.dart';

/// SchemeColors
const colorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: mainBlue,
  onPrimary: darkBlue,
  secondary: highlightRed,
  onSecondary: mainBlue,
  error: highlightError,
  onError: highlightError,
  background: mainWhite,
  onBackground: mainGrey,
  surface: mainWhite,
  onSurface: mainGrey,
);

const bottomNavigationBarTheme = BottomNavigationBarThemeData(
  backgroundColor: mainWhite,
  elevation: 0,
);

final inputDecorationTheme = InputDecorationTheme(
  filled: true,
  suffixIconColor: filledColorInput,
  fillColor: filledColorInput.withOpacity(0.4),
  border: OutlineInputBorder(
    borderSide: const BorderSide(color: filledColorInput, width: 0.5),
    borderRadius: BorderRadius.circular(10.0),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: const BorderSide(color: filledColorInput, width: 0.5),
    borderRadius: BorderRadius.circular(10.0),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: const BorderSide(color: filledColorInput, width: 0.5),
    borderRadius: BorderRadius.circular(10.0),
  ),
  errorBorder: OutlineInputBorder(
    borderSide: const BorderSide(color: highlightError, width: 0.5),
    borderRadius: BorderRadius.circular(10.0),
  ),
  hintStyle: const TextStyle(
    color: darkGrey,
    fontWeight: FontWeight.bold,
  ),
  errorStyle: const TextStyle(
    color: darkGrey,
    fontWeight: FontWeight.bold,
  ),
);

const cupertinoOverrideTheme = CupertinoThemeData(
  primaryColor: mainBlue,
  textTheme: CupertinoTextThemeData(
    textStyle: TextStyle(letterSpacing: 0),
  ),
);

const appBarTheme = AppBarTheme(
  backgroundColor: colorWhite,
  elevation: 0,
  centerTitle: true,
);

final appTheme = ThemeData(
  primaryColor: mainBlue,
  scaffoldBackgroundColor: scaffold,
  textTheme: GoogleFonts.assistantTextTheme(GoogleFonts.jostTextTheme()),
  cupertinoOverrideTheme: cupertinoOverrideTheme,
  bottomNavigationBarTheme: bottomNavigationBarTheme,
  inputDecorationTheme: inputDecorationTheme,
  appBarTheme: appBarTheme,
  colorScheme: colorScheme.copyWith(error: highlightError),
);
