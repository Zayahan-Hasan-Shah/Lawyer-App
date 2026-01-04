import 'package:flutter/material.dart';
import 'package:lawyer_app/src/core/constants/app_colors.dart';
import 'package:lawyer_app/src/widgets/common_widgets/custom_text.dart';
import 'package:sizer/sizer.dart';

class ProfileStatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const ProfileStatCard({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.8.h),
        decoration: BoxDecoration(
          color: AppColors.inputBackgroundColor,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.iconColor.withOpacity(0.25)),
        ),
        child: Row(
          children: [
            Container(
              width: 4.h,
              height: 4.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.iconColor.withOpacity(0.18),
              ),
              child: Icon(icon, size: 3.h, color: AppColors.brightYellowColor),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    title: label,
                    fontSize: 14.sp,
                    color: AppColors.lightDescriptionTextColor,
                    maxLines: 2,
                  ),
                  SizedBox(height: 0.3.h),
                  CustomText(
                    title: value,
                    fontSize: 16.sp,
                    weight: FontWeight.bold,
                    color: AppColors.whiteColor,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
