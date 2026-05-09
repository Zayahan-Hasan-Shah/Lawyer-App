import 'package:flutter/material.dart';

class AppColors {
  // === Base ===
  static const Color kBg          = Color(0xFF0A0A0A);  // Deep black
  static const Color kSurface     = Color(0xFF141414);  // Card backgrounds
  static const Color kSurfaceElevated = Color(0xFF1C1C1E); // Elevated surfaces

  // === Gold accents (metallic, shining) ===
  static const Color kEmerald        = Color(0xFFD4AF37);  // Replaced with gold but kept name to avoid breaking things instantly
  static const Color kEmeraldDark    = Color(0xFFB8860B);
  
  static const Color kGold        = Color(0xFFD4AF37);  // Primary gold
  static const Color kGoldLight   = Color(0xFFE8D48B);  // Light gold / highlights
  static const Color kGoldDark    = Color(0xFFB8860B);  // Dark gold / pressed
  static const Color kGoldShimmer = Color(0xFFF5E6A3);  // Shimmer highlight

  static const Color kSilver = Color(0xFFD1D5DB);
  static const Color kTextPrimary   = Color(0xFFF5F5F5);
  static const Color kTextSecondary = Color(0xFF9E9E9E);
  static const kBgDark = Color(0xFF0A0A0A);
  static const kInputBg = Color(0xFF121212);
  static const kBorderSubtle = Color(0xFF2A2A2A);
  static const btnLnGradColor = LinearGradient(
    colors: [Color(0xFFE8D48B), Color(0xFFD4AF37), Color(0xFFB8860B)],
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
  static const inputBackgroundColor = Color(0xFF1C1C1E);
  static const hintTextColor = Color(0xFF6E6E6E);
  // icon colors
  static const iconColor = Color(0xFFD4AF37);
  // light description text color
  static const lightDescriptionTextColor = Color(0xFF948B94);
  // case type color
  static const caseTypeBackgroundColor = Color(0xFFD4AF37);

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

  static const goldGradient = LinearGradient(
    colors: [Color(0xFFE8D48B), Color(0xFFD4AF37), Color(0xFFB8860B)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const goldShimmerGradient = LinearGradient(
    colors: [Color(0xFFD4AF37), Color(0xFFF5E6A3), Color(0xFFD4AF37)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
