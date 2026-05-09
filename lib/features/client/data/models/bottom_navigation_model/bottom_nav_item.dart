import 'package:flutter/material.dart';

class BottomNavItem {
  final IconData? activeIcon;
  final IconData? inactiveIcon;
  final String label;

  BottomNavItem({this.activeIcon, this.inactiveIcon, required this.label});
}
