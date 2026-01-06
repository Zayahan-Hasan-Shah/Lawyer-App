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
    final colorScheme = Theme.of(context).colorScheme;

    if (cases.isEmpty) {
      return Center(
        child: CustomText(
          title: 'No disposed matters',
          fontSize: 18.sp,
          color: AppColors.lightDescriptionTextColor,
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(5.w),
      itemCount: cases.length,
      itemBuilder: (_, i) {
        final c = cases[i];
        return Container(
          margin: EdgeInsets.only(bottom: 2.5.h),
          decoration: BoxDecoration(
            color: colorScheme.surface.withOpacity(0.95),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: colorScheme.secondary.withOpacity(0.55),
              width: 1.4,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(5.w),
            child: Row(
              children: [
                Icon(
                  Icons.gavel_rounded,
                  size: 8.h,
                  color: colorScheme.secondary,
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        title: c.category,
                        color: colorScheme.secondary,
                        weight: FontWeight.bold,
                        fontSize: 14.sp,
                      ),
                      SizedBox(height: 0.5.h),
                      CustomText(
                        title: c.title,
                        fontSize: 16.sp,
                        weight: FontWeight.bold,
                        color: colorScheme.onSurface,
                        maxLines: 2,
                      ),
                      SizedBox(height: 0.5.h),
                      CustomText(
                        title: '${c.client} • ${c.court}',
                        color: AppColors.lightDescriptionTextColor,
                        fontSize: 14.sp,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 0.5.h),
                      CustomText(
                        title: 'Disposed: ${c.disposedDate ?? '-'}',
                        color: colorScheme.secondary,
                        weight: FontWeight.w600,
                        fontSize: 14.sp,
                      ),
                      if (c.outcomeSummary != null) ...[
                        SizedBox(height: 0.5.h),
                        CustomText(
                          title: c.outcomeSummary!,
                          color: AppColors.lightDescriptionTextColor,
                          fontSize: 14.sp,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
