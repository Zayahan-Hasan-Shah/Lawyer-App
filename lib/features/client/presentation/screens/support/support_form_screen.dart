import 'package:flutter/material.dart';
import 'package:lawyer_app/core/constants/app_colors.dart';
import 'package:lawyer_app/shared/widgets/custom_button.dart';
import 'package:lawyer_app/shared/widgets/custom_text.dart';
import 'package:lawyer_app/shared/widgets/custom_text_field.dart';
import 'package:sizer/sizer.dart';

class SupportFormScreen extends StatelessWidget {
  const SupportFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kBgDark,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: CustomText(
          title: "Get Support",
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
            CustomText(
              title: "How can we help you?",
              fontSize: 24.sp,
              weight: FontWeight.bold,
              color: AppColors.kGold,
            ),
            SizedBox(height: 1.h),
            CustomText(
              title: "Submit your query and our team will get back to you within 24 hours.",
              fontSize: 14.sp,
              color: AppColors.kTextSecondary,
            ),
            SizedBox(height: 4.h),
            
            const CustomTextField(
              hintText: "Subject",
              prefixIcon: Icon(Icons.subject_rounded),
            ),
            SizedBox(height: 2.h),
            
            Container(
              decoration: BoxDecoration(
                color: AppColors.kInputBg,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.kGold.withOpacity(0.2)),
              ),
              child: const TextField(
                maxLines: 6,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Describe your issue here...",
                  hintStyle: TextStyle(color: Colors.white54),
                  contentPadding: EdgeInsets.all(20),
                  border: InputBorder.none,
                ),
              ),
            ),
            
            SizedBox(height: 4.h),
            
            CustomButton(
              text: "Submit Query",
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Support request submitted!")),
                );
                Navigator.pop(context);
              },
              gradient: AppColors.goldGradient,
              textColor: Colors.black,
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
          ],
        ),
      ),
    );
  }
}
