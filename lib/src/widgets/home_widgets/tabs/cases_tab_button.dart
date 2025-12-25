import 'package:flutter/material.dart';
import 'package:lawyer_app/src/core/constants/app_colors.dart';
import 'package:lawyer_app/src/widgets/common_widgets/custom_text.dart';
import 'package:sizer/sizer.dart';

class CasesTabButton extends StatelessWidget {
  final String title;
  final int index;
  final int selectedTab;
  final ValueChanged<int> onTap;
  const CasesTabButton({
    super.key,
    required this.title,
    required this.index,
    required this.selectedTab,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isSelected = selectedTab == index;
    return GestureDetector(
      onTap: () => onTap(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: EdgeInsets.symmetric(vertical: 0.8.h, horizontal: 6.w),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.brightYellowColor : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.brightYellowColor, width: 0.4.w),
        ),
        child: CustomText(
          title: title,
          color: isSelected ? Colors.white : AppColors.brightYellowColor,
          fontSize: 16.sp,
          weight: FontWeight.w600,
        ),
      ),
    );
  }
}
