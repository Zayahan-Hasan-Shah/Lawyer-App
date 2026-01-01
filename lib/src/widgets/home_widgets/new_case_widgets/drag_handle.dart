import 'package:flutter/material.dart';
import 'package:lawyer_app/src/core/constants/app_colors.dart';
import 'package:sizer/sizer.dart';

class DragHandle extends StatelessWidget {
  const DragHandle({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 2.h),
      width: 15.w,
      height: 5,
      decoration: BoxDecoration(
        gradient: AppColors.buttonGradientColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: AppColors.brightYellowColor.withOpacity(0.3),
            blurRadius: 8,
          ),
        ],
      ),
    );
  }
}
