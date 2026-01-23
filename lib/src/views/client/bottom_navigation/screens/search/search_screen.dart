import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lawyer_app/src/core/constants/app_colors.dart';
import 'package:lawyer_app/src/models/lawyer_model/lawyer_model.dart';
import 'package:lawyer_app/src/providers/client_provider/home_screen_provider/search_provider.dart';
import 'package:lawyer_app/src/providers/client_provider/lawyer_provider/lawyer_provider.dart';
import 'package:lawyer_app/src/routing/route_names.dart';
import 'package:lawyer_app/src/states/client_states/lawyer_states/lawyer_state.dart';
import 'package:lawyer_app/src/widgets/common_widgets/custom_appbar.dart';
import 'package:lawyer_app/src/widgets/common_widgets/custom_text.dart';
import 'package:lawyer_app/src/widgets/home_widgets/search_widget.dart';
import 'package:lawyer_app/src/widgets/search_screen_widget/lawyer_card.dart';
import 'package:sizer/sizer.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Load initial page
    Future.microtask(() => ref.read(lawyerProvider.notifier).loadLawyers());

    // Infinite scroll detection
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent * 0.85) {
        ref.read(lawyerProvider.notifier).loadMore();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    await ref.read(lawyerProvider.notifier).refresh();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(lawyerProvider);
    final searchQuery = ref.watch(searchQueryProvider).toLowerCase();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CustomAppbar(
        title: "Find Lawyers",
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0D1117), Color(0xFF0A1F24), Color(0xFF08151A)],
            stops: [0.0, 0.6, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(height: 2.h),

              // Glassmorphic search bar
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 6.w),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.kSurface.withOpacity(0.88),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppColors.kEmerald.withOpacity(0.18),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.25),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: SearchWidget(
                      hintText: 'Search lawyers by name or expertise...',
                      useSearchProvider: true,
                      prefixIcon: Icons.search_rounded,
                      textColor: AppColors.kTextPrimary,
                      hintTextColor: AppColors.kTextSecondary,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 3.h),

              // Main content area
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _onRefresh,
                  color: AppColors.kEmerald,
                  backgroundColor: AppColors.kSurface.withOpacity(0.92),
                  child: _buildBody(state, searchQuery),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody(LawyerState state, String query) {
    if (state is LawyerLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: AppColors.kEmerald,
              strokeWidth: 4,
            ),
            SizedBox(height: 2.5.h),
            CustomText(
              title: "Loading lawyers...",
              fontSize: 16.sp,
              color: AppColors.kTextSecondary,
            ),
          ],
        ),
      );
    }

    if (state is LawyerError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 80,
              color: Colors.redAccent,
            ),
            SizedBox(height: 3.h),
            CustomText(
              title: "Failed to load lawyers",
              fontSize: 20.sp,
              weight: FontWeight.w600,
              color: AppColors.kTextPrimary,
            ),
            SizedBox(height: 1.2.h),
            CustomText(
              title: state.message,
              fontSize: 15.sp,
              color: Colors.redAccent,
              alignText: TextAlign.center,
            ),
          ],
        ),
      );
    }

    final lawyers = state is LawyerLoaded ? state.lawyers : <LawyerModel>[];

    final filtered = lawyers.where((lawyer) {
      final fullName = '${lawyer.firstName} ${lawyer.lastName}'.toLowerCase();
      return fullName.contains(query);
    }).toList();

    if (filtered.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off_rounded,
              size: 90,
              color: AppColors.kTextSecondary.withOpacity(0.6),
            ),
            SizedBox(height: 3.5.h),
            CustomText(
              title: query.isEmpty
                  ? "No lawyers available yet"
                  : "No matching lawyers",
              fontSize: 22.sp,
              weight: FontWeight.w700,
              color: AppColors.kTextPrimary,
            ),
            SizedBox(height: 1.5.h),
            CustomText(
              title: query.isEmpty
                  ? "Check back later or adjust filters"
                  : "Try different keywords or clear search",
              fontSize: 15.sp,
              color: AppColors.kTextSecondary,
              alignText: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
      itemCount:
          filtered.length + (state is LawyerLoaded && state.hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        // Bottom loading indicator when fetching more
        if (index == filtered.length) {
          return Padding(
            padding: EdgeInsets.all(5.h),
            child: Center(
              child: CircularProgressIndicator(
                color: AppColors.kEmerald,
                strokeWidth: 3,
              ),
            ),
          );
        }

        final lawyer = filtered[index];
        return Padding(
          padding: EdgeInsets.only(bottom: 2.h),
          child: LawyerCard(
            profileImage: lawyer.profilePhoto,
            firstName: lawyer.firstName,
            lastName: lawyer.lastName,
            ratings: lawyer.rating,
            onTap: () {
              context.push(RouteNames.lawyerScreen, extra: lawyer);
            },
          ),
        );
      },
    );
  }
}
