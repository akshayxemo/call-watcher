import 'package:call_watcher/core/config/theme/app.colors.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      fontFamily: 'Satoshi',
      // primarySwatch: Colors.blue,
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      textTheme: const TextTheme(
        titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        bodyMedium: TextStyle(fontSize: 16),
      ),
      // buttonTheme: const ButtonThemeData(
      //   buttonColor: AppColors.primary,
      //   textTheme: ButtonTextTheme.primary,
      // ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.secondary,
          side: const BorderSide(color: AppColors.secondary),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        secondary: AppColors.secondary,
        tertiary: AppColors.accentColor,
        brightness: Brightness.light,
      ),
      useMaterial3: true,
    );
  }
  static ThemeData get darkTheme {
    return ThemeData(
      fontFamily: 'Satoshi',
      // primarySwatch: Colors.blue,
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      textTheme: const TextTheme(
        titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        bodyMedium: TextStyle(fontSize: 16),
      ),
      // buttonTheme: const ButtonThemeData(
      //   buttonColor: AppColors.primary,
      //   textTheme: ButtonTextTheme.primary,
      // ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.secondary,
          side: const BorderSide(color: AppColors.secondary),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        secondary: AppColors.secondary,
        tertiary: AppColors.accentColor,
        brightness: Brightness.light,
      ),
      useMaterial3: true,
    );
  }

  // static ThemeData get darkTheme {
  //   return ThemeData(
  //     fontFamily: 'Satoshi',
  //     primarySwatch: Colors.blueGrey,
  //     primaryColor: Colors.blueGrey[900],
  //     scaffoldBackgroundColor: Colors.black,
  //     appBarTheme: const AppBarTheme(
  //       backgroundColor: Colors.blueGrey,
  //       foregroundColor: Colors.white,
  //       elevation: 0,
  //     ),
  //     textTheme: const TextTheme(
  //       titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
  //       bodyMedium: TextStyle(fontSize: 16),
  //     ),
  //     buttonTheme: const ButtonThemeData(
  //       buttonColor: Colors.blueGrey,
  //       textTheme: ButtonTextTheme.primary,
  //     ),
  //     colorScheme: ColorScheme.fromSeed(
  //       seedColor: AppColors.primary,
  //       secondary: AppColors.secondary,
  //       tertiary: AppColors.accentColor,
  //       brightness: Brightness.dark,
  //     ),
  //   );
  // }
}
