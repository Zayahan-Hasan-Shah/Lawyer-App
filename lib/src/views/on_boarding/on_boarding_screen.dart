import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lawyer_app/src/core/constants/app_colors.dart';
import 'package:lawyer_app/src/routing/route_names.dart';
import 'package:lawyer_app/src/widgets/common_widgets/custom_button.dart';
import 'package:lawyer_app/src/widgets/on_boarding_widget/book_appointment_widget.dart';
import 'package:lawyer_app/src/widgets/on_boarding_widget/pay_and_proceed_widget.dart';
import 'package:lawyer_app/src/widgets/on_boarding_widget/search_lawyer_widget.dart';
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
    } else {
      // 👇 Navigate to next screen (e.g., login or home)
      // Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        body: Stack(
          fit: StackFit.expand,
          children: [
            // --- Main content ---
            Column(
              children: [
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() => _currentPage = index);
                    },
                    children: _onboardingScreens,
                  ),
                ),

                // --- Page indicator ---
                SizedBox(height: 2.h),
                ShaderMask(
                  shaderCallback: (Rect bounds) {
                    return AppColors.buttonGradientColor.createShader(bounds);
                  },
                  blendMode: BlendMode.srcIn,
                  child: SmoothPageIndicator(
                    controller: _pageController,
                    count: _onboardingScreens.length,
                    effect: ExpandingDotsEffect(
                      expansionFactor: 3,
                      activeDotColor: Colors.white,
                      dotColor: Colors.white.withOpacity(0.5),
                      dotHeight: 1.2.h,
                      dotWidth: 1.2.h,
                      spacing: 1.5.w,
                    ),
                  ),
                ),

                SizedBox(height: 4.h),

                // --- Bottom buttons ---
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  child: Column(
                    children: [
                      CustomButton(
                        text: _currentPage == _onboardingScreens.length - 1
                            ? "Get Started"
                            : "Next",
                        onPressed: _currentPage == _onboardingScreens.length - 1
                            ? () {
                                context.go(RouteNames.signupScreen);
                              }
                            : _onNextPressed,
                        gradient: AppColors.buttonGradientColor,
                        width: double.infinity,
                        borderRadius: 30,
                        textColor: AppColors.blackColor,
                        fontSize: 16.sp,
                      ),
                      SizedBox(height: 2.h),

                      // --- Skip button only if not last page ---
                      if (_currentPage != _onboardingScreens.length - 1)
                        CustomButton(
                          text: "Skip",
                          onPressed: () {
                            context.go(RouteNames.incomingUserScreen);
                            // _pageController.jumpToPage(
                            //   _onboardingScreens.length - 1,
                            // );
                          },
                          backgroundColor: AppColors.backgroundColor,
                          width: double.infinity,
                          borderRadius: 30,
                          textColor: AppColors.whiteColor,
                          fontSize: 16.sp,
                        ),
                    ],
                  ),
                ),
                SizedBox(height: 4.h),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
