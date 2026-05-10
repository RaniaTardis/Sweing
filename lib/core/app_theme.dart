import 'package:flutter/material.dart';

class AppTheme {
 
  static const Color backgroundColor = Color(0xFFFFFDF8);
  static const Color primaryBlack = Colors.black;
  static const Color accentYellow = Color(0xFFFFD471);
  static const Color accentBlue = Color(0xFFD0DAFF);

  static ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: backgroundColor,
    primaryColor: primaryBlack,
    

    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 32, 
        fontWeight: FontWeight.bold, 
        color: primaryBlack,
        letterSpacing: 1.2,
      ),
      bodyLarge: TextStyle(fontSize: 16, color: primaryBlack),
    ),


    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryBlack,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 55),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
    ),
  );
}