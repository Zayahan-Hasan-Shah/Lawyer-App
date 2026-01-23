import 'package:flutter/material.dart';
import 'package:lawyer_app/src/core/constants/app_colors.dart';
import 'package:lawyer_app/src/widgets/common_widgets/custom_text.dart';
import 'package:sizer/sizer.dart';

class ContactCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const ContactCard({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: AppColors.kSurface.withOpacity(0.88),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.kEmerald.withOpacity(0.15)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.kEmerald.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.kEmerald, size: 26),
          ),
          SizedBox(width: 4.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  title: label,
                  color: AppColors.kTextSecondary,
                  fontSize: 14.sp,
                ),
                SizedBox(height: 0.3.h),
                CustomText(
                  title: value,
                  color: AppColors.kTextPrimary,
                  fontSize: 16.sp,
                  weight: FontWeight.w500,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
