import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lawyer_app/src/core/constants/app_colors.dart';
import 'package:lawyer_app/src/core/utils/storage/storage_service.dart';
import 'package:lawyer_app/src/routing/route_names.dart';
import 'package:lawyer_app/src/widgets/common_widgets/custom_text.dart';
import 'package:sizer/sizer.dart';

/// A reusable client-side drawer widget.
///
/// - Shows app-styled background and spacing
/// - Provides a "Logout" text button with confirmation dialog
/// - On confirmation, navigates to the IncomingUserTypeScreen
class CustomClientDrawer extends StatelessWidget {
  const CustomClientDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Drawer(
      backgroundColor: AppColors.backgroundColor,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.w),
              child: CustomText(
                title: 'Menu',
                fontSize: 18.sp,
                weight: FontWeight.w600,
                color: AppColors.whiteColor,
              ),
            ),
            SizedBox(height: 2.h),
            const Divider(color: AppColors.inputBackgroundColor, height: 1),

            // TODO: Add more drawer items here as needed
            const Spacer(),

            // Logout text button at the bottom
            Padding(
              padding: EdgeInsets.fromLTRB(5.w, 1.h, 5.w, 3.h),
              child: Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.redAccent,
                  ),
                  onPressed: () => _confirmAndLogout(context),
                  icon: const Icon(Icons.logout),
                  label: CustomText(
                    title: 'Logout',
                    fontSize: 14.sp,
                    color: Colors.redAccent,
                    weight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmAndLogout(BuildContext context) async {
    final rootContext = context;

    final bool? confirmed = await showDialog<bool>(
      context: rootContext,
      barrierDismissible: true,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.inputBackgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Logout',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          ),
          content: const Text(
            'Are you sure you want to logout?',
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text('No', style: TextStyle(color: Colors.redAccent)),
            ),
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: Text('Yes', style: TextStyle(color: Colors.greenAccent)),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      await StorageService.instance.clearAllAuthData();
      Navigator.of(rootContext).pop();
      rootContext.goNamed(RouteNames.incomingUserScreen);
    }
  }
}
