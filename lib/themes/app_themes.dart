import 'package:flutter/material.dart';

class AppThemes {
  static const Color primary = Colors.indigo;
  static const Color appBarColor = Colors.indigo;

  //Light theme
  static final ThemeData lighTheme = ThemeData.light().copyWith(
    //Color primario
    primaryColor: primary,
    //AppBar Theme
    appBarTheme: const AppBarTheme(
      color: appBarColor,
      elevation: 0,
    ),
  );

  //Dark theme
  static final ThemeData darkTheme = ThemeData.dark().copyWith(
    //Color primario
    primaryColor: primary,
    //AppBar Theme
    appBarTheme: const AppBarTheme(
      color: appBarColor,
      elevation: 0,
    ),
    //Scaffold color
    scaffoldBackgroundColor: Colors.grey.shade900,
    //General Buttons theme
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        primary: AppThemes.primary,
      ),
    ),

    //Floating action button theme
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primary,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        primary: primary,
        shape: const StadiumBorder(),
      ),
    ),

    //Input decoration theme
    inputDecorationTheme: const InputDecorationTheme(
      floatingLabelStyle: TextStyle(color: primary),
      //Enabled border
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: primary),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      //Focused border
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.green),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
    ),
  );
}
