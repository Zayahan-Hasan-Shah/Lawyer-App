import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lawyer_app/src/core/constants/app_colors.dart';
import 'package:lawyer_app/src/widgets/common_widgets/custom_text.dart';
import 'package:sizer/sizer.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final String? logoImage;
  final List<Widget>? actions;
  final bool isDrawer; // renamed for clarity
  final bool isBack;
  final Color? backgroundColor;

  const CustomAppbar({
    super.key,
    this.title,
    this.logoImage,
    this.actions,
    this.isDrawer = false,
    this.isBack = false,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final bool isTransparent = backgroundColor == Colors.transparent;

    return Container(
      decoration: BoxDecoration(
        color: isTransparent
            ? Colors.transparent
            : AppColors.kSurface.withOpacity(0.88),
        border: isTransparent
            ? null
            : Border(
                bottom: BorderSide(
                  color: AppColors.kEmerald.withOpacity(0.12),
                  width: 1.2,
                ),
              ),
        boxShadow: isTransparent
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.25),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: ClipRRect(
        child: BackdropFilter(
          filter: isTransparent
              ? ImageFilter.blur(sigmaX: 0, sigmaY: 0)
              : ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            title: title != null && title!.isNotEmpty
                ? CustomText(
                    title: title!,
                    fontSize: 20.sp,
                    weight: FontWeight.w700,
                    color: AppColors.kTextPrimary,
                  )
                : logoImage != null
                ? Container(
                    height: 48,
                    child: Image.asset(logoImage!, fit: BoxFit.contain),
                  )
                : null,
            leadingWidth: 72,
            leading: isDrawer
                ? _buildDrawerButton(context)
                : isBack
                ? _buildBackButton(context)
                : null,
            actions: actions ?? [],
            iconTheme: IconThemeData(color: AppColors.kEmerald),
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: IconButton(
        icon: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.kEmerald.withOpacity(0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(Icons.menu_rounded, color: AppColors.kEmerald, size: 26),
        ),
        onPressed: () => Scaffold.of(context).openDrawer(),
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return IconButton(
      icon: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.kEmerald.withOpacity(0.15),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(
          Icons.arrow_back_ios_new_rounded,
          color: AppColors.kEmerald,
          size: 24,
        ),
      ),
      onPressed: () => context.pop(),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
