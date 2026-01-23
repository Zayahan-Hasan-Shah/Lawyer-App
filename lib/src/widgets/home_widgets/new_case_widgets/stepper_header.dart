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
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: AppColors.kSurface.withOpacity(0.88),
        border: Border(
          bottom: BorderSide(
            color: AppColors.kEmerald.withOpacity(0.15),
            width: 1.2,
          ),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Back button (only when not on first step)
              if (currentStep > 0)
                GestureDetector(
                  onTap: onBackPressed,
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.kEmerald.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: AppColors.kEmerald,
                      size: 24,
                    ),
                  ),
                )
              else
                const SizedBox(width: 48), // placeholder for symmetry
              // Title & current step
              Column(
                children: [
                  CustomText(
                    title: "New Case Application",
                    fontSize: 18.sp,
                    weight: FontWeight.w800,
                    color: AppColors.kTextPrimary,
                  ),
                  SizedBox(height: 0.6.h),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 3.w,
                      vertical: 0.6.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.kEmerald.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: CustomText(
                      title: steps[currentStep],
                      color: AppColors.kEmerald,
                      fontSize: 14.5.sp,
                      weight: FontWeight.w600,
                    ),
                  ),
                ],
              ),

              // Placeholder for symmetry when no back button
              if (currentStep == 0) const SizedBox(width: 48),
            ],
          ),

          SizedBox(height: 3.h),

          // Progress bar + dots
          _progressIndicator(),
          SizedBox(height: 2.5.h),
          _dots(),
        ],
      ),
    );
  }

  Widget _progressIndicator() {
    return Stack(
      alignment: Alignment.centerLeft,
      children: [
        // Background track
        Container(
          height: 6,
          decoration: BoxDecoration(
            color: AppColors.kEmerald.withOpacity(0.12),
            borderRadius: BorderRadius.circular(10),
          ),
        ),

        // Filled progress with emerald gradient
        FractionallySizedBox(
          widthFactor: (currentStep + 1) / steps.length,
          child: Container(
            height: 6,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.kEmerald, AppColors.kEmeraldDark],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: AppColors.kEmerald.withOpacity(0.45),
                  blurRadius: 12,
                  spreadRadius: 2,
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
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOutCubic,
          margin: EdgeInsets.symmetric(horizontal: 1.5.w),
          width: currentStep == i ? 14 : 10,
          height: currentStep == i ? 14 : 10,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: currentStep >= i
                ? AppColors.kEmerald
                : AppColors.kSurface.withOpacity(0.6),
            border: Border.all(
              color: currentStep == i ? AppColors.kEmerald : Colors.transparent,
              width: 2,
            ),
            boxShadow: currentStep == i
                ? [
                    BoxShadow(
                      color: AppColors.kEmerald.withOpacity(0.5),
                      blurRadius: 12,
                      spreadRadius: 2,
                    ),
                  ]
                : null,
          ),
        ),
      ),
    );
  }
}
