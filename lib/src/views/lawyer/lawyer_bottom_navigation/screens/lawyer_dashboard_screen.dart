import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lawyer_app/src/core/constants/app_assets.dart';
import 'package:lawyer_app/src/core/constants/app_colors.dart';
import 'package:lawyer_app/src/providers/lawyer_provider/lawyer_cases_provider/lawyer_case_provider.dart';
import 'package:lawyer_app/src/widgets/common_widgets/custom_appbar.dart';
import 'package:lawyer_app/src/widgets/common_widgets/custom_client_drawer.dart';
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
    setState(() {
      selectedTab = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final caseState = ref.watch(lawyerCaseControllerProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: CustomAppbar(isDrawwer: true, logoImage: AppAssets.logoImage),
      drawer: CustomClientDrawer(),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 3.h),

            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 2.w),
              child: Row(
                children: [
                  CasesTabButton(
                    title: 'Pending',
                    index: 0,
                    selectedTab: selectedTab,
                    onTap: _onTabChanged,
                  ),
                  SizedBox(width: 3.w),
                  CasesTabButton(
                    title: 'Disposed',
                    index: 1,
                    selectedTab: selectedTab,
                    onTap: _onTabChanged,
                  ),
                ],
              ),
            ),
            SizedBox(height: 3.h),
            Expanded(
              child: caseState.when(
                initial: () => const SizedBox(),
                loading: () => const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.brightYellowColor,
                    strokeWidth: 4,
                  ),
                ),
                failure: (error) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 80,
                        color: Colors.redAccent,
                      ),
                      SizedBox(height: 2.h),
                      CustomText(
                        title: 'Failed to load dashboard',
                        fontSize: 18.sp,
                        color: AppColors.whiteColor,
                      ),
                      SizedBox(height: 1.h),
                      CustomText(
                        title: error,
                        fontSize: 12.sp,
                        color: Colors.redAccent,
                        maxLines: 3,
                      ),
                    ],
                  ),
                ),
                success: (data) => AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: selectedTab == 0
                      ? PendingLawyerCasesTab(
                          key: const ValueKey(0),
                          cases: data.pendingCases,
                        )
                      : DisposedLawyerCasesTab(
                          key: const ValueKey(1),
                          cases: data.disposedCases,
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
