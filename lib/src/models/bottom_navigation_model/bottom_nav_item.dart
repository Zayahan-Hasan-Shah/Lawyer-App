import 'package:flutter/material.dart';

class BottomNavItem {
  final IconData activeIcon;
  final IconData inactiveIcon;
  final String label;

  BottomNavItem({
    required this.activeIcon,
    required this.inactiveIcon,
    required this.label,
  });
}