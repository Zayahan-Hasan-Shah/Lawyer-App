import 'package:flutter/material.dart';

class AppColors {
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
