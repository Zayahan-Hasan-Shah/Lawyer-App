import 'package:flutter/material.dart';
import 'package:lawyer_app/src/core/constants/app_colors.dart';
import 'package:lawyer_app/src/widgets/common_widgets/custom_text.dart';
import 'package:sizer/sizer.dart';

class StepperHeader extends StatelessWidget {
  final int currentStep;
  final List<String> steps;
  final VoidCallback? onBackPressed;

  const StepperHeader({
    super.key,
    required this.currentStep,
    required this.steps,
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 2.h),
        Row(
          children: [
            if (currentStep > 0)
              GestureDetector(
                onTap: onBackPressed,
                child: Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: AppColors.inputBackgroundColor,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.brightYellowColor.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Icon(
                    Icons.chevron_left,
                    color: AppColors.brightYellowColor,
                    size: 24.sp,
                  ),
                ),
              ),
            SizedBox(width: 4.w),
            Expanded(
              child: Column(
                children: [
                  CustomText(
                    title: "New Case Application",
                    fontSize: 20.sp,
                    weight: FontWeight.bold,
                    color: AppColors.whiteColor,
                    alignText: TextAlign.center,
                  ),
                  SizedBox(height: 0.5.h),
                  CustomText(
                    title: steps[currentStep],
                    color: AppColors.brightYellowColor,
                    fontSize: 14.sp,
                    weight: FontWeight.w500,
                  ),
                ],
              ),
            ),
            if (currentStep > 0) SizedBox(width: 10.w),
          ],
        ),
        SizedBox(height: 2.h),
        _progressIndicator(),
        SizedBox(height: 1.h),
        _dots(),
        SizedBox(height: 2.h),
      ],
    );
  }

  Widget _progressIndicator() {
    return Stack(
      children: [
        Container(
          height: 4,
          decoration: BoxDecoration(
            color: AppColors.hintTextColor.withOpacity(0.2),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        FractionallySizedBox(
          widthFactor: (currentStep + 1) / steps.length,
          child: Container(
            height: 4,
            decoration: BoxDecoration(
              gradient: AppColors.buttonGradientColor,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: AppColors.brightYellowColor.withOpacity(0.5),
                  blurRadius: 8,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _dots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        steps.length,
        (i) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: EdgeInsets.symmetric(horizontal: 1.w),
          width: currentStep == i ? 12 : 8,
          height: currentStep == i ? 12 : 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: currentStep >= i ? AppColors.buttonGradientColor : null,
            color: currentStep >= i
                ? null
                : AppColors.hintTextColor.withOpacity(0.3),
            boxShadow: currentStep == i
                ? [
                    BoxShadow(
                      color: AppColors.brightYellowColor.withOpacity(0.5),
                      blurRadius: 8,
                    ),
                  ]
                : null,
          ),
        ),
      ),
    );
  }
}
