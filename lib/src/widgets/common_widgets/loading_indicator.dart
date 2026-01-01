// core/widgets/loading_indicator.dart
import 'package:flutter/material.dart';
import 'package:lawyer_app/src/core/constants/app_colors.dart';
import 'package:lawyer_app/src/widgets/common_widgets/custom_text.dart';

class LoadingIndicator extends StatelessWidget {
  final Color? color;
  final double? size;
  final String? text;
  final Color? textColor;

  const LoadingIndicator({
    super.key,
    this.color,
    this.size = 24.0,
    this.text,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                color ?? Theme.of(context).primaryColor,
              ),
              strokeWidth: 2.0,
            ),
          ),
          CustomText(
            title: text ?? "Loading",
            color: textColor ?? AppColors.lightDescriptionTextColor,
          ),
        ],
      ),
    );
  }
}
