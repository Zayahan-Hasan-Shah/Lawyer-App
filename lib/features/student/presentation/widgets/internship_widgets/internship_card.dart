import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lawyer_app/core/constants/app_colors.dart';
import 'package:lawyer_app/features/student/data/models/internship_model/internship_model.dart';
import 'package:lawyer_app/shared/widgets/custom_text.dart';
import 'package:sizer/sizer.dart';

class InternshipCard extends StatelessWidget {
  const InternshipCard({
    super.key,
    required this.context,
    required this.internship,
  });

  final BuildContext context;
  final InternshipModel internship;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.kSurface.withValues(alpha: 0.8),
            AppColors.kSurfaceElevated.withValues(alpha: 0.6),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.kEmerald.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            context.push('/internshipdetailscreen', extra: internship);
          },
          child: Padding(
            padding: EdgeInsets.all(4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(2.w),
                      decoration: BoxDecoration(
                        color: AppColors.kEmerald.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.business_center,
                        color: AppColors.kEmerald,
                        size: 6.w,
                      ),
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            title: internship.title,
                            fontSize: 16.sp,
                            weight: FontWeight.w600,
                            color: AppColors.kTextPrimary,
                          ),
                          CustomText(
                            title: internship.company,
                            fontSize: 14.sp,
                            color: AppColors.kEmerald,
                            weight: FontWeight.w500,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      size: 14,
                      color: AppColors.kEmerald,
                    ),
                    SizedBox(width: 1.w),
                    CustomText(
                      title: internship.location,
                      fontSize: 12.sp,
                      color: AppColors.kTextSecondary,
                    ),
                    SizedBox(width: 4.w),
                    Icon(Icons.schedule, size: 14, color: AppColors.kEmerald),
                    SizedBox(width: 1.w),
                    CustomText(
                      title: internship.duration,
                      fontSize: 12.sp,
                      color: AppColors.kTextSecondary,
                    ),
                  ],
                ),
                SizedBox(height: 1.h),
                Row(
                  children: [
                    Icon(
                      Icons.attach_money,
                      size: 14,
                      color: AppColors.kEmerald,
                    ),
                    SizedBox(width: 1.w),
                    CustomText(
                      title: internship.stipend,
                      fontSize: 12.sp,
                      color: AppColors.kTextSecondary,
                    ),
                    SizedBox(width: 4.w),
                    Icon(
                      Icons.calendar_today,
                      size: 14,
                      color: AppColors.kEmerald,
                    ),
                    SizedBox(width: 1.w),
                    CustomText(
                      title: "Posted: ${internship.postedDate}",
                      fontSize: 12.sp,
                      color: AppColors.kTextSecondary,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

