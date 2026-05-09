import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lawyer_app/core/constants/app_colors.dart';
import 'package:sizer/sizer.dart';

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.kBg,
      primaryColor: AppColors.kGold,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.kGold,
        secondary: AppColors.kGoldLight,
        surface: AppColors.kSurface,
        onSurface: AppColors.kTextPrimary,
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.outfit(
          fontSize: 32.sp,
          fontWeight: FontWeight.w800,
          color: AppColors.kTextPrimary,
        ),
        displayMedium: GoogleFonts.outfit(
          fontSize: 28.sp,
          fontWeight: FontWeight.w700,
          color: AppColors.kTextPrimary,
        ),
        headlineLarge: GoogleFonts.outfit(
          fontSize: 24.sp,
          fontWeight: FontWeight.w700,
          color: AppColors.kTextPrimary,
        ),
        titleLarge: GoogleFonts.outfit(
          fontSize: 20.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.kTextPrimary,
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: 16.sp,
          color: AppColors.kTextPrimary,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 14.sp,
          color: AppColors.kTextSecondary,
        ),
        labelLarge: GoogleFonts.inter(
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.kGold,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.kGold),
        titleTextStyle: GoogleFonts.outfit(
          fontSize: 20.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.kTextPrimary,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.kGold,
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.kInputBg,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.kBorderSubtle, width: 1.2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.kBorderSubtle, width: 1.2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.kGold, width: 1.5),
        ),
        hintStyle: GoogleFonts.inter(color: AppColors.hintTextColor, fontSize: 14.sp),
      ),
    );
  }
}
