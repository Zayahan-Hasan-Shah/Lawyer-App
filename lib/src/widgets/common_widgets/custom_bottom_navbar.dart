import 'dart:ui';
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
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 4.w,
        vertical: 2.5.h,
      ),
      child: Container(
        height: 8.h,
        decoration: BoxDecoration(
          color: AppColors.kSurface.withOpacity(0.88),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: AppColors.kEmerald.withOpacity(0.15),
            width: 1,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: items.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;
                final isActive = index == currentIndex;

                return Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => onTap(index),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOutCubic,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Icon with scale + glow effect
                          AnimatedScale(
                            scale: isActive ? 1.18 : 1.0,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeOutBack,
                            child: Container(
                              padding: EdgeInsets.all(isActive ? 10 : 8),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: isActive
                                    ? LinearGradient(
                                        colors: [
                                          AppColors.kEmerald.withOpacity(0.35),
                                          AppColors.kEmeraldDark.withOpacity(0.15),
                                        ],
                                      )
                                    : null,
                                boxShadow: isActive
                                    ? [
                                        BoxShadow(
                                          color: AppColors.kEmerald.withOpacity(0.4),
                                          blurRadius: 16,
                                          spreadRadius: 2,
                                        ),
                                      ]
                                    : null,
                              ),
                              child: Icon(
                                isActive ? item.activeIcon : item.inactiveIcon,
                                size: 26,
                                color: isActive
                                    ? AppColors.kEmerald
                                    : AppColors.kTextSecondary,
                              ),
                            ),
                          ),

                          // Optional small active indicator dot (modern style)
                          if (isActive)
                            AnimatedOpacity(
                              opacity: 1.0,
                              duration: const Duration(milliseconds: 400),
                              child: Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Container(
                                  width: 6,
                                  height: 6,
                                  decoration: BoxDecoration(
                                    color: AppColors.kEmerald,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}