import 'package:flutter/material.dart';
import 'package:lawyer_app/src/core/constants/app_colors.dart';
import 'package:lawyer_app/src/widgets/common_widgets/custom_text.dart';
import 'package:sizer/sizer.dart';

class MethodStep extends StatelessWidget {
  final String? selectedMethod;
  final ValueChanged<String> onMethodSelected;

  const MethodStep({
    super.key,
    required this.selectedMethod,
    required this.onMethodSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _methodCard("Upload Document", Icons.upload_file, "upload"),
        SizedBox(height: 3.h),
        _methodCard("Continue via WhatsApp", Icons.message, "whatsapp"),
      ],
    );
  }

  Widget _methodCard(String title, IconData icon, String value) {
    final isSelected = selectedMethod == value;
    return GestureDetector(
      onTap: () => onMethodSelected(value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          gradient: isSelected ? AppColors.buttonGradientColor : null,
          color: isSelected ? null : AppColors.inputBackgroundColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppColors.brightYellowColor.withOpacity(isSelected ? 0 : 0.3),
            width: 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.brightYellowColor.withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.blackColor.withOpacity(0.1)
                    : AppColors.brightYellowColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 20.sp, color: isSelected ? AppColors.blackColor : AppColors.brightYellowColor),
            ),
            SizedBox(width: 4.w),
            Expanded(
              child: CustomText(
                title: title,
                color: isSelected ? AppColors.blackColor : AppColors.whiteColor,
                fontSize: 16.sp,
                weight: FontWeight.w600,
              ),
            ),
            if (isSelected) Icon(Icons.arrow_forward_ios, color: AppColors.blackColor, size: 16.sp),
          ],
        ),
      ),
    );
  }
}