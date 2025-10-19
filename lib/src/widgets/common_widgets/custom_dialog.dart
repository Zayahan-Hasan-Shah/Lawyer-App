import 'package:flutter/material.dart';
import 'package:lawyer_app/src/core/constants/app_colors.dart';
import 'package:sizer/sizer.dart';

class CustomDialog extends StatelessWidget {
  final String title;
  final String description;
  final String buttonText;
  final VoidCallback? onPressed;
  final IconData? icon;
  final List<Color>? buttonGradient;
  final Color? backgroundColor;
  final bool showCloseButton;

  const CustomDialog({
    super.key,
    required this.title,
    required this.description,
    required this.buttonText,
    this.onPressed,
    this.icon,
    this.buttonGradient,
    this.backgroundColor,
    this.showCloseButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: backgroundColor ?? const Color(0xFF0F1112),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showCloseButton)
              Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Icon(
                    Icons.close,
                    color: Colors.white.withOpacity(0.8),
                    size: 18.sp,
                  ),
                ),
              ),

            SizedBox(height: 1.h),

            // ✅ Optional icon
            if (icon != null)
              Container(
                height: 20.w,
                width: 25.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const RadialGradient(
                    colors: [Color(0xFFFFD700), Color(0xFF9A7C00)],
                    center: Alignment.center,
                    radius: 0.8,
                  ),
                ),
                child: Icon(
                  icon,
                  color: AppColors.whiteColor,
                  size: 40,
                ),
              ),

            SizedBox(height: 2.h),

            // ✅ Title
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
              ),
            ),

            SizedBox(height: 0.8.h),

            // ✅ Description
            Text(
              description,
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 16.sp,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 3.h),

            // ✅ Custom button
            GestureDetector(
              onTap: onPressed ?? () => Navigator.of(context).pop(),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 1.6.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  gradient: LinearGradient(
                    colors: buttonGradient ??
                        const [Color(0xFFFFD700), Color(0xFF9A7C00)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  buttonText,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
