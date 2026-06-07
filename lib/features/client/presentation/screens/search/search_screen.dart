import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lawyer_app/core/constants/app_colors.dart';
import 'package:lawyer_app/features/client/presentation/providers/home_screen_provider/search_provider.dart';
import 'package:lawyer_app/features/lawyer/domain/entities/lawyer_entity.dart';
import 'package:lawyer_app/features/lawyer/presentation/providers/lawyer_provider.dart';
import 'package:lawyer_app/app/router/route_names.dart';
import 'package:lawyer_app/features/lawyer/presentation/states/lawyer_state.dart';
import 'package:lawyer_app/shared/widgets/custom_appbar.dart';
import 'package:lawyer_app/shared/widgets/custom_text.dart';
import 'package:lawyer_app/shared/widgets/custom_search_filter_bar.dart';
import 'package:lawyer_app/features/client/presentation/widgets/lawyer_card.dart';
import 'package:lawyer_app/shared/widgets/failed_widget.dart';
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
        color: AppColors.kBgDark,
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(height: 2.h),

              CustomSearchFilterBar(
                hintText: 'Search lawyers by name or expertise...',
                initialSearchQuery: ref.read(searchQueryProvider),
                onSearchChanged: (v) =>
                    ref.read(searchQueryProvider.notifier).state = v,
                padding: EdgeInsets.symmetric(horizontal: 6.w),
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
      return FailedWidget(
        text: state.message,
        icon: Icons.error_outline,
        title: "Failed to load lawyers",
        onRetry: () => ref.read(lawyerProvider.notifier).refresh(),
      );
    }

    final lawyers = state is LawyerLoaded ? state.lawyers : <LawyerEntity>[];

    final filtered = lawyers.where((lawyer) {
      return lawyer.fullName.toLowerCase().contains(query);
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
