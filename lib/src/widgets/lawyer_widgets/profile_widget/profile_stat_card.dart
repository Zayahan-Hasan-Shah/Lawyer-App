import 'package:flutter/material.dart';
import 'package:lawyer_app/src/core/constants/app_colors.dart';
import 'package:lawyer_app/src/widgets/common_widgets/custom_text.dart';
import 'package:sizer/sizer.dart';

class ProfileStatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const ProfileStatCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 2.2.h, horizontal: 3.w),
        decoration: BoxDecoration(
          color: AppColors.kSurface.withOpacity(0.88),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.kEmerald.withOpacity(0.18)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.kEmerald, size: 4.h),
            SizedBox(height: 1.2.h),
            CustomText(
              title: value,
              color: AppColors.kTextPrimary,
              fontSize: 20.sp,
              weight: FontWeight.w800,
            ),
            SizedBox(height: 0.4.h),
            CustomText(
              title: label,
                color: AppColors.kTextSecondary,
                fontSize: 14.sp,
              alignText: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}