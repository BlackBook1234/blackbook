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
      inputDecorationTheme: const InputDecorationTheme(
        floatingLabelBehavior: FloatingLabelBehavior.always,
        // contentPadding: EdgeInsets.symmetric(horizontal: 42, vertical: 20),
        enabledBorder: outlineInputBorder,
        focusedBorder: outlineInputBorder,
        border: outlineInputBorder,
      ),
      visualDensity: VisualDensity.adaptivePlatformDensity,
      
      // elevatedButtonTheme: ElevatedButtonThemeData(
      //   style: ElevatedButton.styleFrom(
      //     elevation: 0,
      //     backgroundColor: kPrimaryColor,
      //     foregroundColor: Colors.white,
      //     minimumSize: const Size(double.infinity, 48),
      //     shape: const RoundedRectangleBorder(
      //       borderRadius: BorderRadius.all(Radius.circular(16)),
      //     ),
      //   ),
      // ),
    );
  }
}

const OutlineInputBorder outlineInputBorder = OutlineInputBorder(
  borderRadius: BorderRadius.all(Radius.circular(28)),
  // gapPadding: 10,
);
