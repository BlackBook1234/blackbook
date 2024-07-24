import 'package:black_book/constant.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme(BuildContext context) {
    return ThemeData(
      scaffoldBackgroundColor: kBackgroundColor,
      appBarTheme: const AppBarTheme(
          backgroundColor: kPrimarySecondColor,
          elevation: 0,
          titleTextStyle: TextStyle(color: Colors.black, fontSize: 13.0)),
      inputDecorationTheme: InputDecorationTheme(
        fillColor: Colors.white,
        filled: true,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        contentPadding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
        isDense: false,
        suffixIconColor: kTextDark,
        labelStyle: const TextStyle(
          color: kTextMedium,
          fontWeight: FontWeight.normal,
        ),
        hintStyle: const TextStyle(
          fontSize: 14,
          color: kTextMedium,
          fontWeight: FontWeight.normal,
        ),
        errorStyle: const TextStyle(
          color: kDanger,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Color(0xffECEAF5),
            width: 1,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: kDanger.withOpacity(0.5),
            width: 2,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: kDanger,
            width: 2,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: kDivider,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: kPrimaryColor,
            width: 2,
          ),
        ),
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(
          fontSize: 14,
          color: kTextDark,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          color: kTextDark,
        ),
        titleLarge: TextStyle(
          fontSize: 14,
          color: kTextMedium,
        ),
        titleMedium: TextStyle(
          color: kTextDark,
          fontWeight: FontWeight.w500,
        ),
        titleSmall: TextStyle(
          color: kTextDark,
        ),
      ),
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );
  }
}

const OutlineInputBorder outlineInputBorder = OutlineInputBorder(
  borderRadius: BorderRadius.all(Radius.circular(28)),
  // gapPadding: 10,
);
