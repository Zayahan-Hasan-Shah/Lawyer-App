import 'package:flutter/material.dart';
import 'package:lawyer_app/src/core/constants/app_colors.dart';
import 'package:lawyer_app/src/models/bottom_navigation_model/bottom_nav_item.dart';
import 'package:sizer/sizer.dart';

class CustomBottomNavbar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<BottomNavItem> items;

  const CustomBottomNavbar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      height: 8.5.h,
      padding: EdgeInsets.only(bottom: 0.9.h),
      color: Colors.transparent,
      child: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.symmetric(horizontal: 4.w),
        decoration: BoxDecoration(
          color: colorScheme.surface.withOpacity(0.92),
          borderRadius: BorderRadius.circular(26),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.35),
              blurRadius: 24,
              spreadRadius: 0,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(26),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final isActive = index == currentIndex;

              return Expanded(
                child: InkWell(
                  onTap: () => onTap(index),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildNavIcon(
                        icon: isActive ? item.activeIcon : item.inactiveIcon,
                        isActive: isActive,
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildNavIcon({required IconData icon, required bool isActive}) {
    final colorScheme = ColorScheme.fromSeed(seedColor: AppColors.brightYellowColor);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      height: 5.h,
      curve: Curves.easeOutCubic,
      padding: EdgeInsets.symmetric(
        horizontal: isActive ? 4.w : 0,
        vertical: 0.5.h,
      ),
      decoration: BoxDecoration(
        color:
            isActive ? colorScheme.primary.withOpacity(0.15) : Colors.transparent,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Icon(
        icon,
        size: isActive ? 3.1.h : 2.8.h,
        color: isActive
            ? colorScheme.primary
            : Colors.white.withOpacity(0.65),
      ),
    );
  }
}
