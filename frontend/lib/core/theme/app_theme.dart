import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/colors.dart';
import 'text_styles.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: MindSpaceColors.primaryBlue,
      scaffoldBackgroundColor: MindSpaceColors.warmWhite,

      // Color scheme
      colorScheme: const ColorScheme.light(
        primary: MindSpaceColors.primaryBlue,
        secondary: MindSpaceColors.calmMint,
        surface: MindSpaceColors.cardBackground,
        background: MindSpaceColors.warmWhite,
        error: MindSpaceColors.errorRed,
        onPrimary: Colors.white,
        onSecondary: MindSpaceColors.textDark,
        onSurface: MindSpaceColors.textDark,
        onBackground: MindSpaceColors.textDark,
        onError: Colors.white,
      ),

      // Text theme
      textTheme: AppTextStyles.textTheme,

      // App bar theme
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: AppTextStyles.h2.copyWith(
          color: MindSpaceColors.textDark,
        ),
        iconTheme: const IconThemeData(color: MindSpaceColors.textDark),
      ),

      // Elevated button theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: MindSpaceColors.primaryBlue,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: AppTextStyles.button,
        ),
      ),

      // Outlined button theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: MindSpaceColors.textDark,
          side: const BorderSide(color: MindSpaceColors.border, width: 1),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: AppTextStyles.button,
        ),
      ),

      // Text button theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: MindSpaceColors.primaryBlue,
          textStyle: AppTextStyles.button,
        ),
      ),

      // Input decoration theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: MindSpaceColors.cardBackground,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: MindSpaceColors.border, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: MindSpaceColors.primaryBlue,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: MindSpaceColors.errorRed,
            width: 1,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        labelStyle: AppTextStyles.body2.copyWith(
          color: MindSpaceColors.textLight,
        ),
        hintStyle: AppTextStyles.body2.copyWith(
          color: MindSpaceColors.textLight,
        ),
      ),

      // Card theme
      cardTheme: CardTheme(
        color: MindSpaceColors.cardBackground,
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }

  static ThemeData get darkTheme {
    // Dark theme implementation if needed
    return lightTheme; // For now, using light theme
  }
}
