import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lawyer_app/core/constants/app_assets.dart';
import 'package:lawyer_app/core/constants/app_colors.dart';
import 'package:lawyer_app/features/lawyer/presentation/providers/lawyer_cases_provider/lawyer_case_provider.dart';
import 'package:lawyer_app/shared/widgets/custom_appbar.dart';
import 'package:lawyer_app/shared/widgets/custom_text.dart';
import 'package:lawyer_app/features/client/presentation/widgets/tabs/cases_tab_button.dart';
import 'package:lawyer_app/features/lawyer/presentation/widgets/dashboard_widgets/disposed_case_tab.dart';
import 'package:lawyer_app/features/lawyer/presentation/widgets/dashboard_widgets/pending_case_tab.dart';
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
      color: AppColors.kBgDark,
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

                    // Header + Statistics + Tabs
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

                          SizedBox(height: 3.h),

                          // Statistics Visualization
                          _buildStatistics(),

                          SizedBox(height: 3.h),

                          _buildNextHearingCard(),

                          SizedBox(height: 4.h),

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
                      loading: () => Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.h),
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.kEmerald,
                            strokeWidth: 4,
                          ),
                        ),
                      ),
                      failure: (error) => Padding(
                        padding: EdgeInsets.symmetric(vertical: 5.h),
                        child: Center(
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

  Widget _buildStatistics() {
    return Container(
      padding: EdgeInsets.all(5.w),
      decoration: BoxDecoration(
        color: AppColors.kSurface.withOpacity(0.5),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.kGold.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatItem("Total Cases", "24", AppColors.kGold),
              _buildStatItem("Won", "18", AppColors.kEmerald),
              _buildStatItem("Lost", "6", Colors.redAccent),
            ],
          ),
          SizedBox(height: 3.h),
          // Simple Bar Visualization
          Row(
            children: [
              Expanded(
                flex: 18,
                child: Container(
                  height: 8,
                  decoration: BoxDecoration(
                    color: AppColors.kEmerald,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(width: 2.w),
              Expanded(
                flex: 6,
                child: Container(
                  height: 8,
                  decoration: BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                title: "Win Rate: 75%",
                fontSize: 12.sp,
                color: AppColors.kTextSecondary,
              ),
              CustomText(
                title: "Loss Rate: 25%",
                fontSize: 12.sp,
                color: AppColors.kTextSecondary,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNextHearingCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.kGold.withOpacity(0.15), Colors.transparent],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.kGold.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: AppColors.kGold,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.event_note_rounded, color: Colors.black),
          ),
          SizedBox(width: 4.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  title: "Next Hearing",
                  fontSize: 13.sp,
                  color: AppColors.kGold,
                  weight: FontWeight.bold,
                ),
                CustomText(
                  title: "State vs Rajesh Kumar",
                  fontSize: 16.sp,
                  weight: FontWeight.w700,
                  color: AppColors.kTextPrimary,
                ),
                CustomText(
                  title: "Tomorrow at 10:00 AM • Delhi High Court",
                  fontSize: 12.sp,
                  color: AppColors.kTextSecondary,
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded, color: AppColors.kGold),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        CustomText(
          title: value,
          fontSize: 22.sp,
          weight: FontWeight.bold,
          color: color,
        ),
        CustomText(
          title: label,
          fontSize: 12.sp,
          color: AppColors.kTextSecondary,
        ),
      ],
    );
  }
}
