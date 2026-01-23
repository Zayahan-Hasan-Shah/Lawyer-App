import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lawyer_app/src/core/constants/app_assets.dart';
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
    return SizedBox(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Floating emerald-glow icon container
            Container(
              width: 18.h,
              height: 18.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    AppColors.kEmerald.withOpacity(0.35),
                    AppColors.kEmeraldDark.withOpacity(0.15),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  // BoxShadow(
                  //   color: AppColors.kEmerald.withOpacity(0.45),
                  //   blurRadius: 32,
                  //   spreadRadius: 8,
                  // ),
                  BoxShadow(
                    color: Colors.black.withOpacity(0.35),
                    blurRadius: 40,
                    offset: const Offset(0, 20),
                  ),
                ],
              ),
              child: Icon(
                Icons.add_circle_rounded,
                size: 12.h,
                color: Colors.white,
              ),
            ),

            SizedBox(height: 2.5.h),

            // Main title
            CustomText(
              title: "Start a New Case",
              fontSize: 26.sp,
              weight: FontWeight.w800,
              color: AppColors.kTextPrimary,
            ),

            SizedBox(height: 1.h),

            // Subtitle
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: CustomText(
                title: "File a new legal matter in just a few steps",
                color: AppColors.kTextSecondary,
                fontSize: 16.sp,
                alignText: TextAlign.center,
              ),
            ),

            SizedBox(height: 3.h),

            // CTA Button with premium emerald gradient
            SizedBox(
              width: 65.w,
              height: 58,
              child: CustomButton(
                text: "Begin Application",
                onPressed: () async {
                  // Fetch categories first
                  await ref.read(caseCategoryProvider.notifier).getCategories();

                  if (!context.mounted) return;

                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (_) => const NewCaseStepperModal(),
                  );
                },
                gradient: LinearGradient(
                  colors: [AppColors.kEmerald, AppColors.kEmeraldDark],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                textColor: Colors.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                borderRadius: 16,
              ),
            ),

            SizedBox(height: 4.h),

            // Optional subtle hint
            Opacity(
              opacity: 0.7,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    size: 2.h,
                    color: AppColors.kTextSecondary,
                  ),
                  SizedBox(width: 2.w),
                  CustomText(
                    title: "Takes about 3–5 minutes",
                    color: AppColors.kTextSecondary,
                    fontSize: 14.sp,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
