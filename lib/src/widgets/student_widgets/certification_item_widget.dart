import 'package:flutter/material.dart';
import 'package:lawyer_app/src/core/constants/app_colors.dart';
import 'package:lawyer_app/src/models/student_model/certification_model.dart';
import 'package:lawyer_app/src/widgets/common_widgets/custom_button.dart';
import 'package:lawyer_app/src/widgets/common_widgets/custom_text.dart';
import 'package:sizer/sizer.dart';

class CertificationItemWidget extends StatelessWidget {
  final CertificationModel certification;
  final bool isCompleted;
  final VoidCallback? onTap;
  final VoidCallback? onEnroll;

  const CertificationItemWidget({
    super.key,
    required this.certification,
    required this.isCompleted,
    this.onTap,
    this.onEnroll,
  });

  @override
  Widget build(BuildContext context) {
    final levelColor = _getLevelColor(certification.level);

    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.kSurface.withOpacity(0.8),
            AppColors.kSurfaceElevated.withOpacity(0.6),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isCompleted 
              ? AppColors.kEmerald.withOpacity(0.5)
              : levelColor.withOpacity(0.3),
          width: isCompleted ? 2 : 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
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
                        color: isCompleted 
                            ? AppColors.kEmerald.withOpacity(0.3)
                            : levelColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        isCompleted ? Icons.verified : Icons.school_outlined,
                        color: isCompleted ? AppColors.kEmerald : levelColor,
                        size: 6.w,
                      ),
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            title: certification.title,
                            fontSize: 16.sp,
                            weight: FontWeight.w600,
                            color: AppColors.kTextPrimary,
                          ),
                          if (isCompleted)
                            Container(
                              margin: EdgeInsets.only(top: 0.5.h),
                              padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.3.h),
                              decoration: BoxDecoration(
                                color: AppColors.kEmerald.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: CustomText(
                                title: "COMPLETED",
                                fontSize: 10.sp,
                                color: AppColors.kEmerald,
                                weight: FontWeight.w600,
                              ),
                            ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                      decoration: BoxDecoration(
                        color: levelColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: CustomText(
                        title: certification.level.toUpperCase(),
                        fontSize: 10.sp,
                        color: levelColor,
                        weight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
                CustomText(
                  title: certification.description,
                  fontSize: 14.sp,
                  color: AppColors.kTextSecondary,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 2.h),
                Row(
                  children: [
                    Icon(Icons.person, size: 14, color: AppColors.kEmerald),
                    SizedBox(width: 1.w),
                    CustomText(
                      title: certification.instructor,
                      fontSize: 12.sp,
                      color: AppColors.kTextSecondary,
                    ),
                    SizedBox(width: 4.w),
                    Icon(Icons.schedule, size: 14, color: AppColors.kEmerald),
                    SizedBox(width: 1.w),
                    CustomText(
                      title: certification.duration,
                      fontSize: 12.sp,
                      color: AppColors.kTextSecondary,
                    ),
                  ],
                ),
                SizedBox(height: 1.5.h),
                Wrap(
                  spacing: 1.w,
                  runSpacing: 0.5.h,
                  children: certification.skills.take(3).map((skill) => Container(
                    padding: EdgeInsets.symmetric(horizontal: 1.5.w, vertical: 0.3.h),
                    decoration: BoxDecoration(
                      color: AppColors.kEmerald.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: CustomText(
                      title: skill,
                      fontSize: 10.sp,
                      color: AppColors.kEmerald,
                      weight: FontWeight.w500,
                    ),
                  )).toList(),
                ),
                if (!isCompleted) ...[
                  SizedBox(height: 2.h),
                  CustomButton(
                    text: "Enroll Now",
                    onPressed: onEnroll,
                    fontSize: 14.sp,
                    textColor: Colors.white,
                    backgroundColor: AppColors.kEmerald,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getLevelColor(String level) {
    switch (level.toLowerCase()) {
      case 'beginner':
        return Colors.greenAccent;
      case 'intermediate':
        return Colors.orangeAccent;
      case 'advanced':
        return Colors.redAccent;
      default:
        return AppColors.kEmerald;
    }
  }
}
