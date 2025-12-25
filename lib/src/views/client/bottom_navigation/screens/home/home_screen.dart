import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lawyer_app/src/core/constants/app_assets.dart';
import 'package:lawyer_app/src/core/constants/app_colors.dart';
import 'package:lawyer_app/src/widgets/common_widgets/custom_appbar.dart';
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: CustomAppbar(isDrawwer: true, logoImage: AppAssets.logoImage),
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

            // Smooth Animated Content Switch
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (child, animation) =>
                    FadeTransition(opacity: animation, child: child),
                child: _buildTabContent(selectedTab),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onTabChanged(int index) {
    setState(() {
      selectedTab = index;
    });
  }

  Widget _buildTabContent(int tabIndex) {
    switch (tabIndex) {
      case 0:
        return PendingCasesTab(key: ValueKey(0));
      case 1:
        return const NewCaseTab(key: ValueKey(1));
      case 2:
        return const DisposedCasesTab(key: ValueKey(2));
      case 3:
        return const DonationsTab(key: ValueKey(3));
      default:
        return PendingCasesTab(key: ValueKey(0));
    }
  }
}
