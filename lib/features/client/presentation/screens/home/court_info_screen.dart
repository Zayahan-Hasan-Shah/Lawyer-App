import 'package:flutter/material.dart';
import 'package:lawyer_app/core/constants/app_colors.dart';
import 'package:lawyer_app/shared/widgets/custom_text.dart';
import 'package:sizer/sizer.dart';

class CourtInfoScreen extends StatelessWidget {
  const CourtInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kBgDark,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: CustomText(
          title: "Court Information",
          fontSize: 20.sp,
          weight: FontWeight.w800,
          color: AppColors.kTextPrimary,
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(6.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCourtHeader(),
            SizedBox(height: 4.h),
            _buildSectionTitle("Popular Courts"),
            _buildCourtCard("Supreme Court of India", "New Delhi", 4.8),
            _buildCourtCard("Delhi High Court", "New Delhi", 4.5),
            _buildCourtCard("Bombay High Court", "Mumbai", 4.6),
            
            SizedBox(height: 3.h),
            _buildSectionTitle("Legal Guide"),
            _buildGuideTile("Filing a Case", "Learn the step-by-step process of filing a new matter."),
            _buildGuideTile("Court Etiquette", "Important rules and decorum to follow inside the courtroom."),
          ],
        ),
      ),
    );
  }

  Widget _buildCourtHeader() {
    return Container(
      padding: EdgeInsets.all(5.w),
      decoration: BoxDecoration(
        color: AppColors.kSurface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.kGold.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Icon(Icons.account_balance_rounded, size: 50, color: AppColors.kGold),
          SizedBox(height: 2.h),
          CustomText(
            title: "Judicial Directory",
            fontSize: 22.sp,
            weight: FontWeight.bold,
            color: AppColors.kTextPrimary,
          ),
          CustomText(
            title: "Access information about courts, judges, and legal procedures across the country.",
            fontSize: 14.sp,
            color: AppColors.kTextSecondary,
            alignText: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 2.h),
      child: CustomText(
        title: title,
        fontSize: 18.sp,
        weight: FontWeight.bold,
        color: AppColors.kGold,
      ),
    );
  }

  Widget _buildCourtCard(String name, String location, double rating) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppColors.kSurface.withOpacity(0.6),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(title: name, fontSize: 17.sp, weight: FontWeight.bold, color: AppColors.kTextPrimary),
                CustomText(title: location, fontSize: 14.sp, color: AppColors.kTextSecondary),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.8.h),
            decoration: BoxDecoration(
              color: AppColors.kGold.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.star_rounded, color: AppColors.kGold, size: 18),
                SizedBox(width: 1.w),
                CustomText(title: rating.toString(), fontSize: 14.sp, weight: FontWeight.bold, color: AppColors.kGold),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGuideTile(String title, String desc) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: CustomText(title: title, fontSize: 16.sp, weight: FontWeight.w600, color: AppColors.kTextPrimary),
      subtitle: CustomText(title: desc, fontSize: 13.sp, color: AppColors.kTextSecondary),
      trailing: const Icon(Icons.arrow_forward_ios_rounded, color: AppColors.kGold, size: 16),
      onTap: () {},
    );
  }
}
