import 'package:flutter/material.dart';
import 'package:lawyer_app/core/constants/app_colors.dart';
import 'package:sizer/sizer.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String hintText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final int maxLines;
  final bool readOnly;
  final VoidCallback? onTap;
  final Color? textColor;
  final Color? hintTextColor;
  final Color? fillColor;
  final double? borderRadius;
  final TextInputAction? textInputAction;
  final void Function(String)? onFieldSubmitted;

  const CustomTextField({
    super.key,
    this.controller,
    required this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.onChanged,
    this.maxLines = 1,
    this.readOnly = false,
    this.onTap,
    this.textColor,
    this.hintTextColor,
    this.fillColor,
    this.borderRadius,
    this.textInputAction,
    this.onFieldSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType ?? TextInputType.text,
      validator: validator,
      onChanged: onChanged,
      maxLines: maxLines,
      readOnly: readOnly,
      onTap: onTap,
      textInputAction: textInputAction,
      onFieldSubmitted: onFieldSubmitted ?? (v) => FocusScope.of(context).unfocus(),
      style: TextStyle(
        color: textColor ?? AppColors.kTextPrimary, 
        fontSize: 14.sp
      ),
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        filled: fillColor != null,
        fillColor: fillColor,
        border: borderRadius != null 
          ? OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius!),
              borderSide: BorderSide.none,
            )
          : null,
        hintStyle: TextStyle(
          color: hintTextColor ?? AppColors.hintTextColor,
          fontSize: 14.sp,
        ),
      ),
    );
  }
}
