import 'package:flutter/material.dart';
import 'package:lawyer_app/core/constants/app_colors.dart';
import 'package:lawyer_app/shared/widgets/custom_text.dart';
import 'package:sizer/sizer.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kBgDark,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: CustomText(
          title: "Help & Support",
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
            _buildContactCard(),
            SizedBox(height: 4.h),
            _buildSectionTitle("Frequently Asked Questions"),
            _buildFAQTile("How do I contact a lawyer?", "You can search for lawyers in the search tab and take an appointment."),
            _buildFAQTile("How do I track my case?", "Your pending and disposed cases are available on your home dashboard."),
            _buildFAQTile("Is my data secure?", "Yes, we use end-to-end encryption for all chats and data storage."),
            
            SizedBox(height: 3.h),
            _buildSectionTitle("Legal"),
            _buildLegalTile("Terms of Service"),
            _buildLegalTile("Privacy Policy"),
          ],
        ),
      ),
    );
  }

  Widget _buildContactCard() {
    return Container(
      padding: EdgeInsets.all(5.w),
      decoration: BoxDecoration(
        gradient: AppColors.goldGradient,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            title: "Need immediate help?",
            fontSize: 20.sp,
            weight: FontWeight.bold,
            color: Colors.black,
          ),
          SizedBox(height: 1.h),
          CustomText(
            title: "Our support team is available 24/7 to assist you with any legal or technical issues.",
            fontSize: 14.sp,
            color: Colors.black87,
          ),
          SizedBox(height: 3.h),
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.headset_mic_rounded, color: Colors.white),
            label: const Text("Contact Support"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.5.h),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(left: 2.w, bottom: 2.h),
      child: CustomText(
        title: title,
        fontSize: 16.sp,
        weight: FontWeight.bold,
        color: AppColors.kGold,
      ),
    );
  }

  Widget _buildFAQTile(String question, String answer) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      decoration: BoxDecoration(
        color: AppColors.kSurface.withOpacity(0.5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: ExpansionTile(
        title: CustomText(title: question, fontSize: 16.sp, weight: FontWeight.w600, color: AppColors.kTextPrimary),
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(4.w, 0, 4.w, 2.h),
            child: CustomText(title: answer, fontSize: 14.sp, color: AppColors.kTextSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildLegalTile(String title) {
    return ListTile(
      title: CustomText(title: title, fontSize: 16.sp, color: AppColors.kTextPrimary),
      trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.kTextSecondary),
      onTap: () {},
    );
  }
}
