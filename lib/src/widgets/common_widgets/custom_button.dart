import 'package:flutter/material.dart';
import 'package:lawyer_app/src/widgets/common_widgets/custom_text.dart';
import 'package:sizer/sizer.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool outlined;
  final double? width;
  final double? height;
  final Gradient? gradient;
  final Color? backgroundColor;
  final double? borderRadius;
  final Color? textColor;
  final double? fontSize;
  final Color? borderColor;
  final FontWeight? fontWeight;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.outlined = false,
    this.width,
    this.height,
    this.gradient,
    this.backgroundColor,
    this.borderRadius,
    this.textColor,
    this.fontSize,
    this.borderColor,
    this.fontWeight,
  });

  @override
  Widget build(BuildContext context) {
    // --- Case 1: Gradient background ---
    if (gradient != null) {
      return SizedBox(
        width: width,
        height: height,
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(borderRadius ?? 8),
          ),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadius ?? 8),
              ),
            ),
            onPressed: onPressed,
            child: Text(
              text,
              style: TextStyle(
                color: textColor ?? Colors.white,
                fontSize: fontSize ?? 14.sp,
                fontWeight: fontWeight ?? FontWeight.normal,
              ),
            ),
          ),
        ),
      );
    }

    // --- Case 2: Outlined ---
    if (outlined) {
      return SizedBox(
        width: width,
        height: height,
        child: OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            backgroundColor: backgroundColor ?? Colors.transparent,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: borderColor ?? Colors.black, width: 20.w),
              borderRadius: BorderRadius.circular(borderRadius ?? 8),
            ),
          ),
          child: CustomText(
            title: text,
            color: textColor ?? Colors.black,
            fontSize: fontSize ?? 14.sp,
            weight: fontWeight ?? FontWeight.normal,
          ),
        ),
      );
    }

    // --- Case 3: Solid backgroundColor OR default ---
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? Theme.of(context).primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 8),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: textColor ?? Colors.white,
            fontSize: fontSize ?? 14.sp,
            fontWeight: fontWeight ?? FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
