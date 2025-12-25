// search_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lawyer_app/src/core/constants/app_colors.dart';
import 'package:lawyer_app/src/providers/home_screen_provider/search_provider.dart';
import 'package:lawyer_app/src/providers/lawyer_provider/lawyer_provider.dart';
import 'package:lawyer_app/src/routing/route_names.dart';
import 'package:lawyer_app/src/states/lawyer_states/lawyer_state.dart';
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
    // Load first page
    Future.microtask(() => ref.read(lawyerProvider.notifier).loadLawyers());

    // Infinite scroll
    _scrollController.addListener(() {
      final maxScroll = _scrollController.position.maxScrollExtent;
      final currentScroll = _scrollController.position.pixels;
      final threshold = maxScroll * 0.9; // 90% down

      if (currentScroll >= threshold) {
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
      backgroundColor: AppColors.backgroundColor,
      appBar: const CustomAppbar(title: "Find Lawyers"),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 3.h),
            SearchWidget(
              hintText: 'Search Lawyer',
              useSearchProvider: true,
              onChanged: (q) =>
                  ref.read(searchQueryProvider.notifier).state = q,
            ),
            SizedBox(height: 3.h),
            Expanded(
              child: RefreshIndicator(
                onRefresh: _onRefresh,
                color: AppColors.iconColor,
                backgroundColor: Colors.white,
                child: _buildBody(state, searchQuery),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(LawyerState state, String query) {
    if (state is LawyerLoading && (state is! LawyerLoaded)) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is LawyerError) {
      return Center(
        child: CustomText(
          title: state.message,
          color: Colors.white,
          fontSize: 18.sp,
        ),
      );
    }

    if (state is LawyerLoaded) {
      final filtered = state.lawyers.where((lawyer) {
        final fullName = '${lawyer.firstName} ${lawyer.lastName}'.toLowerCase();
        return fullName.contains(query);
      }).toList();

      if (filtered.isEmpty) {
        return Center(
          child: CustomText(
            title: query.isEmpty
                ? 'No lawyers available.'
                : 'No lawyers match your search.',
            color: Colors.white,
            fontSize: 18.sp,
          ),
        );
      }

      return ListView.builder(
        controller: _scrollController,
        physics:
            const AlwaysScrollableScrollPhysics(), // Important for RefreshIndicator
        padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
        itemCount: filtered.length + (state.hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          // Loading indicator at bottom
          if (index == filtered.length) {
            return const Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
            );
          }

          final lawyer = filtered[index];
          return LawyerCard(
            profileImage: lawyer.profilePhoto,
            firstName: lawyer.firstName,
            lastName: lawyer.lastName,
            ratings: lawyer.rating,
            onTap: () {
              context.push(RouteNames.lawyerScreen, extra: lawyer);
            },
          );
        },
      );
    }

    return const SizedBox.shrink();
  }
}
