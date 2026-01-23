import 'package:flutter/material.dart';
import 'package:lawyer_app/src/core/constants/app_colors.dart';
import 'package:lawyer_app/src/widgets/common_widgets/custom_button.dart';
import 'package:lawyer_app/src/widgets/common_widgets/custom_text.dart';
import 'package:sizer/sizer.dart';

class DonationsTab extends StatelessWidget {
  const DonationsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        // gradient: LinearGradient(
        //   begin: Alignment.topCenter,
        //   end: Alignment.bottomCenter,
        //   colors: [Color(0xFF0D1117), Color(0xFF0A1F24), Color(0xFF08151A)],
        //   stops: [0.0, 0.6, 1.0],
        // ),
      ),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Floating emerald glow heart icon
              Container(
                width: 20.h,
                height: 20.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      AppColors.kEmerald.withOpacity(0.38),
                      AppColors.kEmeraldDark.withOpacity(0.18),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    // BoxShadow(
                    //   color: AppColors.kEmerald.withOpacity(0.45),
                    //   blurRadius: 40,
                    //   spreadRadius: 10,
                    // ),
                    BoxShadow(
                      color: Colors.black.withOpacity(0.35),
                      blurRadius: 50,
                      offset: const Offset(0, 20),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.volunteer_activism_rounded,
                  size: 14.h,
                  color: Colors.white,
                ),
              ),

              SizedBox(height: 3.h),

              // Main title
              CustomText(
                title: "Support Access to Justice",
                fontSize: 24.sp,
                weight: FontWeight.w800,
                color: AppColors.kTextPrimary,
                alignText: TextAlign.center,
                maxLines: 2,
              ),

              SizedBox(height: 0.5.h),

              // Subtitle
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: CustomText(
                  title:
                      "Your contribution helps provide legal aid to those who need it most",
                  fontSize: 16.sp,
                  color: AppColors.kTextSecondary,
                  alignText: TextAlign.center,
                  textHeight: 1.45,
                  maxLines: 3,
                ),
              ),

              SizedBox(height: 3.h),

              // Impact highlights (optional trust builders)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _impactItem("1000+", "People Helped"),
                    _impactItem("5M+", "Raised"),
                  ],
                ),
              ),

              SizedBox(height: 3.5.h),

              // Donate CTA Button
              SizedBox(
                width: 70.w,
                height: 60,
                child: CustomButton(
                  text: "Donate Now",
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text("Donation flow coming soon"),
                        backgroundColor: AppColors.kEmerald,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    );
                  },
                  gradient: LinearGradient(
                    colors: [AppColors.kEmerald, AppColors.kEmeraldDark],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  textColor: Colors.white,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  borderRadius: 20,
                ),
              ),

              SizedBox(height: 2.5.h),

              // Small trust note
              Opacity(
                opacity: 0.75,
                child: Text(
                  "100% secure • Tax receipts provided • Every rupee counts",
                  style: TextStyle(
                    color: AppColors.kTextSecondary,
                    fontSize: 14.sp,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              SizedBox(height: 8.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _impactItem(String value, String label) {
    return Column(
      children: [
        CustomText(
          title: value,
          fontSize: 22.sp,
          weight: FontWeight.w800,
          color: AppColors.kEmerald,
        ),
        SizedBox(height: 0.4.h),
        CustomText(
          title: label,
          fontSize: 13.5.sp,
          color: AppColors.kTextSecondary,
        ),
      ],
    );
  }
}
