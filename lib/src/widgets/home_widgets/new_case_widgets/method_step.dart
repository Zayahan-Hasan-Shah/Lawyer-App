import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:lawyer_app/src/core/constants/app_colors.dart';
import 'package:lawyer_app/src/widgets/common_widgets/custom_text.dart';
import 'package:sizer/sizer.dart';

class MethodStep extends StatelessWidget {
  final String? selectedMethod;
  final ValueChanged<String> onMethodSelected;

  const MethodStep({
    super.key,
    required this.selectedMethod,
    required this.onMethodSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          title: "How would you like to proceed?",
          fontSize: 20.sp,
          weight: FontWeight.w700,
          color: AppColors.kTextPrimary,
        ),
        SizedBox(height: 1.h),
        CustomText(
          title: "Choose your preferred method to submit case details",
          fontSize: 15.sp,
          color: AppColors.kTextSecondary,
          maxLines: 2,
        ),
        SizedBox(height: 4.h),

        // Upload method card
        _methodCard(
          title: "Upload Documents",
          subtitle: "Securely upload files (PDF, images, etc.)",
          icon: Icons.upload_file_rounded,
          value: "upload",
        ),

        SizedBox(height: 2.5.h),

        // WhatsApp method card
        _methodCard(
          title: "Continue via WhatsApp",
          subtitle: "Chat directly with our team for quick assistance",
          icon: Icons.phone_enabled_sharp,
          value: "whatsapp",
          isWhatsApp: true,
        ),
      ],
    );
  }

  Widget _methodCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required String value,
    bool isWhatsApp = false,
  }) {
    final isSelected = selectedMethod == value;

    return GestureDetector(
      onTap: () => onMethodSelected(value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeOutCubic,
        padding: EdgeInsets.all(2.w),
        decoration: BoxDecoration(
          color: AppColors.kSurface.withOpacity(0.92),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? AppColors.kEmerald.withOpacity(0.65)
                : AppColors.kEmerald.withOpacity(0.15),
            width: isSelected ? 2.2 : 1.2,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.kEmerald.withOpacity(0.38),
                    blurRadius: 20,
                    spreadRadius: 3,
                    offset: const Offset(0, 6),
                  ),
                  BoxShadow(
                    color: Colors.black.withOpacity(0.28),
                    blurRadius: 24,
                    offset: const Offset(0, 10),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.22),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon container
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                gradient: isSelected
                    ? LinearGradient(
                        colors: [
                          AppColors.kEmerald.withOpacity(0.35),
                          AppColors.kEmeraldDark.withOpacity(0.15),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : null,
                color: isSelected ? null : AppColors.kEmerald.withOpacity(0.08),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                icon,
                size: 4.h,
                color: isSelected ? Colors.white : AppColors.kEmerald,
              ),
            ),
            SizedBox(width: 5.w),

            // Text content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    title: title,
                    fontSize: 17.sp,
                    weight: isSelected ? FontWeight.w700 : FontWeight.w600,
                    color: isSelected
                        ? AppColors.kEmerald
                        : AppColors.kTextPrimary,
                  ),
                  SizedBox(height: 0.5.h),
                  CustomText(
                    title: subtitle,
                    color: AppColors.kTextSecondary,
                    fontSize: 14.sp,
                    maxLines: 2,
                  ),
                ],
              ),
            ),

            // Selection indicator
            if (isSelected)
              Icon(
                Icons.check_circle_rounded,
                color: AppColors.kEmerald,
                size: 28,
              ),
          ],
        ),
      ),
    );
  }
}