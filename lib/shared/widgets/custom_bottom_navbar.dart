import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:lawyer_app/core/constants/app_colors.dart';
import 'package:sizer/sizer.dart';

class CustomBottomNavbar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final List<BottomNavigationBarItem> items;

  const CustomBottomNavbar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 5.w, right: 5.w, bottom: 3.h),
      decoration: BoxDecoration(
        color: AppColors.kSurfaceElevated.withOpacity(0.25),
        borderRadius: BorderRadius.circular(40),
        border: Border.all(
          color: Colors.white.withOpacity(0.08),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            // color: AppColors.kEmeraldDark.withOpacity(0.15),
            blurRadius: 10,
            // offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(40),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 1.w, vertical: 0.25.h),
            child: BottomNavigationBar(
              currentIndex: currentIndex,
              onTap: onTap,
              items: items,
              backgroundColor: Colors.transparent,
              elevation: 0,
              selectedItemColor: AppColors.kGold,
              unselectedItemColor: AppColors.iconColor.withOpacity(0.6),
              selectedLabelStyle: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.kGold,
              ),
              unselectedLabelStyle: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.iconColor.withOpacity(0.6),
              ),
              type: BottomNavigationBarType.fixed,
              showSelectedLabels: items.any((item) => item.label != null && item.label!.isNotEmpty),
              showUnselectedLabels: items.any((item) => item.label != null && item.label!.isNotEmpty),
            ),
          ),
        ),
      ),
    );
  }
}
