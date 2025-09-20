import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/colors.dart';

class AppTextStyles {
  static TextStyle get _baseTextStyle =>
      GoogleFonts.inter(color: MindSpaceColors.textDark);

  // Headings
  static TextStyle get h1 => _baseTextStyle.copyWith(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    height: 1.2,
  );

  static TextStyle get h2 => _baseTextStyle.copyWith(
    fontSize: 28,
    fontWeight: FontWeight.w600,
    height: 1.3,
  );

  static TextStyle get h3 => _baseTextStyle.copyWith(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 1.3,
  );

  static TextStyle get h4 => _baseTextStyle.copyWith(
    fontSize: 20,
    fontWeight: FontWeight.w500,
    height: 1.4,
  );

  // Body text
  static TextStyle get body1 => _baseTextStyle.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  static TextStyle get body2 => _baseTextStyle.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  // Button text
  static TextStyle get button => _baseTextStyle.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    height: 1.2,
  );

  // Caption
  static TextStyle get caption => _baseTextStyle.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.4,
    color: MindSpaceColors.textLight,
  );

  // Text theme for Material Theme
  static TextTheme get textTheme => TextTheme(
    displayLarge: h1,
    displayMedium: h2,
    displaySmall: h3,
    headlineMedium: h4,
    bodyLarge: body1,
    bodyMedium: body2,
    labelLarge: button,
    bodySmall: caption,
  );
}
