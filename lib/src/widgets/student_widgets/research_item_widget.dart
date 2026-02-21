import 'package:flutter/material.dart';
import 'package:lawyer_app/src/core/constants/app_colors.dart';
import 'package:lawyer_app/src/models/student_model/research_model.dart';
import 'package:lawyer_app/src/widgets/common_widgets/custom_button.dart';
import 'package:lawyer_app/src/widgets/common_widgets/custom_text.dart';
import 'package:sizer/sizer.dart';

class ResearchItemWidget extends StatelessWidget {
  final ResearchModel research;
  final bool isCurrent;
  final VoidCallback? onTap;
  final VoidCallback? onJoin;

  const ResearchItemWidget({
    super.key,
    required this.research,
    required this.isCurrent,
    this.onTap,
    this.onJoin,
  });

  @override
  Widget build(BuildContext context) {
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
          color: isCurrent 
              ? AppColors.kEmerald.withOpacity(0.5)
              : AppColors.kEmerald.withOpacity(0.3),
          width: isCurrent ? 2 : 1,
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
                        color: isCurrent 
                            ? AppColors.kEmerald.withOpacity(0.3)
                            : AppColors.kEmerald.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        isCurrent ? Icons.science : Icons.lightbulb_outline,
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
                            title: research.title,
                            fontSize: 16.sp,
                            weight: FontWeight.w600,
                            color: AppColors.kTextPrimary,
                          ),
                          if (isCurrent)
                            Container(
                              margin: EdgeInsets.only(top: 0.5.h),
                              padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.3.h),
                              decoration: BoxDecoration(
                                color: AppColors.kEmerald.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: CustomText(
                                title: "ACTIVE",
                                fontSize: 10.sp,
                                color: AppColors.kEmerald,
                                weight: FontWeight.w600,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
                CustomText(
                  title: research.description,
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
                      title: research.supervisor,
                      fontSize: 12.sp,
                      color: AppColors.kTextSecondary,
                    ),
                    SizedBox(width: 4.w),
                    Icon(Icons.calendar_today, size: 14, color: AppColors.kEmerald),
                    SizedBox(width: 1.w),
                    CustomText(
                      title: isCurrent ? "Started: ${research.startDate}" : "Available: ${research.startDate}",
                      fontSize: 12.sp,
                      color: AppColors.kTextSecondary,
                    ),
                  ],
                ),
                if (!isCurrent) ...[
                  SizedBox(height: 2.h),
                  CustomButton(
                    text: "Join Research",
                    onPressed: onJoin,
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
}
