import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lawyer_app/src/core/constants/app_colors.dart';

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
    return TextFormField(
      controller: controller,
      validator: validator,
      obscureText: obscureText,
      readOnly: readOnly,
      style: TextStyle(color: textColor ?? Colors.black),
      keyboardType: keyboardType,
      maxLines: maxLines,
      inputFormatters: inputFormatters ?? [],
      onTap: onTap,
      onChanged: onChanged,
      decoration: InputDecoration(
        filled: true,
        
        fillColor: fillColor ?? AppColors.inputBackgroundColor,
        hintText: hintText ?? '',
        hintStyle: TextStyle(color: hintTextColor ?? Colors.black54),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8), // rounded corners
          borderSide: BorderSide.none, // remove border line
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
