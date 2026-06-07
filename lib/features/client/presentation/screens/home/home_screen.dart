import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lawyer_app/app/router/route_names.dart';
import 'package:lawyer_app/core/constants/app_assets.dart';
import 'package:lawyer_app/core/constants/app_colors.dart';
import 'package:lawyer_app/features/client/domain/entities/case_entity.dart';
import 'package:lawyer_app/features/client/presentation/providers/client_cases_provider/client_case_provider.dart';
import 'package:lawyer_app/shared/widgets/custom_appbar.dart';
import 'package:lawyer_app/shared/widgets/custom_text.dart';
import 'package:lawyer_app/features/client/presentation/widgets/tabs/cases_tab_button.dart';
import 'package:lawyer_app/features/client/presentation/widgets/tabs/dispose_case_tab.dart';
import 'package:lawyer_app/features/client/presentation/widgets/tabs/donation_tab.dart';
import 'package:lawyer_app/features/client/presentation/widgets/tabs/new_case_tab.dart';
import 'package:lawyer_app/features/client/presentation/widgets/tabs/pending_case.dart';
import 'package:lawyer_app/core/utils/date_picker_helper.dart';
import 'package:lawyer_app/shared/widgets/failed_widget.dart';
import 'package:lawyer_app/shared/widgets/custom_search_filter_bar.dart';
import 'package:sizer/sizer.dart';
import '../../../../../shared/widgets/loading_indicator.dart';

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
            SizedBox(height: 1.25.h),

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

            SizedBox(height: 1.25.h),

            _buildQuickActions(context),

            SizedBox(height: 1.25.h),

            // Search and Filter Row
            if (selectedTab == 0) _buildFilterSection(),

            Expanded(
              child: RefreshIndicator(
                color: AppColors.kEmerald,
                backgroundColor: AppColors.kSurface,
                onRefresh: () async {
                  await ref.read(caseControllerProvider.notifier).getAllCases();
                },
                child: caseState.when(
                  initial: () => const Center(child: SizedBox()),
                  loading: () => LoadingIndicator(
                    color: AppColors.kEmerald,
                    text: "Loading cases...",
                    textColor: AppColors.kTextSecondary,
                  ),
                  failure: (error) => FailedWidget(
                    text: error,
                    icon: Icons.error_outline,
                    title: "Failed to load cases",
                  ),
                  success: (data) {
                    // Filter logic for pending cases
                    final filteredPending = data.pendingCases.where((c) {
                      final matchesSearch =
                          c.title.toLowerCase().contains(
                            searchQuery.toLowerCase(),
                          ) ||
                          c.caseNo.toLowerCase().contains(
                            searchQuery.toLowerCase(),
                          );
                      final matchesCategory =
                          categoryFilter == null ||
                          c.category.toLowerCase() ==
                              categoryFilter!.toLowerCase();
                      return matchesSearch && matchesCategory;
                    }).toList();

                    return AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      transitionBuilder: (child, animation) =>
                          FadeTransition(opacity: animation, child: child),
                      child: _buildTabContent(
                        selectedTab,
                        data,
                        filteredPending,
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabContent(
    int tabIndex,
    AllCasesResponse data,
    List<CaseEntity> filteredPending,
  ) {
    switch (tabIndex) {
      case 0:
        return PendingCasesTab(cases: filteredPending, key: const ValueKey(0));
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
          _buildQuickActionItem(
            Icons.account_balance_rounded,
            "Court Info",
            () => context.push(RouteNames.courtInfoScreen),
          ),
          _buildQuickActionItem(
            Icons.help_center_outlined,
            "Support",
            () => context.push(RouteNames.supportFormScreen),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection() {
    final Map<String, VoidCallback> activeFilters = {};
    if (categoryFilter != null) {
      activeFilters[categoryFilter!] = () =>
          setState(() => categoryFilter = null);
    }
    if (dateRange != null) {
      activeFilters["Date Range"] = () => setState(() => dateRange = null);
    }

    return CustomSearchFilterBar(
      hintText: "Search case ID or title...",
      initialSearchQuery: searchQuery,
      onSearchChanged: (v) => setState(() => searchQuery = v),
      onFilterTap: () => _showFilterOptions(),
      onDateTap: () => _showDatePicker(),
      activeFilters: activeFilters,
      padding: EdgeInsets.symmetric(horizontal: 5.w),
    );
  }

  void _showFilterOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.kSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: const Text(
              "All Categories",
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              setState(() => categoryFilter = null);
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text(
              "Criminal",
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              setState(() => categoryFilter = "Criminal");
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text("Civil", style: TextStyle(color: Colors.white)),
            onTap: () {
              setState(() => categoryFilter = "Civil");
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  void _showDatePicker() async {
    final picked = await DatePickerHelper.showGenericDateRangePicker(
      context,
      initialDateRange: dateRange,
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
