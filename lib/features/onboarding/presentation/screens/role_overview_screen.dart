import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lawyer_app/app/router/route_names.dart';
import 'package:lawyer_app/core/constants/app_assets.dart';
import 'package:lawyer_app/core/constants/app_colors.dart';
import 'package:lawyer_app/features/onboarding/presentation/widgets/role_card.dart';
import 'package:lawyer_app/shared/widgets/custom_button.dart';
import 'package:lawyer_app/shared/widgets/custom_text.dart';
import 'package:sizer/sizer.dart';

class RoleOverviewScreen extends StatelessWidget {
  const RoleOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kBg,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Header Logo
                    Container(
                      height: 12.h,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.kGold.withOpacity(0.15),
                            blurRadius: 30,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Image.asset(
                        AppAssets.logoImage,
                        fit: BoxFit.contain,
                      ),
                    ),
                    SizedBox(height: 3.h),
                    CustomText(
                      title: "Welcome to",
                      fontSize: 18.sp,
                      color: AppColors.kTextSecondary,
                      weight: FontWeight.w500,
                    ),
                    CustomText(
                      title: "Justice Simplified",
                      fontSize: 26.sp,
                      color: AppColors.kGoldLight,
                      weight: FontWeight.w800,
                      letterSpacing: 1.2,
                      alignText: TextAlign.center,
                    ),
                    SizedBox(height: 1.h),
                    CustomText(
                      title: "Choose your role below to continue.",
                      fontSize: 15.sp,
                      color: AppColors.kTextSecondary,
                    ),
                    SizedBox(height: 3.h),

                    // Role Cards
                    RoleCard(
                      title: "Law Student",
                      description:
                          "Enroll in exclusive certification programs, access top-tier internships, and track your tasks to kickstart your legal career.",
                      imagePath: AppAssets.roleStudentImage,
                      buttonText: "Get Started as Student \u2192",
                      onGetStarted: () =>
                          context.push(RouteNames.studentSignupScreen),
                    ),

                    RoleCard(
                      title: "Legal Client",
                      description:
                          "Easily find and hire professional lawyers for your specific case type. Chat, video call, and get justice simplified.",
                      imagePath: AppAssets.roleClientImage,
                      buttonText: "Get Started as Client \u2192",
                      onGetStarted: () => context.push(RouteNames.signupScreen),
                    ),

                    RoleCard(
                      title: "Legal Professional",
                      description:
                          "Expand your legal practice, manage active cases seamlessly, and connect with clients looking for your expertise.",
                      imagePath: AppAssets.roleLawyerImage,
                      buttonText: "Get Started as Lawyer \u2192",
                      onGetStarted: () =>
                          context.push(RouteNames.lawyerSignupScreen),
                    ),

                    RoleCard(
                      title: "Donor / Sponsor",
                      description:
                          "Support access to justice through charitable giving. Help fund pro bono cases and empower those in need.",
                      imagePath: AppAssets.roleDonorImage,
                      buttonText: "Get Started as Donor \u2192",
                      onGetStarted: () => context.push(
                        RouteNames.incomingUserScreen,
                      ), // Navigates to incoming user screen per feedback
                    ),

                    SizedBox(height: 4.h),

                    CustomButton(
                      text: "Select Your role",
                      onPressed: () {
                        context.push(RouteNames.incomingUserScreen);
                      },
                      gradient: AppColors.goldGradient,
                      width: double.infinity,
                      textColor: Colors.black,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
