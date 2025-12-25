import 'package:flutter/material.dart';
import 'package:lawyer_app/src/core/constants/app_colors.dart';
import 'package:lawyer_app/src/widgets/common_widgets/custom_text.dart';
import 'package:sizer/sizer.dart';

class DisposedCasesTab extends StatelessWidget {
  const DisposedCasesTab({super.key});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check_circle, size: 90, color: Colors.greenAccent),
          SizedBox(height: 3.h),
          CustomText(
            title: "All Disposed Cases",
            fontSize: 22.sp,
            color: AppColors.whiteColor,
          ),
          CustomText(
            title: "Will appear here",
            color: AppColors.lightDescriptionTextColor,
          ),
        ],
      ),
    );
  }
}
