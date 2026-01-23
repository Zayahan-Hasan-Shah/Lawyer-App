import 'package:flutter/material.dart';
import 'package:lawyer_app/src/core/constants/app_colors.dart';
import 'package:lawyer_app/src/models/lawyer_model/case_model/lawyer_case_model.dart';
import 'package:lawyer_app/src/widgets/common_widgets/custom_text.dart';
import 'package:sizer/sizer.dart';

class DisposedLawyerCasesTab extends StatelessWidget {
  final List<LawyerCaseModel> cases;

  const DisposedLawyerCasesTab({super.key, required this.cases});

  @override
  Widget build(BuildContext context) {
    if (cases.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle_outline_rounded,
              size: 80,
              color: AppColors.kEmerald,
            ),
            SizedBox(height: 2.h),
            Text(
              'No disposed cases yet',
              style: TextStyle(
                color: AppColors.kTextPrimary,
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              'Completed matters will appear here',
              style: TextStyle(
                color: AppColors.kTextSecondary,
                fontSize: 15.sp,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
      itemCount: cases.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, i) {
        final c = cases[i];

        return Padding(
          padding: EdgeInsets.only(bottom: 2.4.h),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.kSurface.withOpacity(0.92),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.kEmerald.withOpacity(0.15)),
            ),
            child: Padding(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.kEmerald.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(
                          Icons.gavel_rounded,
                          size: 3.h,
                          color: AppColors.kEmerald,
                        ),
                      ),
                      SizedBox(width: 4.w),

                      Expanded(
                        child: CustomText(
                          title: c.category,
                          color: AppColors.kEmerald,
                          fontSize: 16.sp,
                          weight: FontWeight.w700,
                        ),
                      ),

                      // Optional: small icon depending on category
                      if (c.category.toLowerCase().contains('criminal'))
                        Icon(
                          Icons.warning_amber_rounded,
                          color: AppColors.kEmerald,
                          size: 3.h,
                        )
                      else if (c.category.toLowerCase().contains('civil'))
                        Icon(
                          Icons.balance_rounded,
                          color: AppColors.kEmerald,
                          size: 3.h,
                        )
                      else
                        Icon(
                          Icons.circle_rounded,
                          color: AppColors.kTextSecondary,
                          size: 20,
                        ),
                    ],
                  ),

                  SizedBox(height: 2.h),

                  // Main content column
                  CustomText(
                    title: c.title,
                    color: AppColors.kTextPrimary,
                    fontSize: 17.sp,
                    weight: FontWeight.w700,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  SizedBox(height: 0.5.h),

                  CustomText(
                    title: '${c.client} • ${c.court}',
                    color: AppColors.kTextSecondary,
                    fontSize: 14.5.sp,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  SizedBox(height: 0.5.h),

                  CustomText(
                    title: 'Disposed: ${c.disposedDate ?? '-'}',
                    color: AppColors.kEmerald.withOpacity(0.9),
                    fontSize: 15.sp,
                    weight: FontWeight.w600,
                  ),

                  if (c.outcomeSummary != null) ...[
                    SizedBox(height: 0.5.h),
                    CustomText(
                      title: c.outcomeSummary!,
                      color: AppColors.kTextSecondary,
                      fontSize: 14.sp,
                      textHeight: 1.4,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}