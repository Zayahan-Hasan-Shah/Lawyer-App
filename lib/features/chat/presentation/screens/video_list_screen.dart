import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lawyer_app/core/constants/app_colors.dart';
import 'package:lawyer_app/features/chat/presentation/providers/chat_availability_provider.dart';
import 'package:lawyer_app/shared/widgets/custom_text.dart';
import 'package:sizer/sizer.dart';

class VideoListScreen extends ConsumerWidget {
  const VideoListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final availabilityAsync = ref.watch(chatAvailabilityProvider);

    return Scaffold(
      backgroundColor: AppColors.kBgDark,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: CustomText(
          title: "Video Consultations",
          fontSize: 22.sp,
          weight: FontWeight.w800,
          color: AppColors.kTextPrimary,
        ),
      ),
      body: availabilityAsync.when(
        data: (hasCases) {
          if (!hasCases) {
            return _buildEmptyState(context);
          }
          return _buildVideoList(context);
        },
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.kGold)),
        error: (err, stack) => Center(child: CustomText(title: "Error loading video availability", color: Colors.redAccent)),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(10.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.videocam_off_rounded, size: 80, color: AppColors.kGold.withOpacity(0.4)),
            SizedBox(height: 3.h),
            CustomText(
              title: "No Scheduled Calls",
              fontSize: 20.sp,
              weight: FontWeight.bold,
              color: AppColors.kTextPrimary,
              alignText: TextAlign.center,
            ),
            SizedBox(height: 1.5.h),
            CustomText(
              title: "Video calling will be enabled once you have an active case or a confirmed appointment.",
              fontSize: 14.sp,
              color: AppColors.kTextSecondary,
              alignText: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoList(BuildContext context) {
    // Mock video call list
    return ListView.builder(
      padding: EdgeInsets.all(5.w),
      itemCount: 2,
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.only(bottom: 2.h),
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: AppColors.kSurface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.kGold.withOpacity(0.2)),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 3.5.h,
                backgroundImage: const NetworkImage('https://i.pravatar.cc/150?u=u1'),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      title: "Zayahan Hasan",
                      fontSize: 16.sp,
                      weight: FontWeight.bold,
                      color: AppColors.kTextPrimary,
                    ),
                    CustomText(
                      title: "Scheduled: Today, 04:00 PM",
                      fontSize: 12.sp,
                      color: AppColors.kGold,
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.videocam_rounded, color: AppColors.kEmerald, size: 30),
                onPressed: () {
                  // Navigate to mock video call
                  context.push('/video-call');
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
