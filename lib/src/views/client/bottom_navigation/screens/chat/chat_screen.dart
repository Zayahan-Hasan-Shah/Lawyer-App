import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lawyer_app/src/core/constants/app_colors.dart';
import 'package:lawyer_app/src/providers/client_provider/home_screen_provider/search_provider.dart';
import 'package:lawyer_app/src/providers/client_provider/lawyer_provider/lawyer_provider.dart';
import 'package:lawyer_app/src/controllers/chat_controller/chat_controller.dart';
import 'package:lawyer_app/src/routing/route_names.dart';
import 'package:lawyer_app/src/states/client_states/lawyer_states/lawyer_state.dart';
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
    Future.microtask(() => ref.read(lawyerProvider.notifier).loadLawyers());
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(lawyerProvider);
    final searchQuery = ref.watch(searchQueryProvider).toLowerCase();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CustomAppbar(
        title: "Chat with Lawyers",
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0D1117), Color(0xFF08151A)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(height: 2.h),

              // Search bar with glass effect
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 6.w),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: SearchWidget(
                      hintText: 'Search lawyers by name...',
                      useSearchProvider: true,
                      onChanged: (q) =>
                          ref.read(searchQueryProvider.notifier).state = q,
                      prefixIcon: Icons.search_rounded,
                      textColor: AppColors.kTextPrimary,
                      hintTextColor: AppColors.kTextSecondary,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 3.h),

              // Lawyer list / states
              Expanded(child: _buildBody(state, searchQuery)),
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
            SizedBox(height: 2.h),
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
            SizedBox(height: 2.5.h),
            CustomText(
              title: "Failed to load lawyers",
              fontSize: 18.sp,
              weight: FontWeight.w600,
              color: AppColors.kTextPrimary,
            ),
            SizedBox(height: 1.h),
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

    if (state is LawyerLoaded) {
      final filtered = state.lawyers.where((lawyer) {
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
              SizedBox(height: 3.h),
              CustomText(
                title: "No lawyers found",
                fontSize: 20.sp,
                weight: FontWeight.w700,
                color: AppColors.kTextPrimary,
              ),
              SizedBox(height: 1.2.h),
              CustomText(
                title: "Try adjusting your search or check back later",
                fontSize: 15.sp,
                color: AppColors.kTextSecondary,
                alignText: TextAlign.center,
              ),
            ],
          ),
        );
      }

      return ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
        itemCount: filtered.length,
        itemBuilder: (context, index) {
          final lawyer = filtered[index];
          return Padding(
            padding: EdgeInsets.only(bottom: 2.h),
            child: LawyerCard(
              profileImage: lawyer.profilePhoto,
              firstName: lawyer.firstName,
              lastName: lawyer.lastName,
              ratings: lawyer.rating,
              onTap: () {
                ref.read(selectedLawyerProvider.notifier).setLawyer(lawyer);
                context.push(RouteNames.chatDetailScreen);
              },
            ),
          );
        },
      );
    }

    // Initial / unknown state
    return Center(
      child: CustomText(
        title: "Tap search to find lawyers",
        fontSize: 18.sp,
        color: AppColors.kTextSecondary,
      ),
    );
  }
}
