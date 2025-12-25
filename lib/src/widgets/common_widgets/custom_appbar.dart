// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:lawyer_app/src/core/constants/app_assets.dart';
// import 'package:lawyer_app/src/core/constants/app_colors.dart';
// import 'package:lawyer_app/src/widgets/common_widgets/custom_text.dart';
// import 'package:sizer/sizer.dart';

// class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
//   final String? title;
//   final List<Widget>? actions;
//   final bool isDrawwer;
//   final bool isBack;
//   final String? logoImage;

//   const CustomAppbar({
//     super.key,
//     this.title,
//     this.logoImage,
//     this.actions,
//     this.isDrawwer = false,
//     this.isBack = false,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return AppBar(
//       backgroundColor: AppColors.backgroundColor,
//       centerTitle: true,
//       actions: actions ?? [],
//       title: title != null && title!.isNotEmpty
//           ? CustomText(
//               title: title!,
//               fontSize: 20,
//               weight: FontWeight.w600,
//               color: AppColors.whiteColor,
//             )
//           : logoImage != null
//           ? Image.asset(logoImage!, height: 50, fit: BoxFit.contain)
//           : null,
//       leading: isDrawwer
//           ? IconButton(
//               style: IconButton.styleFrom(
//                 backgroundColor: AppColors.inputBackgroundColor,
//                 padding: EdgeInsets.all(0.8.h),
//               ),
//               icon: Image.asset(
//                 AppAssets.drawerIconImage,
//                 height: 20,
//                 width: 20,
//               ),
//               onPressed: () {
//                 Scaffold.of(context).openDrawer();
//               },
//             )
//           : isBack
//           ? IconButton(
//               style: IconButton.styleFrom(
//                 backgroundColor: AppColors.inputBackgroundColor,
//               ),
//               icon: Icon(
//                 Icons.chevron_left,
//                 size: 30,
//                 color: AppColors.whiteColor,
//               ),
//               onPressed: () {
//                 context.pop();
//               },
//             )
//           : null,
//     );
//   }

//   @override
//   Size get preferredSize => const Size.fromHeight(80);
// }

// src/widgets/common_widgets/custom_appbar.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lawyer_app/src/core/constants/app_assets.dart';
import 'package:lawyer_app/src/core/constants/app_colors.dart';
import 'package:lawyer_app/src/widgets/common_widgets/custom_text.dart';
import 'package:sizer/sizer.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  /// Title text
  final String? title;

  /// Optional logo image path
  final String? logoImage;

  /// AppBar actions
  final List<Widget>? actions;

  /// Show drawer icon (hamburger)
  final bool isDrawwer;

  /// Show back arrow
  final bool isBack;

  /// **NEW** – make the AppBar transparent
  final Color? backgroundColor;

  const CustomAppbar({
    super.key,
    this.title,
    this.logoImage,
    this.actions,
    this.isDrawwer = false,
    this.isBack = false,
    this.backgroundColor, // <-- optional
  });

  @override
  Widget build(BuildContext context) {
    // Use the passed color, otherwise fall back to the default background
    final bg = backgroundColor ?? AppColors.backgroundColor;

    return AppBar(
      backgroundColor: bg,
      elevation: bg == Colors.transparent
          ? 0
          : null, // no shadow when transparent
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
          ? _buildDrawerButton(context)
          : isBack
          ? _buildBackButton(context)
          : null,
    );
  }

  // -----------------------------------------------------------------
  // Helper: drawer button (keeps your styling)
  // -----------------------------------------------------------------
  Widget _buildDrawerButton(BuildContext context) {
    return IconButton(
      style: IconButton.styleFrom(
        backgroundColor: AppColors.inputBackgroundColor,
        padding: EdgeInsets.all(0.8.h),
      ),
      icon: Image.asset(
        AppAssets.drawerIconImage,
        height: 20,
        width: 20,
        color: AppColors.whiteColor,
      ),
      onPressed: () => Scaffold.of(context).openDrawer(),
    );
  }

  // -----------------------------------------------------------------
  // Helper: back button (uses go_router pop)
  // -----------------------------------------------------------------
  Widget _buildBackButton(BuildContext context) {
    return IconButton(
      style: IconButton.styleFrom(
        backgroundColor: AppColors.inputBackgroundColor,
      ),
      icon: const Icon(
        Icons.chevron_left,
        size: 30,
        color: AppColors.whiteColor,
      ),
      onPressed: () => context.pop(),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
