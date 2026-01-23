import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lawyer_app/src/core/constants/app_colors.dart';
import 'package:sizer/sizer.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final bool obscureText;
  final bool readOnly;
  final TextInputType? keyboardType;
  final int? maxLines;
  final VoidCallback? onTap;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Color? borderColor;
  final double? borderRadius;
  final String? hintText;
  final List<TextInputFormatter>? inputFormatters;
  final void Function(String)? onChanged;
  final Color? fillColor;
  final Color? textColor;
  final Color? hintTextColor;

  const CustomTextField({
    super.key,
    required this.controller,
    this.validator,
    this.obscureText = false,
    this.readOnly = false,
    this.keyboardType,
    this.maxLines = 1,
    this.onTap,
    this.prefixIcon,
    this.suffixIcon,
    this.borderColor,
    this.borderRadius,
    this.hintText,
    this.inputFormatters,
    this.onChanged,
    this.fillColor,
    this.hintTextColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.kBorderSubtle, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: TextFormField(
            controller: controller,
            validator: validator,
            obscureText: obscureText,
            readOnly: readOnly,
            style: TextStyle(
              color: textColor ?? AppColors.kTextPrimary,
              fontSize: 15.sp,
            ),
            keyboardType: keyboardType,
            maxLines: maxLines,
            inputFormatters: inputFormatters,
            onTap: onTap,
            onChanged: onChanged,
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.kInputBg.withOpacity(0.85),
              hintText: hintText,
              hintStyle: TextStyle(
                color: hintTextColor ?? AppColors.kTextSecondary,
                fontSize: 15.sp,
              ),
              prefixIcon: prefixIcon != null
                  ? Padding(
                      padding: const EdgeInsets.only(left: 12),
                      child: prefixIcon,
                    )
                  : null,
              suffixIcon: suffixIcon,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              focusedErrorBorder: InputBorder.none,
              errorStyle: TextStyle(color: Colors.redAccent, fontSize: 14.sp),
            ),
          ),
        ),
      ),
    );
  }
}
