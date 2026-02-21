import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lawyer_app/src/core/constants/app_colors.dart';
import 'package:lawyer_app/src/core/utils/storage/storage_service.dart';
import 'package:lawyer_app/src/routing/route_names.dart';
import 'package:lawyer_app/src/widgets/common_widgets/custom_text.dart';
import 'package:sizer/sizer.dart';

class CustomStudentDrawer extends StatelessWidget {
  const CustomStudentDrawer({super.key});

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
                        Icons.school_rounded,
                        color: AppColors.kEmerald,
                        size: 28,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    CustomText(
                      title: 'Student Panel',
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

              // Dashboard
              _buildDrawerItem(
                icon: Icons.dashboard_rounded,
                title: 'Dashboard',
                onTap: () {
                  Navigator.pop(context);
                  // Navigate to dashboard (index 0)
                  // This will be handled by the bottom navigation
                },
              ),

              // Certifications
              _buildDrawerItem(
                icon: Icons.school,
                title: 'Certifications',
                onTap: () {
                  Navigator.pop(context);
                  // Navigate to certifications (index 1)
                  // This will be handled by the bottom navigation
                },
              ),

              // Tasks
              _buildDrawerItem(
                icon: Icons.assignment,
                title: 'Tasks',
                onTap: () {
                  Navigator.pop(context);
                  // Navigate to tasks (index 2)
                  // This will be handled by the bottom navigation
                },
              ),

              // Research
              _buildDrawerItem(
                icon: Icons.science,
                title: 'Research',
                onTap: () {
                  Navigator.pop(context);
                  // Navigate to research (index 3)
                  // This will be handled by the bottom navigation
                },
              ),

              // Internships
              _buildDrawerItem(
                icon: Icons.business_center,
                title: 'Internships',
                onTap: () {
                  Navigator.pop(context);
                  _showComingSoon(context, 'Internships');
                },
              ),

              // Programs
              _buildDrawerItem(
                icon: Icons.video_library,
                title: 'Video Programs',
                onTap: () {
                  Navigator.pop(context);
                  _showComingSoon(context, 'Video Programs');
                },
              ),

              // Profile
              _buildDrawerItem(
                icon: Icons.person_rounded,
                title: 'Profile',
                onTap: () {
                  Navigator.pop(context);
                  // Navigate to profile (index 4)
                  // This will be handled by the bottom navigation
                },
              ),

              const Spacer(),

              // Settings
              _buildDrawerItem(
                icon: Icons.settings_rounded,
                title: 'Settings',
                onTap: () {
                  Navigator.pop(context);
                  _showComingSoon(context, 'Settings');
                },
              ),

              // // Help & Support
              // _buildDrawerItem(
              //   icon: Icons.help_rounded,
              //   title: 'Help & Support',
              //   onTap: () {
              //     Navigator.pop(context);
              //     _showComingSoon(context, 'Help & Support');
              //   },
              // ),

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

  void _showComingSoon(BuildContext context, String feature) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.kSurface.withOpacity(0.96),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            'Coming Soon',
            style: TextStyle(
              color: AppColors.kTextPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
          content: Text(
            '$feature feature will be available in the next update.',
            style: TextStyle(color: AppColors.kTextSecondary),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(
                'OK',
                style: TextStyle(color: AppColors.kEmerald),
              ),
            ),
          ],
        );
      },
    );
  }
}
