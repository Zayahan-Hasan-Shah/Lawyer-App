import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lawyer_app/src/core/constants/app_assets.dart';
import 'package:lawyer_app/src/core/constants/app_colors.dart';
import 'package:lawyer_app/src/providers/lawyer_provider/lawyer_cases_provider/lawyer_case_provider.dart';
import 'package:lawyer_app/src/widgets/common_widgets/custom_appbar.dart';
import 'package:lawyer_app/src/widgets/common_widgets/custom_text.dart';
import 'package:lawyer_app/src/widgets/home_widgets/tabs/cases_tab_button.dart';
import 'package:lawyer_app/src/widgets/lawyer_widgets/dashboard_widgets/disposed_case_tab.dart';
import 'package:lawyer_app/src/widgets/lawyer_widgets/dashboard_widgets/pending_case_tab.dart';
import 'package:sizer/sizer.dart';

class LawyerDashboardScreen extends ConsumerStatefulWidget {
  const LawyerDashboardScreen({super.key});

  @override
  ConsumerState<LawyerDashboardScreen> createState() =>
      _LawyerDashboardScreenState();
}

class _LawyerDashboardScreenState extends ConsumerState<LawyerDashboardScreen> {
  int selectedTab = 0;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(lawyerCaseControllerProvider.notifier).getAllCases();
    });
  }

  void _onTabChanged(int index) {
    setState(() => selectedTab = index);
  }

  @override
  Widget build(BuildContext context) {
    final caseState = ref.watch(lawyerCaseControllerProvider);

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF0D1117), // deep navy black
            Color(0xFF0A1F24), // very dark teal/emerald dark
            Color(0xFF08151A), // almost black
          ],
          stops: [0.0, 0.6, 1.0],
        ),
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // AppBar (assuming CustomAppbar is transparent or fits dark theme)
            CustomAppbar(
              logoImage: AppAssets.logoImage,
              backgroundColor: Colors.transparent,
            ),

            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                // scrollDirection: Axis.vertical,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 2.h),

                    // Header + Tabs
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 6.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            title: "Cases",
                            color: AppColors.kTextPrimary,
                            fontSize: 26.sp,
                            weight: FontWeight.w800,
                          ),
                          SizedBox(height: 0.4.h),
                          CustomText(
                            title: "Manage your pending & disposed matters",
                            color: AppColors.kTextSecondary,
                            fontSize: 15.sp,
                          ),
                          SizedBox(height: 2.5.h),

                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                CasesTabButton(
                                  title: 'Pending',
                                  index: 0,
                                  selectedTab: selectedTab,
                                  onTap: _onTabChanged,
                                ),
                                SizedBox(width: 4.w),
                                CasesTabButton(
                                  title: 'Disposed',
                                  index: 1,
                                  selectedTab: selectedTab,
                                  onTap: _onTabChanged,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 3.h),

                    // Content Area
                    caseState.when(
                      initial: () => const SizedBox(),
                      loading: () => Center(
                        child: CircularProgressIndicator(
                          color: AppColors.kEmerald,
                          strokeWidth: 4,
                        ),
                      ),
                      failure: (error) => Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error_outline_rounded,
                              size: 80,
                              color: Colors.redAccent,
                            ),
                            SizedBox(height: 2.h),
                            CustomText(
                              title: 'Failed to load cases',
                              color: AppColors.kTextPrimary,
                              fontSize: 18.sp,
                              weight: FontWeight.w600,
                            ),
                            SizedBox(height: 1.h),
                            CustomText(
                              title: error,
                              color: Colors.redAccent,
                              fontSize: 14.sp,
                              alignText: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      success: (data) => AnimatedSwitcher(
                        duration: const Duration(milliseconds: 400),
                        transitionBuilder: (child, animation) =>
                            FadeTransition(opacity: animation, child: child),
                        child: selectedTab == 0
                            ? PendingLawyerCasesTab(
                                key: const ValueKey('pending'),
                                cases: data.pendingCases,
                              )
                            : DisposedLawyerCasesTab(
                                key: const ValueKey('disposed'),
                                cases: data.disposedCases,
                              ),
                      ),
                    ),
                    SizedBox(height: 8.h),
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
