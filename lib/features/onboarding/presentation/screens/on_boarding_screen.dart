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
