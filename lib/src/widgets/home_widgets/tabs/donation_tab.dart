import 'package:flutter/material.dart';
import 'package:lawyer_app/src/core/constants/app_colors.dart';
import 'package:lawyer_app/src/widgets/common_widgets/custom_button.dart';
import 'package:lawyer_app/src/widgets/common_widgets/custom_text.dart';
import 'package:sizer/sizer.dart';

class DonationsTab extends StatelessWidget {
  const DonationsTab({super.key});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.volunteer_activism,
            size: 100,
            color: AppColors.brightYellowColor,
          ),
          SizedBox(height: 4.h),
          CustomText(
            title: "Support Legal Aid",
            fontSize: 26.sp,
            color: AppColors.whiteColor,
            weight: FontWeight.bold,
          ),
          SizedBox(height: 1.h),
          CustomText(
            title: "Help someone get justice today",
            fontSize: 16.sp,
            color: AppColors.lightDescriptionTextColor,
          ),
          SizedBox(height: 4.h),
          CustomButton(
            text: "Donate Now",
            onPressed: () {},
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            borderRadius: 20,
            textColor: AppColors.blackColor,
            backgroundColor: Colors.white,
          ),
        ],
      ),
    );
  }
}
