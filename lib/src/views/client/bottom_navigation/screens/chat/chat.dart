// src/views/chat/chat_detail_screen.dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lawyer_app/src/controllers/chat_controller/chat_controller.dart';
import 'package:lawyer_app/src/core/constants/app_colors.dart';
import 'package:lawyer_app/src/models/lawyer_model/lawyer_model.dart';
import 'package:lawyer_app/src/widgets/common_widgets/custom_text.dart';
import 'package:sizer/sizer.dart';

class ChatDetailScreen extends ConsumerWidget {
  const ChatDetailScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lawyer = ref.watch(selectedLawyerProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.inputBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: Colors.grey.shade800,
              child: ClipOval(
                child: CachedNetworkImage(
                  imageUrl: lawyer?.profilePhoto ?? '',
                  fit: BoxFit.cover,
                  width: 40,
                  height: 40,
                  placeholder: (_, __) => const CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.iconColor,
                  ),
                  errorWidget: (_, __, ___) =>
                      const Icon(Icons.person, color: Colors.white70, size: 24),
                ),
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    title: '${lawyer?.firstName} ${lawyer?.lastName}',
                    color: Colors.white,
                    fontSize: 16.sp,
                    weight: FontWeight.w600,
                  ),
                  CustomText(
                    title: 'Online',
                    color: AppColors.iconColor,
                    fontSize: 12.sp,
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.call, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),

      // ------------------- Chat Body -------------------
      body: Column(
        children: [
          // Messages List
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              children: [
                _buildDateHeader('Today'),

                // Received message
                _buildReceivedMessage(
                  'Hi! I saw your profile and I need help with a family law case.',
                  '10:30 AM',
                ),

                // Sent message
                _buildSentMessage(
                  'Hello! Sure, I can help. Could you tell me more about the case?',
                  '10:32 AM',
                ),

                // Received message
                _buildReceivedMessage(
                  'Yes, it’s about child custody after divorce.',
                  '10:33 AM',
                ),

                // Sent message
                _buildSentMessage(
                  'Got it. I specialize in family law. Let’s schedule a call.',
                  '10:35 AM',
                ),
              ],
            ),
          ),

          // ------------------- Input Area -------------------
          _buildInputArea(),
        ],
      ),
    );
  }

  // -------------------------------------------------
  // Helper: Date header
  // -------------------------------------------------
  Widget _buildDateHeader(String date) {
    return Center(
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 2.h),
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.inputBackgroundColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: CustomText(
          title: date,
          color: AppColors.hintTextColor,
          fontSize: 12.sp,
        ),
      ),
    );
  }

  // -------------------------------------------------
  // Helper: Received message (left side)
  // -------------------------------------------------
  Widget _buildReceivedMessage(String text, String time) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(bottom: 1.5.h),
        padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: const BoxDecoration(
          color: AppColors.inputBackgroundColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
            bottomRight: Radius.circular(16),
          ),
        ),
        constraints: BoxConstraints(maxWidth: 75.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(title: text, color: Colors.white, fontSize: 15.sp),
            SizedBox(height: 0.3.h),
            CustomText(
              title: time,
              color: AppColors.hintTextColor,
              fontSize: 10.sp,
            ),
          ],
        ),
      ),
    );
  }

  // -------------------------------------------------
  // Helper: Sent message (right side)
  // -------------------------------------------------
  Widget _buildSentMessage(String text, String time) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: EdgeInsets.only(bottom: 1.5.h),
        padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          gradient: AppColors.buttonGradientColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
            bottomLeft: Radius.circular(16),
          ),
        ),
        constraints: BoxConstraints(maxWidth: 75.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            CustomText(
              title: text,
              color: AppColors.blackColor,
              fontSize: 15.sp,
            ),
            SizedBox(height: 0.3.h),
            CustomText(
              title: time,
              color: AppColors.blackColor.withOpacity(0.7),
              fontSize: 10.sp,
            ),
          ],
        ),
      ),
    );
  }

  // -------------------------------------------------
  // Helper: Message input area
  // -------------------------------------------------
  Widget _buildInputArea() {
    final controller = TextEditingController();
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
      color: AppColors.inputBackgroundColor,
      child: Row(
        children: [
          // Attach button
          IconButton(
            icon: const Icon(Icons.attach_file, color: AppColors.iconColor),
            onPressed: () {},
          ),

          // Text field
          Expanded(
            child: TextField(
              controller: controller,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Type a message...',
                hintStyle: TextStyle(
                  color: AppColors.hintTextColor,
                  fontSize: 15.sp,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: AppColors.backgroundColor,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 5.w,
                  vertical: 1.h,
                ),
              ),
            ),
          ),

          SizedBox(width: 2.w),

          // Send button
          GestureDetector(
            onTap: () {
              if (controller.text.trim().isNotEmpty) {
                // TODO: send message
                controller.clear();
              }
            },
            child: Container(
              padding: EdgeInsets.all(12),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: AppColors.buttonGradientColor,
              ),
              child: const Icon(
                Icons.send,
                color: AppColors.blackColor,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
