import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lawyer_app/src/core/constants/app_colors.dart';
import 'package:lawyer_app/src/widgets/common_widgets/custom_text.dart';

class CustomAppbar extends StatelessWidget {
  final String title;
  final List<Widget>? actions;
  final bool isDrawwer;
  final bool isBack;

  const CustomAppbar({
    super.key,
    required this.title,
    this.actions,
    this.isDrawwer = false,
    this.isBack = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.backgroundColor,
      actions: actions ?? [],
      title: CustomText(title: title, fontSize: 20, weight: FontWeight.bold),
      centerTitle: true,
      leading: isDrawwer
          ? IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            )
          : isBack
          ? IconButton(
              style: IconButton.styleFrom(
                backgroundColor: AppColors.inputBackgroundColor,
              ),
              icon: Icon(
                Icons.chevron_left,
                size: 30,
                color: AppColors.whiteColor,
              ),
              onPressed: () {
                context.pop();
              },
            )
          : null,
    );
  }
}
