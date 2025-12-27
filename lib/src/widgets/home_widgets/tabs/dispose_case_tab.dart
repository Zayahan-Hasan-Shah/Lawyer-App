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
            color: AppColors.inputBackgroundColor.withOpacity(0.9),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.greenAccent.withOpacity(0.6),
              width: 1.5,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(5.w),
            child: Row(
              children: [
                Icon(
                  Icons.check_circle_rounded,
                  size: 60,
                  color: Colors.greenAccent,
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
                        color: AppColors.whiteColor,
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
                        color: Colors.greenAccent,
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
                    color: AppColors.brightYellowColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: AppColors.brightYellowColor),
                  ),
                  child: CustomText(
                    title: c.category,
                    color: AppColors.brightYellowColor,
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
