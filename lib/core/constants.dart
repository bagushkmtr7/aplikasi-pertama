import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Colors.teal;
  static const Color accent = Color(0xFF004D40);
  static const Color background = Color(0xFFF5F5F5);
}

class AppTheme {
  static ThemeData get light => ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
    useMaterial3: true,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      centerTitle: true,
    ),
  );
}
