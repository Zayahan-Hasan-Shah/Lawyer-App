import 'package:flutter/material.dart';
import 'package:lawyer_app/core/constants/app_colors.dart';
import 'package:lawyer_app/shared/widgets/custom_button.dart';
import 'package:lawyer_app/shared/widgets/custom_text.dart';
import 'package:sizer/sizer.dart';

class FailedWidget extends StatelessWidget {
  final String text;
  final IconData icon;
  final String title;
  final VoidCallback? onRetry;
  const FailedWidget({
    super.key,
    required this.text,
    required this.icon,
    required this.title,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, size: 10.h, color: Colors.redAccent),
          SizedBox(height: 1.h),
          CustomText(title: title, fontSize: 20.sp, color: AppColors.whiteColor),
          SizedBox(height: 4.h),
          CustomText(
            title: text,
            fontSize: 14.sp,
            color: AppColors.whiteColor,
            alignText: TextAlign.center,
          ),
          SizedBox(height: 4.h),
          CustomButton(
            text: "Retry",
            onPressed: onRetry,
            fontSize: 18.sp,
            textColor: Colors.white,
            backgroundColor: AppColors.kEmerald,
          ),
        ],
      ),
    );
  }
}
