import 'package:flutter/material.dart';
import 'package:lawyer_app/src/core/constants/app_colors.dart';
import 'package:lawyer_app/src/models/client_model/case_model/case_model.dart';
import 'package:lawyer_app/src/widgets/common_widgets/custom_text.dart';
import 'package:sizer/sizer.dart';

class DisposedCasesTab extends StatelessWidget {
  final List<CaseModel> cases;
  const DisposedCasesTab({super.key, required this.cases});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    if (cases.isEmpty) {
      return Center(
        child: CustomText(
          title: "No disposed cases",
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
                  Icons.check_circle_rounded,
                  size: 60,
                  color: colorScheme.secondary,
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        title: c.title,
                        fontSize: 16.sp,
                        weight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                      SizedBox(height: 0.5.h),
                      CustomText(
                        title: c.court,
                        color: AppColors.lightDescriptionTextColor,
                        fontSize: 15.sp,
                      ),
                      SizedBox(height: 1.h),
                      CustomText(
                        title: "Disposed: ${c.disposedDate}",
                        color: colorScheme.secondary,
                        weight: FontWeight.w600,
                      ),
                      if (c.outcome != null)
                        CustomText(
                          title: c.outcome!,
                          color: AppColors.lightDescriptionTextColor,
                          fontSize: 13.sp,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                  decoration: BoxDecoration(
                    color: colorScheme.secondary.withOpacity(0.18),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: colorScheme.secondary),
                  ),
                  child: CustomText(
                    title: c.category,
                    color: colorScheme.secondary,
                    weight: FontWeight.bold,
                    fontSize: 14.sp,
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
