import 'package:flutter/material.dart';

class AppColors {
  static const Color kBg = Color(0xFF0D1117); // Very deep almost black
  static const Color kSurface = Color(0xFF161B22); // Cards base
  static const Color kSurfaceElevated = Color(0xFF1F2937); // Slight lift
  static const Color kEmerald = Color(0xFF10B981); // Main accent
  static const Color kEmeraldDark = Color(0xFF059669);
  static const Color kSilver = Color(0xFFD1D5DB);
  static const Color kTextPrimary = Color(0xFFF3F4F6);
  static const Color kTextSecondary = Color(0xFF9CA3AF);
  static const kBgDark = Color(0xFF0D1117);
  static const kInputBg = Color(0xFF0F1419);
  static const kBorderSubtle = Color(0xFF30363D);
  static const btnLnGradColor = LinearGradient(
    colors: [AppColors.kEmerald, AppColors.kEmeraldDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  //=========================================================
  static const backgroundColor = Color(0xFF141718);
  static const blackColor = Colors.black;
  static const whiteColor = Colors.white;
  // gradient colors
  static const pastelYellowColor = Color(0xFFF1E763);
  static const lightYellowColor = Color(0xFFF2DC6C);
  static const yellowColor = Color(0xFFD69E0D);
  static const brightYellowColor = Color(0xFFF1C435);
  static const darkYellowColor = Color(0xFF915F22);
  // input colors
  static const inputBackgroundColor = Color(0xFF202020);
  static const hintTextColor = Color(0xFF4C4C4C);
  // icon colors
  static const iconColor = Color(0xFFDAAB1C);
  // light description text color
  static const lightDescriptionTextColor = Color(0xFF948B94);
  // case type color
  static const caseTypeBackgroundColor = Color(0xFFF1CF4E);

  static const buttonGradientColor = LinearGradient(
    colors: [
      pastelYellowColor,
      lightYellowColor,
      brightYellowColor,
      yellowColor,
      darkYellowColor,
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
