import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lawyer_app/src/core/constants/app_colors.dart';
import 'package:lawyer_app/src/core/utils/storage/storage_service.dart';
import 'package:lawyer_app/src/routing/route_names.dart';
import 'package:lawyer_app/src/widgets/common_widgets/custom_text.dart';
import 'package:sizer/sizer.dart';

class CustomLawyerDrawer extends StatelessWidget {
  const CustomLawyerDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.transparent,
      elevation: 0,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.kSurface.withOpacity(0.94),
              AppColors.kSurfaceElevated.withOpacity(0.88),
            ],
          ),
          border: Border(
            right: BorderSide(
              color: AppColors.kEmerald.withOpacity(0.18),
              width: 1.4,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.45),
              blurRadius: 32,
              offset: const Offset(8, 0),
            ),
          ],
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Padding(
                padding: EdgeInsets.fromLTRB(6.w, 4.h, 6.w, 2.h),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.kEmerald.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.gavel_rounded,
                        color: AppColors.kEmerald,
                        size: 28,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    CustomText(
                      title: 'Lawyer Panel',
                      fontSize: 20.sp,
                      weight: FontWeight.w800,
                      color: AppColors.kTextPrimary,
                    ),
                  ],
                ),
              ),

              const Divider(
                color: AppColors.kEmerald,
                height: 1,
                thickness: 1.2,
                indent: 20,
                endIndent: 20,
              ),

              SizedBox(height: 2.h),

              // Drawer items (you can add more later)
              _buildDrawerItem(
                icon: Icons.dashboard_rounded,
                title: 'Dashboard',
                onTap: () {
                  Navigator.pop(context);
                  // already on dashboard
                },
              ),

              // Placeholder for future items
              _buildDrawerItem(
                icon: Icons.description_rounded,
                title: 'My Cases',
                onTap: () {
                  Navigator.pop(context);
                  // navigate if needed
                },
              ),

              _buildDrawerItem(
                icon: Icons.person_rounded,
                title: 'Profile',
                onTap: () {
                  Navigator.pop(context);
                  // context.go(RouteNames.lawyerProfile);
                },
              ),

              const Spacer(),

              // Logout section
              Padding(
                padding: EdgeInsets.fromLTRB(6.w, 2.h, 6.w, 5.h),
                child: _buildDrawerItem(
                  icon: Icons.logout_rounded,
                  title: 'Logout',
                  color: Colors.redAccent,
                  onTap: () => _confirmAndLogout(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    Color? color,
    required VoidCallback onTap,
  }) {
    final itemColor = color ?? AppColors.kTextPrimary;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.6.h),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: itemColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: itemColor, size: 26),
            ),
            SizedBox(width: 5.w),
            CustomText(
              title: title,
              fontSize: 16.sp,
              weight: FontWeight.w600,
              color: itemColor,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmAndLogout(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.kSurface.withOpacity(0.96),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            'Logout',
            style: TextStyle(
              color: AppColors.kTextPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
          content: Text(
            'Are you sure you want to sign out?',
            style: TextStyle(color: AppColors.kTextSecondary),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: Text(
                'Cancel',
                style: TextStyle(color: AppColors.kTextSecondary),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: Text('Logout', style: TextStyle(color: Colors.redAccent)),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      await StorageService.instance.clearAllAuthData();
      Navigator.pop(context); // close drawer
      context.go(RouteNames.incomingUserScreen);
    }
  }
}
