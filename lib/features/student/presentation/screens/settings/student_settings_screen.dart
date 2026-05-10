import 'package:flutter/material.dart';
import 'package:lawyer_app/core/constants/app_colors.dart';
import 'package:lawyer_app/shared/widgets/custom_text.dart';
import 'package:sizer/sizer.dart';

class StudentSettingsScreen extends StatelessWidget {
  const StudentSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kBgDark,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: CustomText(
          title: "Settings",
          fontSize: 22.sp,
          weight: FontWeight.w800,
          color: AppColors.kTextPrimary,
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileSection(),
            SizedBox(height: 4.h),
            _buildSectionTitle("Academic"),
            _buildSettingTile(Icons.school_outlined, "Learning Progress", "Track your certification status"),
            _buildSettingTile(Icons.book_online_outlined, "Library", "Saved research and documents"),
            
            SizedBox(height: 3.h),
            _buildSectionTitle("Account"),
            _buildSettingTile(Icons.person_outline_rounded, "Edit Profile", "Change your personal information"),
            _buildSettingTile(Icons.notifications_none_rounded, "Notifications", "Manage your alert preferences"),
            
            SizedBox(height: 3.h),
            _buildSectionTitle("General"),
            _buildSettingTile(Icons.language_rounded, "Language", "English (United States)"),
            _buildSettingTile(Icons.dark_mode_outlined, "Theme", "Dark Mode"),
            
            SizedBox(height: 5.h),
            _buildLogoutButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSection() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppColors.kSurface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.kGold.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 4.h,
            backgroundColor: AppColors.kGold.withOpacity(0.2),
            child: Icon(Icons.school_rounded, size: 4.h, color: AppColors.kGold),
          ),
          SizedBox(width: 4.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  title: "Student Name",
                  fontSize: 18.sp,
                  weight: FontWeight.w700,
                  color: AppColors.kTextPrimary,
                ),
                CustomText(
                  title: "student@example.com",
                  fontSize: 14.sp,
                  color: AppColors.kTextSecondary,
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit_rounded, color: AppColors.kGold),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(left: 2.w, bottom: 1.5.h),
      child: CustomText(
        title: title,
        fontSize: 15.sp,
        weight: FontWeight.w600,
        color: AppColors.kGold,
      ),
    );
  }

  Widget _buildSettingTile(IconData icon, String title, String subtitle) {
    return Container(
      margin: EdgeInsets.only(bottom: 1.5.h),
      decoration: BoxDecoration(
        color: AppColors.kSurface.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        leading: Icon(icon, color: AppColors.kTextPrimary),
        title: CustomText(
          title: title,
          fontSize: 16.sp,
          weight: FontWeight.w500,
          color: AppColors.kTextPrimary,
        ),
        subtitle: CustomText(
          title: subtitle,
          fontSize: 12.sp,
          color: AppColors.kTextSecondary,
        ),
        trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.kTextSecondary),
        onTap: () {},
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 2.h),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.redAccent.withOpacity(0.5)),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.logout_rounded, color: Colors.redAccent),
              SizedBox(width: 2.w),
              CustomText(
                title: "Log Out",
                fontSize: 16.sp,
                weight: FontWeight.w700,
                color: Colors.redAccent,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
