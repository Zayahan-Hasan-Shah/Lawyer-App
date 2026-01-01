import 'package:flutter/material.dart';
import 'package:lawyer_app/src/core/constants/app_colors.dart';
import 'package:lawyer_app/src/widgets/common_widgets/custom_text.dart';
import 'package:sizer/sizer.dart';

class WhatsAppStep extends StatelessWidget {
  const WhatsAppStep({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(6.w),
            decoration: BoxDecoration(gradient: AppColors.buttonGradientColor, shape: BoxShape.circle),
            child: Icon(Icons.message_rounded, size: 60.sp, color: AppColors.blackColor),
          ),
          SizedBox(height: 3.h),
          CustomText(
            title: "Continue via WhatsApp",
            color: AppColors.whiteColor,
            fontSize: 22.sp,
            weight: FontWeight.bold,
            alignText: TextAlign.center,
          ),
          SizedBox(height: 2.h),
          CustomText(
            title: "Our team will guide you personally through the process",
            color: AppColors.lightDescriptionTextColor,
            fontSize: 15.sp,
            alignText: TextAlign.center,
          ),
        ],
      ),
    );
  }
}