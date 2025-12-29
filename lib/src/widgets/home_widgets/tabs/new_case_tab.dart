// new_case_tab.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lawyer_app/src/core/constants/app_colors.dart';
import 'package:lawyer_app/src/providers/client_provider/case_category_provider/case_category_provider.dart';
import 'package:lawyer_app/src/widgets/common_widgets/custom_button.dart';
import 'package:lawyer_app/src/widgets/common_widgets/custom_text.dart';
import 'package:lawyer_app/src/widgets/home_widgets/new_case_widgets/new_case_stepper_modal.dart';
import 'package:sizer/sizer.dart';

class NewCaseTab extends ConsumerWidget {
  const NewCaseTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.add_circle, size: 10.h, color: AppColors.iconColor),
          SizedBox(height: 1.h),
          CustomText(
            title: "File New Case",
            fontSize: 24.sp,
            weight: FontWeight.bold,
            color: AppColors.whiteColor,
          ),
          SizedBox(height: 1.h),
          CustomButton(
            text: "Start Application",
            onPressed: () async {
              // Fetch categories first
              await ref.read(caseCategoryProvider.notifier).getCategories();
              // Then show modal
              if (context.mounted) {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (_) => const NewCaseStepperModal(),
                );
              }
            },
            gradient: AppColors.buttonGradientColor,
            textColor: AppColors.blackColor,
            fontSize: 16.sp,
            borderRadius: 24,
            width: 50.w,
            height: 7.h,
          ),
        ],
      ),
    );
  }
}
