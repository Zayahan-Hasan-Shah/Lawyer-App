import 'dart:ui';

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
            width: 16.h,
            height: 16.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  AppColors.kEmerald.withOpacity(0.35),
                  AppColors.kEmeraldDark.withOpacity(0.15),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.kEmerald.withOpacity(0.45),
                  blurRadius: 32,
                  spreadRadius: 10,
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.35),
                  blurRadius: 40,
                  offset: const Offset(0, 20),
                ),
              ],
            ),
            child: Icon(
              Icons.phone_enabled_outlined,
              size: 11.h,
              color: Colors.white,
            ),
          ),

          SizedBox(height: 2.5.h),

          // Main title
          CustomText(
            title: "Continue via WhatsApp",
            fontSize: 20.sp,
            weight: FontWeight.w800,
            color: AppColors.kTextPrimary,
            alignText: TextAlign.center,
          ),

          SizedBox(height: 0.75.h),

          // Descriptive text
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: CustomText(
              title:
                  "Our team will guide you personally through the entire process in real-time",
              fontSize: 16.sp,
              color: AppColors.kTextSecondary,
              alignText: TextAlign.center,
              textHeight: 1.4,
            ),
          ),

          SizedBox(height: 4.h),

          // Visual hint / reassurance
          Container(
            padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
            decoration: BoxDecoration(
              color: AppColors.kSurface.withOpacity(0.88),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.kEmerald.withOpacity(0.18)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.shield_rounded, color: AppColors.kEmerald, size: 22),
                SizedBox(width: 2.5.w),
                Flexible(
                  child: CustomText(
                    title: "Secure & Confidential • Response within minutes",
                    color: AppColors.kTextSecondary,
                    fontSize: 13.8.sp,
                    alignText: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 6.h),

          // Optional small note
          Opacity(
            opacity: 0.75,
            child: CustomText(
              title: "You will be redirected to WhatsApp after confirmation",
              color: AppColors.kTextSecondary,
              fontSize: 15.sp,
              fontStyle: FontStyle.italic,
              alignText: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
