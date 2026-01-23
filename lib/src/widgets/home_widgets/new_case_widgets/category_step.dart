// import 'package:flutter/material.dart';
// import 'package:lawyer_app/src/core/constants/app_colors.dart';
// import 'package:lawyer_app/src/states/client_states/category_state/category_state.dart';
// import 'package:lawyer_app/src/widgets/common_widgets/custom_text.dart';
// import 'package:lawyer_app/src/widgets/common_widgets/failed_widget.dart';
// import 'package:lawyer_app/src/widgets/common_widgets/loading_indicator.dart';
// import 'package:sizer/sizer.dart';

// class CategoryStep extends StatelessWidget {
//   final CategoryState state;
//   final String? selectedCategory;
//   final ValueChanged<String> onCategorySelected;

//   const CategoryStep({
//     super.key,
//     required this.state,
//     required this.selectedCategory,
//     required this.onCategorySelected,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return state.when(
//       loading: () => LoadingIndicator(
//         color: AppColors.brightYellowColor,
//         text: "Loading Categories",
//       ),
//       failure: (error) => FailedWidget(
//         text: "Failed to Load Categories",
//         icon: Icons.error_outline,
//       ),
//       success: (categories) => ListView.builder(
//         shrinkWrap: true,
//         physics: const NeverScrollableScrollPhysics(),
//         itemCount: categories.length,
//         itemBuilder: (_, i) {
//           final cat = categories[i];
//           final isSelected = selectedCategory == cat.category;
//           return GestureDetector(
//             onTap: () => onCategorySelected(cat.category),
//             child: AnimatedContainer(
//               duration: const Duration(milliseconds: 200),
//               margin: EdgeInsets.symmetric(vertical: 1.h),
//               padding: EdgeInsets.all(3.w),
//               decoration: BoxDecoration(
//                 gradient: isSelected ? AppColors.buttonGradientColor : null,
//                 color: isSelected ? null : AppColors.inputBackgroundColor,
//                 borderRadius: BorderRadius.circular(20),
//                 border: Border.all(
//                   color: isSelected
//                       ? Colors.transparent
//                       : AppColors.brightYellowColor.withOpacity(0.1),
//                   width: 1.5,
//                 ),
//                 boxShadow: isSelected
//                     ? [
//                         BoxShadow(
//                           color: AppColors.brightYellowColor.withOpacity(0.3),
//                           blurRadius: 12,
//                           offset: const Offset(0, 4),
//                         ),
//                       ]
//                     : null,
//               ),
//               child: Row(
//                 children: [
//                   Icon(
//                     isSelected ? Icons.check_circle : Icons.circle_outlined,
//                     color: isSelected
//                         ? AppColors.blackColor
//                         : AppColors.brightYellowColor,
//                     size: 20.sp,
//                   ),
//                   SizedBox(width: 4.w),
//                   Expanded(
//                     child: CustomText(
//                       title: cat.category,
//                       color: isSelected
//                           ? AppColors.blackColor
//                           : AppColors.whiteColor,
//                       fontSize: 16.sp,
//                       weight: FontWeight.w600,
//                     ),
//                   ),
//                   if (isSelected)
//                     Icon(
//                       Icons.arrow_forward_ios,
//                       color: AppColors.blackColor,
//                       size: 16.sp,
//                     ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//       initial: () => const Center(
//         child: CircularProgressIndicator(color: AppColors.brightYellowColor),
//       ),
//     );
//   }
// }

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:lawyer_app/src/core/constants/app_colors.dart';
import 'package:lawyer_app/src/states/client_states/category_state/category_state.dart';
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
      initial: () => const Center(
        child: CircularProgressIndicator(color: AppColors.kEmerald),
      ),
      loading: () => Center(
        child: LoadingIndicator(
          color: AppColors.kEmerald,
          text: "Loading Case Categories...",
        ),
      ),
      failure: (error) => FailedWidget(
        text: "Failed to load categories",
        icon: Icons.error_outline_rounded,
      ),
      success: (categories) => categories.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.category_outlined,
                    size: 80,
                    color: AppColors.kTextSecondary.withOpacity(0.6),
                  ),
                  SizedBox(height: 2.5.h),
                  CustomText(
                    title: "No Categories Available",
                    fontSize: 18.sp,
                    weight: FontWeight.w600,
                    color: AppColors.kTextPrimary,
                  ),
                  SizedBox(height: 1.2.h),
                  CustomText(
                    title: "Please try again later",
                    fontSize: 14.5.sp,
                    color: AppColors.kTextSecondary,
                  ),
                ],
              ),
            )
          : ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(vertical: 1.h),
              itemCount: categories.length,
              itemBuilder: (_, i) {
                final cat = categories[i];
                final isSelected = selectedCategory == cat.category;

                return GestureDetector(
                  onTap: () => onCategorySelected(cat.category),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 280),
                    curve: Curves.easeOutCubic,
                    margin: EdgeInsets.symmetric(vertical: 1.2.h),
                    padding: EdgeInsets.symmetric(
                      horizontal: 5.w,
                      vertical: 2.8.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.kSurface.withOpacity(0.92),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.kEmerald.withOpacity(0.6)
                            : AppColors.kEmerald.withOpacity(0.15),
                        width: isSelected ? 2.2 : 1.2,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: AppColors.kEmerald.withOpacity(0.35),
                                blurRadius: 16,
                                spreadRadius: 2,
                                offset: const Offset(0, 4),
                              ),
                              BoxShadow(
                                color: Colors.black.withOpacity(0.25),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ]
                          : [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.20),
                                blurRadius: 12,
                                offset: const Offset(0, 6),
                              ),
                            ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.kEmerald.withOpacity(0.25)
                                : AppColors.kEmerald.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            isSelected
                                ? Icons.check_circle_rounded
                                : Icons.category_rounded,
                            color: isSelected
                                ? AppColors.kEmerald
                                : AppColors.kTextSecondary,
                            size: 26,
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                title: cat.category,
                                fontSize: 16.5.sp,
                                weight: isSelected
                                    ? FontWeight.w700
                                    : FontWeight.w600,
                                color: isSelected
                                    ? AppColors.kEmerald
                                    : AppColors.kTextPrimary,
                              ),
                            ],
                          ),
                        ),
                        if (isSelected)
                          Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: AppColors.kEmerald,
                            size: 20,
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
