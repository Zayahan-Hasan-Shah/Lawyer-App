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

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  @override
  void initState() {
    super.initState();
    // Fire the request as soon as the widget is inserted
    Future.microtask(() => ref.read(lawyerProvider.notifier).loadLawyers());
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(lawyerProvider);
    final searchQuery = ref.watch(searchQueryProvider).toLowerCase();

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: const CustomAppbar(title: "Chat"),
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
            // ---- List of lawyers (filtered) ----
            Expanded(child: _buildBody(state, searchQuery)),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(LawyerState state, String query) {
    if (state is LawyerLoading) {
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
            title: 'No lawyers match your search.',
            color: Colors.white,
            fontSize: 18.sp,
          ),
        );
      }

      return ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
        itemCount: filtered.length,
        itemBuilder: (context, index) {
          final lawyer = filtered[index];
          return LawyerCard(
            profileImage: lawyer.profilePhoto,
            firstName: lawyer.firstName,
            lastName: lawyer.lastName,
            ratings: lawyer.rating,
            onTap: () {
              context.push(RouteNames.chatDetailScreen, extra: lawyer);
            },
          );
        },
      );
    }

    // LawyerInitial – show a placeholder or nothing
    return const SizedBox.shrink();
  }
}
