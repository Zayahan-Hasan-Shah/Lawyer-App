import 'package:flutter/material.dart';
import 'package:lawyer_app/core/constants/app_colors.dart';
import 'package:lawyer_app/shared/widgets/custom_text.dart';
import 'package:sizer/sizer.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Gradient? gradient;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;
  final double? height;
  final double borderRadius;
  final bool isOutlined;
  final bool isLoading;
  final IconData? icon;
  final double? fontSize;
  final FontWeight? fontWeight;
  final double? blurRadius;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.gradient,
    this.backgroundColor,
    this.textColor,
    this.width,
    this.height,
    this.borderRadius = 16.0,
    this.isOutlined = false,
    this.isLoading = false,
    this.icon,
    this.fontSize,
    this.fontWeight,
    this.blurRadius = 0.5,
  });

  @override
  Widget build(BuildContext context) {
    final defaultGradient = gradient ?? AppColors.goldGradient;
    final defaultHeight = height ?? 6.5.h;

    return Container(
      width: width ?? double.infinity,
      height: defaultHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        gradient: isOutlined ? null : (backgroundColor == null ? defaultGradient : null),
        color: isOutlined ? Colors.transparent : backgroundColor,
        border: isOutlined
            ? Border.all(color: AppColors.kGold, width: 1.5)
            : null,
        boxShadow: isOutlined
            ? []
            : [
                BoxShadow(
                  blurRadius: blurRadius!,
                  offset: const Offset(0, 5),
                ),
              ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(borderRadius),
          onTap: isLoading ? null : onPressed,
          splashColor: Colors.white.withOpacity(0.2),
          child: Center(
            child: isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.black87),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (icon != null) ...[
                        Icon(icon, color: isOutlined ? AppColors.kGold : (textColor ?? Colors.black87), size: 18.sp),
                        SizedBox(width: 2.w),
                      ],
                      CustomText(
                        title: text,
                        color: isOutlined ? AppColors.kGold : (textColor ?? Colors.black87),
                        weight: fontWeight ?? FontWeight.bold,
                        fontSize: fontSize ?? 16.sp,
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
