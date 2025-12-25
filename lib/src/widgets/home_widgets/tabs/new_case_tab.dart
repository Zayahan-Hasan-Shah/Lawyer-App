import 'package:flutter/material.dart';
import 'package:lawyer_app/src/core/constants/app_colors.dart';
import 'package:lawyer_app/src/widgets/common_widgets/custom_text.dart';
import 'package:sizer/sizer.dart';

class NewCaseTab extends StatelessWidget {
  const NewCaseTab({super.key});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.add_circle, size: 90, color: AppColors.brightYellowColor),
          SizedBox(height: 3.h),
          CustomText(
            title: "File New Case",
            fontSize: 24.sp,
            weight: FontWeight.bold,
            color: AppColors.whiteColor,
          ),
          SizedBox(height: 2.h),
          ElevatedButton.icon(
            onPressed: () {},
            icon: Icon(Icons.upload_file, color: AppColors.blackColor),
            label: Text(
              "Start Application",
              style: TextStyle(
                color: AppColors.blackColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            style: ElevatedButton.styleFrom(
              // backgroundBuilder: (_, __, ___) => AppColors.buttonGradientColor,
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
