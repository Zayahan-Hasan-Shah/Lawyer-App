import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lawyer_app/src/core/constants/app_assets.dart';
import 'package:lawyer_app/src/core/constants/app_colors.dart';
import 'package:lawyer_app/src/models/client_model/case_model/case_model.dart';
import 'package:lawyer_app/src/providers/client_provider/client_cases_provider/client_case_provider.dart';
import 'package:lawyer_app/src/widgets/common_widgets/custom_appbar.dart';
import 'package:lawyer_app/src/widgets/common_widgets/custom_client_drawer.dart';
import 'package:lawyer_app/src/widgets/home_widgets/tabs/cases_tab_button.dart';
import 'package:lawyer_app/src/widgets/home_widgets/tabs/dispose_case_tab.dart';
import 'package:lawyer_app/src/widgets/home_widgets/tabs/donation_tab.dart';
import 'package:lawyer_app/src/widgets/home_widgets/tabs/new_case_tab.dart';
import 'package:lawyer_app/src/widgets/home_widgets/tabs/pending_case.dart';
import 'package:sizer/sizer.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int selectedTab = 0;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(caseControllerProvider.notifier).getAllCases();
    });
  }

  void _onTabChanged(int index) {
    setState(() {
      selectedTab = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final caseState = ref.watch(caseControllerProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: CustomAppbar(isDrawwer: true, logoImage: AppAssets.logoImage),
      drawer: const CustomClientDrawer(),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 3.h),

            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 1.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CasesTabButton(
                    title: "Pending",
                    index: 0,
                    selectedTab: selectedTab,
                    onTap: _onTabChanged,
                  ),
                  SizedBox(width: 3.w),
                  CasesTabButton(
                    title: "New Case",
                    index: 1,
                    selectedTab: selectedTab,
                    onTap: _onTabChanged,
                  ),
                  SizedBox(width: 3.w),
                  CasesTabButton(
                    title: "Disposed",
                    index: 2,
                    selectedTab: selectedTab,
                    onTap: _onTabChanged,
                  ),
                  SizedBox(width: 3.w),
                  CasesTabButton(
                    title: "Donations",
                    index: 3,
                    selectedTab: selectedTab,
                    onTap: _onTabChanged,
                  ),
                ],
              ),
            ),

            SizedBox(height: 4.h),

            Expanded(
              child: caseState.when(
                initial: () => const Center(child: SizedBox()),
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
                      Text(
                        "Failed to load cases",
                        style: TextStyle(
                          fontSize: 20.sp,
                          color: AppColors.whiteColor,
                        ),
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        error,
                        style: TextStyle(
                          color: Colors.redAccent,
                          fontSize: 14.sp,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 4.h),
                      ElevatedButton(
                        onPressed: () => ref
                            .read(caseControllerProvider.notifier)
                            .getAllCases(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.brightYellowColor,
                        ),
                        child: const Text(
                          "Retry",
                          style: TextStyle(color: AppColors.blackColor),
                        ),
                      ),
                    ],
                  ),
                ),
                success: (data) => AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (child, animation) =>
                      FadeTransition(opacity: animation, child: child),
                  child: _buildTabContent(selectedTab, data),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabContent(int tabIndex, AllCasesResponse data) {
    switch (tabIndex) {
      case 0:
        return PendingCasesTab(
          cases: data.pendingCases,
          key: const ValueKey(0),
        );
      case 1:
        return const NewCaseTab(key: ValueKey(1));
      case 2:
        return DisposedCasesTab(
          cases: data.disposedCases,
          key: const ValueKey(2),
        );
      case 3:
        return const DonationsTab(key: ValueKey(3));
      default:
        return PendingCasesTab(
          cases: data.pendingCases,
          key: const ValueKey(0),
        );
    }
  }
}
