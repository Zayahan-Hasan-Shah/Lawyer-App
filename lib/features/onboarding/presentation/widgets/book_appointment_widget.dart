import 'package:flutter/material.dart';
import 'package:lawyer_app/core/constants/app_assets.dart';
import 'package:lawyer_app/core/constants/app_colors.dart';
import 'package:lawyer_app/shared/widgets/custom_text.dart';
import 'package:sizer/sizer.dart';

class BookAppointmentWidget extends StatelessWidget {
  const BookAppointmentWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(AppAssets.onboardingImage2, fit: BoxFit.cover),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                AppColors.kBg.withOpacity(0.6),
                AppColors.kBg,
                AppColors.kBg,
              ],
              stops: const [0.0, 0.4, 0.65, 1.0],
            ),
          ),
        ),
        Positioned(
          bottom: 25.h,
          left: 6.w,
          right: 6.w,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomText(
                title: 'Seamless Booking',
                color: AppColors.kGoldLight,
                fontSize: 24.sp,
                weight: FontWeight.w800,
                alignText: TextAlign.center,
              ),
              SizedBox(height: 1.5.h),
              CustomText(
                title: 'Easily book appointments or jump into immediate video consultations with top-tier legal experts.',
                color: AppColors.kTextSecondary,
                fontSize: 15.sp,
                maxLines: 3,
                alignText: TextAlign.center,
                textHeight: 1.4,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
