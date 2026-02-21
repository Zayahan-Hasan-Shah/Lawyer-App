import 'package:flutter/material.dart';
import 'package:lawyer_app/src/core/constants/app_colors.dart';
import 'package:lawyer_app/src/widgets/common_widgets/custom_button.dart';
import 'package:lawyer_app/src/widgets/common_widgets/custom_text.dart';
import 'package:sizer/sizer.dart';

class EmptyStateWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String? buttonText;
  final VoidCallback? onButtonPressed;

  const EmptyStateWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.buttonText,
    this.onButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 12.h,
            color: AppColors.kTextSecondary,
          ),
          SizedBox(height: 2.h),
          CustomText(
            title: title,
            fontSize: 18.sp,
            color: AppColors.kTextPrimary,
            weight: FontWeight.w600,
          ),
          SizedBox(height: 1.h),
          CustomText(
            title: subtitle,
            fontSize: 14.sp,
            color: AppColors.kTextSecondary,
            alignText: TextAlign.center,
          ),
          if (buttonText != null && onButtonPressed != null) ...[
            SizedBox(height: 3.h),
            CustomButton(
              text: buttonText!,
              onPressed: onButtonPressed,
              fontSize: 16.sp,
              textColor: Colors.white,
              backgroundColor: AppColors.kEmerald,
            ),
          ],
        ],
      ),
    );
  }
}
