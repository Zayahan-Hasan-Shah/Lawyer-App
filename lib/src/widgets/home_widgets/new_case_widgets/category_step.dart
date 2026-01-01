import 'package:flutter/material.dart';
import 'package:lawyer_app/src/core/constants/app_colors.dart';
import 'package:lawyer_app/src/states/category_state/category_state.dart';
import 'package:lawyer_app/src/widgets/common_widgets/custom_text.dart';
import 'package:lawyer_app/src/widgets/common_widgets/failed_widget.dart';
import 'package:lawyer_app/src/widgets/common_widgets/loading_indicator.dart';
import 'package:sizer/sizer.dart';

class CategoryStep extends StatelessWidget {
  final CategoryState state;
  final String? selectedCategory;
  final ValueChanged<String> onCategorySelected;

  const CategoryStep({
    super.key,
    required this.state,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return state.when(
      loading: () => LoadingIndicator(
        color: AppColors.brightYellowColor,
        text: "Loading Categories",
      ),
      failure: (error) => FailedWidget(
        text: "Failed to Load Categories",
        icon: Icons.error_outline,
      ),
      success: (categories) => ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: categories.length,
        itemBuilder: (_, i) {
          final cat = categories[i];
          final isSelected = selectedCategory == cat.category;
          return GestureDetector(
            onTap: () => onCategorySelected(cat.category),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: EdgeInsets.symmetric(vertical: 1.h),
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                gradient: isSelected ? AppColors.buttonGradientColor : null,
                color: isSelected ? null : AppColors.inputBackgroundColor,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected
                      ? Colors.transparent
                      : AppColors.brightYellowColor.withOpacity(0.1),
                  width: 1.5,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: AppColors.brightYellowColor.withOpacity(0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : null,
              ),
              child: Row(
                children: [
                  Icon(
                    isSelected ? Icons.check_circle : Icons.circle_outlined,
                    color: isSelected
                        ? AppColors.blackColor
                        : AppColors.brightYellowColor,
                    size: 20.sp,
                  ),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: CustomText(
                      title: cat.category,
                      color: isSelected
                          ? AppColors.blackColor
                          : AppColors.whiteColor,
                      fontSize: 16.sp,
                      weight: FontWeight.w600,
                    ),
                  ),
                  if (isSelected)
                    Icon(
                      Icons.arrow_forward_ios,
                      color: AppColors.blackColor,
                      size: 16.sp,
                    ),
                ],
              ),
            ),
          );
        },
      ),
      initial: () => const Center(
        child: CircularProgressIndicator(color: AppColors.brightYellowColor),
      ),
    );
  }
}
