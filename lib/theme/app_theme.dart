import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Color palette
  static const Color darkBlue = Color(0xFF0A1929);
  static const Color deepBlue = Color(0xFF132F4C);
  static const Color darkPurple = Color(0xFF1A0B2E);
  static const Color deepPurple = Color(0xFF2D1B47);
  static const Color accentCyan = Color(0xFF4DD0E1);
  static const Color accentBlue = Color(0xFF42A5F5);
  static const Color glowWhite = Color(0xFFE3F2FD);
  static const Color textPrimary = Color(0xFFECEFF1);
  static const Color textSecondary = Color(0xFFB0BEC5);

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: darkBlue,
    primaryColor: accentCyan,
    cardColor: deepBlue,
    colorScheme: const ColorScheme.dark(
      primary: accentCyan,
      secondary: accentBlue,
      surface: deepBlue,
      onPrimary: Colors.black,
      onSecondary: Colors.black,
      onSurface: textPrimary,
    ),
    textTheme: GoogleFonts.interTextTheme(
      const TextTheme(
        displayLarge: TextStyle(color: glowWhite, fontWeight: FontWeight.bold),
        displayMedium: TextStyle(color: glowWhite, fontWeight: FontWeight.bold),
        displaySmall: TextStyle(color: glowWhite, fontWeight: FontWeight.bold),
        headlineMedium:
            TextStyle(color: glowWhite, fontWeight: FontWeight.w600),
        headlineSmall: TextStyle(color: glowWhite, fontWeight: FontWeight.w600),
        titleLarge: TextStyle(color: textPrimary, fontWeight: FontWeight.w600),
        titleMedium: TextStyle(color: textPrimary, fontWeight: FontWeight.w500),
        titleSmall: TextStyle(color: textPrimary, fontWeight: FontWeight.w500),
        bodyLarge: TextStyle(color: textPrimary),
        bodyMedium: TextStyle(color: textPrimary),
        bodySmall: TextStyle(color: textSecondary),
        labelLarge: TextStyle(color: textPrimary),
      ),
    ),
    cardTheme: CardThemeData(
      color: deepBlue,
      elevation: 4,
      shadowColor: Colors.black.withAlpha(128),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    iconTheme: const IconThemeData(
      color: accentCyan,
    ),
  );
}
