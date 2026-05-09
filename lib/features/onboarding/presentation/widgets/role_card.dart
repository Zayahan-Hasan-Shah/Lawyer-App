import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:lawyer_app/core/constants/app_colors.dart';
import 'package:lawyer_app/shared/widgets/custom_button.dart';
import 'package:lawyer_app/shared/widgets/custom_text.dart';
import 'package:sizer/sizer.dart';

class RoleCard extends StatelessWidget {
  final String title;
  final String description;
  final String imagePath;
  final String buttonText;
  final VoidCallback onGetStarted;
  final bool isComingSoon;

  const RoleCard({
    super.key,
    required this.title,
    required this.description,
    required this.imagePath,
    required this.buttonText,
    required this.onGetStarted,
    this.isComingSoon = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 2.h),
      decoration: BoxDecoration(
        color: AppColors.kSurface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColors.kGold.withOpacity(0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Image Section
              Container(
                height: 25.h,
                decoration: BoxDecoration(
                  color: AppColors.kSurfaceElevated,
                  image: DecorationImage(
                    image: AssetImage(imagePath),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              
              // Content Section
              Padding(
                padding: EdgeInsets.all(3.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      title: title,
                      fontSize: 22.sp,
                      weight: FontWeight.w800,
                      color: AppColors.kGoldLight,
                    ),
                    SizedBox(height: 1.h),
                    CustomText(
                      title: description,
                      fontSize: 15.sp,
                      maxLines: 3,
                      color: AppColors.kTextSecondary,
                      textHeight: 1.4,
                    ),
                    SizedBox(height: 3.h),
                    
                    isComingSoon
                        ? Container(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: AppColors.kSurfaceElevated,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: AppColors.kBorderSubtle),
                            ),
                            child: CustomText(
                              title: "Coming Soon",
                              color: AppColors.kTextSecondary,
                              weight: FontWeight.w600,
                              fontSize: 16.sp,
                            ),
                          )
                        : CustomButton(
                            text: buttonText,
                            onPressed: onGetStarted,
                            gradient: AppColors.goldGradient,
                            width: double.infinity,
                            textColor: Colors.black,
                          ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
