import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lawyer_app/src/core/constants/app_assets.dart';
import 'package:lawyer_app/src/core/constants/app_colors.dart';
import 'package:lawyer_app/src/models/student_model/student_model.dart';
import 'package:lawyer_app/src/widgets/common_widgets/custom_appbar.dart';
import 'package:lawyer_app/src/widgets/common_widgets/custom_text.dart';
import 'package:sizer/sizer.dart';

class StudentProfileScreen extends ConsumerStatefulWidget {
  const StudentProfileScreen({super.key});

  @override
  ConsumerState<StudentProfileScreen> createState() => _StudentProfileScreenState();
}

class _StudentProfileScreenState extends ConsumerState<StudentProfileScreen> {
  // Mock student data
  final StudentModel student = StudentModel(
    id: '1',
    fullName: 'John Doe',
    university: 'Harvard University',
    studyYear: '3rd Year',
    currentProgram: 'Computer Science',
    email: 'john.doe@harvard.edu',
    profileImage: '',
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF0D1117),
            Color(0xFF0A1F24),
            Color(0xFF08151A),
          ],
          stops: [0.0, 0.6, 1.0],
        ),
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomAppbar(
              logoImage: AppAssets.logoImage,
              backgroundColor: Colors.transparent,
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(6.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 2.h),
                    
                    // Profile Header
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(5.w),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.kSurface.withOpacity(0.8),
                            AppColors.kSurfaceElevated.withOpacity(0.6),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppColors.kEmerald.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 10.w,
                            backgroundColor: AppColors.kEmerald.withOpacity(0.2),
                            child: Icon(
                              Icons.person,
                              size: 8.w,
                              color: AppColors.kEmerald,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          CustomText(
                            title: student.fullName,
                            fontSize: 22.sp,
                            weight: FontWeight.w700,
                            color: AppColors.kTextPrimary,
                          ),
                          SizedBox(height: 0.5.h),
                          CustomText(
                            title: student.email,
                            fontSize: 14.sp,
                            color: AppColors.kTextSecondary,
                          ),
                          SizedBox(height: 3.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildStatItem("3", "Active Tasks"),
                              _buildStatItem("2", "Certifications"),
                              _buildStatItem("2", "Research"),
                            ],
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 3.h),

                    // Academic Information
                    _buildSectionCard(
                      "Academic Information",
                      Icons.school,
                      [
                        _buildInfoRow("University", student.university),
                        _buildInfoRow("Study Year", student.studyYear),
                        _buildInfoRow("Current Program", student.currentProgram),
                      ],
                    ),

                    SizedBox(height: 2.h),

                    // Account Settings
                    _buildSectionCard(
                      "Account Settings",
                      Icons.settings,
                      [
                        _buildMenuRow(
                          "Edit Profile",
                          Icons.edit,
                          () => _showEditProfileDialog(context),
                        ),
                        _buildMenuRow(
                          "Change Password",
                          Icons.lock,
                          () => _showChangePasswordDialog(context),
                        ),
                        _buildMenuRow(
                          "Notifications",
                          Icons.notifications,
                          () => _showNotificationsDialog(context),
                        ),
                      ],
                    ),

                    SizedBox(height: 2.h),

                    // Support
                    _buildSectionCard(
                      "Support",
                      Icons.help,
                      [
                        _buildMenuRow(
                          "Help Center",
                          Icons.help_outline,
                          () => _showHelpDialog(context),
                        ),
                        _buildMenuRow(
                          "About",
                          Icons.info_outline,
                          () => _showAboutDialog(context),
                        ),
                      ],
                    ),

                    SizedBox(height: 3.h),

                    // Logout Button
                    Container(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => _showLogoutDialog(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent.withOpacity(0.2),
                          foregroundColor: Colors.redAccent,
                          padding: EdgeInsets.symmetric(vertical: 2.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(color: Colors.redAccent.withOpacity(0.5)),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.logout),
                            SizedBox(width: 2.w),
                            Text(
                              "Logout",
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 5.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        CustomText(
          title: value,
          fontSize: 20.sp,
          weight: FontWeight.w700,
          color: AppColors.kEmerald,
        ),
        SizedBox(height: 0.5.h),
        CustomText(
          title: label,
          fontSize: 12.sp,
          color: AppColors.kTextSecondary,
        ),
      ],
    );
  }

  Widget _buildSectionCard(String title, IconData icon, List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.kSurface.withOpacity(0.8),
            AppColors.kSurfaceElevated.withOpacity(0.6),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.kEmerald.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: AppColors.kEmerald,
                  size: 6.w,
                ),
                SizedBox(width: 2.w),
                CustomText(
                  title: title,
                  fontSize: 18.sp,
                  weight: FontWeight.w600,
                  color: AppColors.kTextPrimary,
                ),
              ],
            ),
          ),
          Divider(
            color: AppColors.kEmerald.withOpacity(0.2),
            height: 1,
          ),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 30.w,
            child: CustomText(
              title: label,
              fontSize: 14.sp,
              color: AppColors.kTextSecondary,
              weight: FontWeight.w500,
            ),
          ),
          Expanded(
            child: CustomText(
              title: value,
              fontSize: 14.sp,
              color: AppColors.kTextPrimary,
              weight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuRow(String title, IconData icon, VoidCallback onTap) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
          child: Row(
            children: [
              Icon(
                icon,
                color: AppColors.kEmerald,
                size: 5.w,
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: CustomText(
                  title: title,
                  fontSize: 14.sp,
                  color: AppColors.kTextPrimary,
                  weight: FontWeight.w500,
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: AppColors.kTextSecondary,
                size: 4.w,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showEditProfileDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.kSurface.withOpacity(0.96),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(
          'Edit Profile',
          style: TextStyle(
            color: AppColors.kTextPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        content: Text(
          'Profile editing functionality will be implemented here.',
          style: TextStyle(color: AppColors.kTextSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'OK',
              style: TextStyle(color: AppColors.kEmerald),
            ),
          ),
        ],
      ),
    );
  }

  void _showChangePasswordDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.kSurface.withOpacity(0.96),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(
          'Change Password',
          style: TextStyle(
            color: AppColors.kTextPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        content: Text(
          'Password change functionality will be implemented here.',
          style: TextStyle(color: AppColors.kTextSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'OK',
              style: TextStyle(color: AppColors.kEmerald),
            ),
          ),
        ],
      ),
    );
  }

  void _showNotificationsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.kSurface.withOpacity(0.96),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(
          'Notification Settings',
          style: TextStyle(
            color: AppColors.kTextPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        content: Text(
          'Notification settings will be implemented here.',
          style: TextStyle(color: AppColors.kTextSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'OK',
              style: TextStyle(color: AppColors.kEmerald),
            ),
          ),
        ],
      ),
    );
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.kSurface.withOpacity(0.96),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(
          'Help Center',
          style: TextStyle(
            color: AppColors.kTextPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        content: Text(
          'Help center and support documentation will be available here.',
          style: TextStyle(color: AppColors.kTextSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'OK',
              style: TextStyle(color: AppColors.kEmerald),
            ),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.kSurface.withOpacity(0.96),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(
          'About',
          style: TextStyle(
            color: AppColors.kTextPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Lawyer App - Student Module',
              style: TextStyle(
                color: AppColors.kTextPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              'Version 1.0.0\n\nA comprehensive platform for students to manage their academic journey, certifications, tasks, and research activities.',
              style: TextStyle(color: AppColors.kTextSecondary),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'OK',
              style: TextStyle(color: AppColors.kEmerald),
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
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
          'Are you sure you want to logout?',
          style: TextStyle(color: AppColors.kTextSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: AppColors.kTextSecondary),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implement logout functionality
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Logout functionality will be implemented'),
                  backgroundColor: AppColors.kEmerald,
                ),
              );
            },
            child: Text(
              'Logout',
              style: TextStyle(color: Colors.redAccent),
            ),
          ),
        ],
      ),
    );
  }
}
