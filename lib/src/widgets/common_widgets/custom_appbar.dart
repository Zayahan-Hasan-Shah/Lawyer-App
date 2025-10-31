import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lawyer_app/src/core/constants/app_assets.dart';
import 'package:lawyer_app/src/core/constants/app_colors.dart';
import 'package:lawyer_app/src/widgets/common_widgets/custom_text.dart';
import 'package:sizer/sizer.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final List<Widget>? actions;
  final bool isDrawwer;
  final bool isBack;
  final String? logoImage;

  const CustomAppbar({
    super.key,
    this.title,
    this.logoImage,
    this.actions,
    this.isDrawwer = false,
    this.isBack = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.backgroundColor,
      centerTitle: true,
      actions: actions ?? [],
      title: title != null && title!.isNotEmpty
          ? CustomText(
              title: title!,
              fontSize: 20,
              weight: FontWeight.w600,
              color: AppColors.whiteColor,
            )
          : logoImage != null
          ? Image.asset(logoImage!, height: 50, fit: BoxFit.contain)
          : null,
      leading: isDrawwer
          ? IconButton(
              style: IconButton.styleFrom(
                backgroundColor: AppColors.inputBackgroundColor,
                padding: EdgeInsets.all(0.8.h),
              ),
              icon: Image.asset(
                AppAssets.drawerIconImage,
                height: 20,
                width: 20,
              ),
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

  @override
  Size get preferredSize => const Size.fromHeight(80);
}
