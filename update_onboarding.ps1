$ErrorActionPreference = "Stop"

$onboardingScreen = @"
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lawyer_app/core/constants/app_colors.dart';
import 'package:lawyer_app/app/router/route_names.dart';
import 'package:lawyer_app/shared/widgets/custom_button.dart';
import 'package:lawyer_app/features/onboarding/presentation/widgets/book_appointment_widget.dart';
import 'package:lawyer_app/features/onboarding/presentation/widgets/pay_and_proceed_widget.dart';
import 'package:lawyer_app/features/onboarding/presentation/widgets/search_lawyer_widget.dart';
import 'package:sizer/sizer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoardingScreen extends ConsumerStatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  ConsumerState<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends ConsumerState<OnBoardingScreen> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  final List<Widget> _onboardingScreens = [
    const SearchLawyerWidget(),
    const BookAppointmentWidget(),
    const PayAndProceedWidget(),
  ];

  void _onNextPressed() {
    if (_currentPage < _onboardingScreens.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kBg,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Full screen PageView
          PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() => _currentPage = index);
            },
            children: _onboardingScreens,
          ),
          
          // Overlay Buttons & Indicator
          Positioned(
            bottom: 4.h,
            left: 0,
            right: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SmoothPageIndicator(
                  controller: _pageController,
                  count: _onboardingScreens.length,
                  effect: ExpandingDotsEffect(
                    expansionFactor: 3,
                    activeDotColor: AppColors.kGold,
                    dotColor: Colors.white.withOpacity(0.3),
                    dotHeight: 1.h,
                    dotWidth: 1.h,
                    spacing: 2.w,
                  ),
                ),
                SizedBox(height: 4.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 6.w),
                  child: Column(
                    children: [
                      CustomButton(
                        text: _currentPage == _onboardingScreens.length - 1
                            ? "Get Started"
                            : "Next",
                        onPressed: _currentPage == _onboardingScreens.length - 1
                            ? () {
                                context.go(RouteNames.roleOverviewScreen);
                              }
                            : _onNextPressed,
                        gradient: AppColors.goldGradient,
                        textColor: Colors.black,
                        borderRadius: 16,
                      ),
                      SizedBox(height: 1.5.h),
                      if (_currentPage != _onboardingScreens.length - 1)
                        TextButton(
                          onPressed: () {
                            context.go(RouteNames.roleOverviewScreen);
                          },
                          child: Text(
                            "Skip",
                            style: TextStyle(
                              color: AppColors.kTextSecondary,
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
"@
Set-Content -Path "lib/features/onboarding/presentation/screens/on_boarding_screen.dart" -Value $onboardingScreen -Encoding UTF8

$searchWidget = @"
import 'package:flutter/material.dart';
import 'package:lawyer_app/core/constants/app_assets.dart';
import 'package:lawyer_app/core/constants/app_colors.dart';
import 'package:lawyer_app/shared/widgets/custom_text.dart';
import 'package:sizer/sizer.dart';

class SearchLawyerWidget extends StatelessWidget {
  const SearchLawyerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(AppAssets.onboardingImage1, fit: BoxFit.cover),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                AppColors.kBg.withOpacity(0.6),
                AppColors.kBg,
                AppColors.kBg,
              ],
              stops: const [0.0, 0.4, 0.65, 1.0],
            ),
          ),
        ),
        Positioned(
          bottom: 25.h,
          left: 6.w,
          right: 6.w,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomText(
                title: 'Find The Best Lawyers',
                color: AppColors.kGoldLight,
                fontSize: 24.sp,
                weight: FontWeight.w800,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 1.5.h),
              CustomText(
                title: 'Search for highly rated professionals, explore their practice areas, and read detailed case histories.',
                color: AppColors.kTextSecondary,
                fontSize: 15.sp,
                maxLines: 3,
                textAlign: TextAlign.center,
                textHeight: 1.4,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
"@
Set-Content -Path "lib/features/onboarding/presentation/widgets/search_lawyer_widget.dart" -Value $searchWidget -Encoding UTF8

$bookWidget = @"
import 'package:flutter/material.dart';
import 'package:lawyer_app/core/constants/app_assets.dart';
import 'package:lawyer_app/core/constants/app_colors.dart';
import 'package:lawyer_app/shared/widgets/custom_text.dart';
import 'package:sizer/sizer.dart';

class BookAppointmentWidget extends StatelessWidget {
  const BookAppointmentWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(AppAssets.onboardingImage2, fit: BoxFit.cover),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                AppColors.kBg.withOpacity(0.6),
                AppColors.kBg,
                AppColors.kBg,
              ],
              stops: const [0.0, 0.4, 0.65, 1.0],
            ),
          ),
        ),
        Positioned(
          bottom: 25.h,
          left: 6.w,
          right: 6.w,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomText(
                title: 'Seamless Booking',
                color: AppColors.kGoldLight,
                fontSize: 24.sp,
                weight: FontWeight.w800,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 1.5.h),
              CustomText(
                title: 'Easily book appointments or jump into immediate video consultations with top-tier legal experts.',
                color: AppColors.kTextSecondary,
                fontSize: 15.sp,
                maxLines: 3,
                textAlign: TextAlign.center,
                textHeight: 1.4,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
"@
Set-Content -Path "lib/features/onboarding/presentation/widgets/book_appointment_widget.dart" -Value $bookWidget -Encoding UTF8

$payWidget = @"
import 'package:flutter/material.dart';
import 'package:lawyer_app/core/constants/app_assets.dart';
import 'package:lawyer_app/core/constants/app_colors.dart';
import 'package:lawyer_app/shared/widgets/custom_text.dart';
import 'package:sizer/sizer.dart';

class PayAndProceedWidget extends StatelessWidget {
  const PayAndProceedWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(AppAssets.onboardingImage3, fit: BoxFit.cover),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                AppColors.kBg.withOpacity(0.6),
                AppColors.kBg,
                AppColors.kBg,
              ],
              stops: const [0.0, 0.4, 0.65, 1.0],
            ),
          ),
        ),
        Positioned(
          bottom: 25.h,
          left: 6.w,
          right: 6.w,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomText(
                title: 'Secure & Transparent',
                color: AppColors.kGoldLight,
                fontSize: 24.sp,
                weight: FontWeight.w800,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 1.5.h),
              CustomText(
                title: 'Proceed with peace of mind. All interactions and payments are encrypted, fast, and fully secure.',
                color: AppColors.kTextSecondary,
                fontSize: 15.sp,
                maxLines: 3,
                textAlign: TextAlign.center,
                textHeight: 1.4,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
"@
Set-Content -Path "lib/features/onboarding/presentation/widgets/pay_and_proceed_widget.dart" -Value $payWidget -Encoding UTF8

Write-Host "Onboarding screens updated."
