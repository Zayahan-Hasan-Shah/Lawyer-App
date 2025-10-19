import 'package:flutter/material.dart';
import 'package:lawyer_app/src/core/constants/app_assets.dart';
import 'package:lawyer_app/src/core/constants/app_colors.dart';
import 'package:lawyer_app/src/widgets/common_widgets/custom_text.dart';
import 'package:sizer/sizer.dart';

class PayAndProceedWidget extends StatelessWidget {
  const PayAndProceedWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 2,
            child: SizedBox(
              height: 55.h,
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(AppAssets.onboardingImage2, fit: BoxFit.cover),
                  Container(color: AppColors.backgroundColor.withOpacity(0.1)),
                ],
              ),
            ),
          ),
          SizedBox(height: 2.h),
          Expanded(
            child: Column(
              children: [
                CustomText(
                  title: 'Pay and proceed',
                  color: Colors.white,
                  fontSize: 22.sp,
                  weight: FontWeight.w600,
                ),

                SizedBox(height: 1.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: Text(
                    'After booking the date of appointment with the lawyer\nthe final step of this process is to  pay with any\ncomfortable mode of payment and get confirmation.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: const Color(0xFF9E9E9E),
                      fontSize: 14.sp,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 4.h),
        ],
      ),
    );
  }
}
