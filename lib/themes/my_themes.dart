import 'package:flutter/material.dart';

/*
  COLOR PALETTE
  We can change this later on for a better color palette
   */

ThemeData myThemes = ThemeData(
  colorScheme: ColorScheme.light(
    primary: Colors.grey.shade200,
    secondary: Colors.white,
    tertiary: Colors.grey.shade100,
    surface: Colors.grey.shade300,
    inversePrimary: Colors.grey.shade600,
  ),
);

ThemeData myDarkTheme = ThemeData.dark().copyWith(
  colorScheme: const ColorScheme.dark(
    surface: Color(0xFF121212),
    // page background
    tertiary: Color(0xFF1E1E1E),
    // cards / sheets
    inversePrimary: Colors.white,
    // main text
    primary: Colors.green,
    // accent colour
    secondary: Color(0xFF1E1E1E), // input / card background
  ),

  scaffoldBackgroundColor: const Color(0xFF121212),

  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.transparent,
    foregroundColor: Colors.white,
    elevation: 0,
  ),

  drawerTheme: const DrawerThemeData(backgroundColor: Color(0xFF121212)),

  cardColor: const Color(0xFF1E1E1E),

  iconTheme: const IconThemeData(color: Colors.white70),

  listTileTheme: const ListTileThemeData(
    textColor: Colors.white,
    iconColor: Colors.white70,
  ),

  // GLOBAL TEXT COLOURS
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Colors.white),

    bodyMedium: TextStyle(color: Colors.white70),

    bodySmall: TextStyle(color: Colors.white60),

    titleLarge: TextStyle(color: Colors.white),

    titleMedium: TextStyle(color: Colors.white70),

    titleSmall: TextStyle(color: Colors.white60),
  ),

  // TEXT FIELD DESIGN
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: const Color(0xFF1E1E1E),

    hintStyle: TextStyle(color: Colors.grey.shade400),

    labelStyle: const TextStyle(color: Colors.white),

    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(color: Colors.grey.shade800),
    ),

    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: Colors.green, width: 1.5),
    ),
  ),

  // CURSOR COLOR
  textSelectionTheme: const TextSelectionThemeData(cursorColor: Colors.white),

  // BUTTON DESIGN
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.green,
      foregroundColor: Colors.white,
      elevation: 0,

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    ),
  ),
);