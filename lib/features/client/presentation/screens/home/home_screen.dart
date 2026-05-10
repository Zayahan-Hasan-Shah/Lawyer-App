import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lawyer_app/app/router/route_names.dart';
import 'package:lawyer_app/core/constants/app_assets.dart';
import 'package:lawyer_app/core/constants/app_colors.dart';
import 'package:lawyer_app/features/client/data/models/case_model/case_model.dart';
import 'package:lawyer_app/features/client/presentation/providers/client_cases_provider/client_case_provider.dart';
import 'package:lawyer_app/shared/widgets/custom_appbar.dart';
import 'package:lawyer_app/shared/widgets/custom_button.dart';
import 'package:lawyer_app/shared/widgets/custom_text.dart';
import 'package:lawyer_app/features/client/presentation/widgets/tabs/cases_tab_button.dart';
import 'package:lawyer_app/features/client/presentation/widgets/tabs/dispose_case_tab.dart';
import 'package:lawyer_app/features/client/presentation/widgets/tabs/donation_tab.dart';
import 'package:lawyer_app/features/client/presentation/widgets/tabs/new_case_tab.dart';
import 'package:lawyer_app/features/client/presentation/widgets/tabs/pending_case.dart';
import 'package:sizer/sizer.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int selectedTab = 0;
  String searchQuery = "";
  String? categoryFilter;
  DateTimeRange? dateRange;

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
    return Container(
      color: AppColors.kBgDark,
      child: SafeArea(
        top: false,
        bottom: false,
        child: Column(
          children: [
            CustomAppbar(logoImage: AppAssets.logoImage, isDrawer: true),
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

            SizedBox(height: 2.h),

            _buildQuickActions(context),

            SizedBox(height: 3.h),

            // Search and Filter Row
            if (selectedTab == 0) _buildFilterSection(),

            SizedBox(height: 1.h),

            Expanded(
              child: caseState.when(
                initial: () => const Center(child: SizedBox()),
                loading: () => const Center(
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
                        Icons.error_outline,
                        size: 10.h,
                        color: Colors.redAccent,
                      ),
                      SizedBox(height: 2.h),
                      CustomText(
                        title: "Failed to load cases",
                        fontSize: 20.sp,
                        color: AppColors.whiteColor,
                      ),
                      SizedBox(height: 1.h),
                      CustomText(
                        title: error,
                        color: Colors.redAccent,
                        fontSize: 14.sp,
                        alignText: TextAlign.center,
                      ),
                      SizedBox(height: 4.h),
                      CustomButton(
                        text: "Retry",
                        onPressed: () => ref
                            .read(caseControllerProvider.notifier)
                            .getAllCases(),
                        fontSize: 18.sp,
                        textColor: Colors.white,
                        backgroundColor: AppColors.kEmerald,
                      ),
                    ],
                  ),
                ),
                success: (data) {
                  // Filter logic for pending cases
                  final filteredPending = data.pendingCases.where((c) {
                    final matchesSearch = c.title
                            .toLowerCase()
                            .contains(searchQuery.toLowerCase()) ||
                        c.caseNo.toLowerCase().contains(searchQuery.toLowerCase());
                    final matchesCategory = categoryFilter == null ||
                        c.category.toLowerCase() == categoryFilter!.toLowerCase();
                    return matchesSearch && matchesCategory;
                  }).toList();

                  return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder: (child, animation) =>
                        FadeTransition(opacity: animation, child: child),
                    child: _buildTabContent(selectedTab, data, filteredPending),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabContent(int tabIndex, AllCasesResponse data, List<CaseModel> filteredPending) {
    switch (tabIndex) {
      case 0:
        return PendingCasesTab(
          cases: filteredPending,
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

  Widget _buildQuickActions(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildQuickActionItem(Icons.description_outlined, "Documents", () {}),
          _buildQuickActionItem(Icons.account_balance_rounded, "Court Info", () => context.push(RouteNames.courtInfoScreen)),
          _buildQuickActionItem(Icons.help_center_outlined, "Support", () => context.push(RouteNames.supportFormScreen)),
        ],
      ),
    );
  }

  Widget _buildFilterSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 6.h,
                  decoration: BoxDecoration(
                    color: AppColors.kSurface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.kGold.withOpacity(0.2)),
                  ),
                  child: TextField(
                    onChanged: (v) => setState(() => searchQuery = v),
                    onSubmitted: (v) => FocusScope.of(context).unfocus(),
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Search case ID or title...",
                      hintStyle: TextStyle(color: Colors.white54, fontSize: 13.sp),
                      prefixIcon: const Icon(Icons.search_rounded, color: AppColors.kGold),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 3.w),
              _buildFilterIcon(Icons.filter_list_rounded, () => _showFilterOptions()),
              SizedBox(width: 3.w),
              _buildFilterIcon(Icons.date_range_rounded, () => _showDatePicker()),
            ],
          ),
          if (categoryFilter != null || dateRange != null)
            Padding(
              padding: EdgeInsets.only(top: 1.h),
              child: Row(
                children: [
                  if (categoryFilter != null)
                    _buildActiveFilterChip(categoryFilter!, () => setState(() => categoryFilter = null)),
                  if (dateRange != null)
                    _buildActiveFilterChip("Date Range", () => setState(() => dateRange = null)),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFilterIcon(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 6.h,
        width: 6.h,
        decoration: BoxDecoration(
          color: AppColors.kSurface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.kGold.withOpacity(0.2)),
        ),
        child: Icon(icon, color: AppColors.kGold),
      ),
    );
  }

  Widget _buildActiveFilterChip(String label, VoidCallback onDelete) {
    return Container(
      margin: EdgeInsets.only(right: 2.w),
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.5.h),
      decoration: BoxDecoration(
        color: AppColors.kGold.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.kGold.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          CustomText(title: label, fontSize: 11.sp, color: AppColors.kGold, weight: FontWeight.w600),
          SizedBox(width: 1.w),
          GestureDetector(
            onTap: onDelete,
            child: const Icon(Icons.close_rounded, size: 14, color: AppColors.kGold),
          ),
        ],
      ),
    );
  }

  void _showFilterOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.kSurface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: const Text("All Categories", style: TextStyle(color: Colors.white)),
            onTap: () { setState(() => categoryFilter = null); Navigator.pop(context); },
          ),
          ListTile(
            title: const Text("Criminal", style: TextStyle(color: Colors.white)),
            onTap: () { setState(() => categoryFilter = "Criminal"); Navigator.pop(context); },
          ),
          ListTile(
            title: const Text("Civil", style: TextStyle(color: Colors.white)),
            onTap: () { setState(() => categoryFilter = "Civil"); Navigator.pop(context); },
          ),
        ],
      ),
    );
  }

  void _showDatePicker() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.dark(primary: AppColors.kGold, onPrimary: Colors.black, surface: AppColors.kSurface),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() => dateRange = picked);
    }
  }

  Widget _buildQuickActionItem(
    IconData icon,
    String label,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(3.5.w),
            decoration: BoxDecoration(
              color: AppColors.kSurface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.kGold.withOpacity(0.15)),
            ),
            child: Icon(icon, color: AppColors.kGold, size: 4.h),
          ),
          SizedBox(height: 1.h),
          CustomText(
            title: label,
            fontSize: 14.sp,
            color: AppColors.kTextSecondary,
            weight: FontWeight.w600,
          ),
        ],
      ),
    );
  }
}
