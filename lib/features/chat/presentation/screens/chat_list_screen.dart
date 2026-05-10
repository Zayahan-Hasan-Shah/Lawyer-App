import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lawyer_app/core/constants/app_colors.dart';
import 'package:lawyer_app/features/chat/domain/models/chat_models.dart';
import 'package:lawyer_app/features/chat/presentation/providers/chat_availability_provider.dart';
import 'package:lawyer_app/shared/widgets/custom_text.dart';
import 'package:sizer/sizer.dart';
import 'package:intl/intl.dart';

class ChatListScreen extends ConsumerWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Mock data for conversations
    final List<Conversation> conversations = [
      Conversation(
        id: 1,
        otherUserId: 'u1',
        otherUserName: 'Zayahan Hasan',
        otherUserAvatar: 'https://i.pravatar.cc/150?u=u1',
        lastMessage: 'Hello, I have a question about my case.',
        lastMessageTimestamp: DateTime.now().subtract(const Duration(minutes: 5)),
        unreadCount: 2,
        isOnline: true,
      ),
      Conversation(
        id: 2,
        otherUserId: 'u2',
        otherUserName: 'Ahmad Khan',
        otherUserAvatar: 'https://i.pravatar.cc/150?u=u2',
        lastMessage: 'The documents are ready for review.',
        lastMessageTimestamp: DateTime.now().subtract(const Duration(hours: 1)),
        unreadCount: 0,
        isOnline: false,
      ),
      Conversation(
        id: 3,
        otherUserId: 'u3',
        otherUserName: 'Sara Ahmed',
        otherUserAvatar: 'https://i.pravatar.cc/150?u=u3',
        lastMessage: 'Thank you for your help!',
        lastMessageTimestamp: DateTime.now().subtract(const Duration(days: 1)),
        unreadCount: 0,
        isOnline: true,
      ),
    ];

    final availabilityAsync = ref.watch(chatAvailabilityProvider);

    return Scaffold(
      backgroundColor: AppColors.kBgDark,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: CustomText(
          title: "Messages",
          fontSize: 22.sp,
          weight: FontWeight.w800,
          color: AppColors.kTextPrimary,
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search_rounded, color: AppColors.kTextPrimary),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.more_vert_rounded, color: AppColors.kTextPrimary),
            onPressed: () {},
          ),
        ],
      ),
      body: availabilityAsync.when(
        data: (hasCases) {
          if (!hasCases) {
            return _buildEmptyState(context);
          }
          return Column(
            children: [
              // Online users/Stories (optional premium vibe)
              _buildOnlineUsers(conversations),
              
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.kSurface.withOpacity(0.3),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: ListView.builder(
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                    itemCount: conversations.length,
                    itemBuilder: (context, index) {
                      final conv = conversations[index];
                      return _buildConversationTile(context, conv);
                    },
                  ),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.kGold)),
        error: (err, stack) => Center(child: CustomText(title: "Error loading chat availability", color: Colors.redAccent)),
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 10.h),
        child: FloatingActionButton(
          onPressed: () {},
          backgroundColor: AppColors.kGold,
          elevation: 8,
          child: const Icon(Icons.chat_bubble_rounded, color: Colors.black),
        ),
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
            Icon(Icons.chat_bubble_outline_rounded, size: 80, color: AppColors.kGold.withOpacity(0.4)),
            SizedBox(height: 3.h),
            CustomText(
              title: "No Active Conversations",
              fontSize: 20.sp,
              weight: FontWeight.bold,
              color: AppColors.kTextPrimary,
              alignText: TextAlign.center,
            ),
            SizedBox(height: 1.5.h),
            CustomText(
              title: "Chat will appear here once a case is assigned or an appointment is confirmed.",
              fontSize: 14.sp,
              color: AppColors.kTextSecondary,
              alignText: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOnlineUsers(List<Conversation> conversations) {
    return Container(
      height: 12.h,
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        itemCount: conversations.length,
        itemBuilder: (context, index) {
          final conv = conversations[index];
          return Container(
            margin: EdgeInsets.only(right: 4.w),
            child: Column(
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 3.5.h,
                      backgroundImage: NetworkImage(conv.otherUserAvatar),
                    ),
                    if (conv.isOnline)
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          width: 3.w,
                          height: 3.w,
                          decoration: BoxDecoration(
                            color: Colors.greenAccent,
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.kBgDark, width: 2),
                          ),
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 0.5.h),
                SizedBox(
                  width: 15.w,
                  child: CustomText(
                    title: conv.otherUserName.split(' ')[0],
                    fontSize: 12.sp,
                    color: AppColors.kTextSecondary,
                    alignText: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildConversationTile(BuildContext context, Conversation conv) {
    return InkWell(
      onTap: () {
        // Navigate to detail
        context.push('/chat-detail/${conv.id}');
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.5.h),
        child: Row(
          children: [
            CircleAvatar(
              radius: 4.h,
              backgroundImage: NetworkImage(conv.otherUserAvatar),
            ),
            SizedBox(width: 4.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                        title: conv.otherUserName,
                        fontSize: 16.sp,
                        weight: FontWeight.w700,
                        color: AppColors.kTextPrimary,
                      ),
                      CustomText(
                        title: DateFormat('hh:mm a').format(conv.lastMessageTimestamp),
                        fontSize: 12.sp,
                        color: AppColors.kTextSecondary,
                      ),
                    ],
                  ),
                  SizedBox(height: 0.5.h),
                  Row(
                    children: [
                      Expanded(
                        child: CustomText(
                          title: conv.lastMessage,
                          fontSize: 14.sp,
                          color: conv.unreadCount > 0 
                              ? AppColors.kTextPrimary 
                              : AppColors.kTextSecondary,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          weight: conv.unreadCount > 0 ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                      if (conv.unreadCount > 0)
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: AppColors.kEmerald,
                            shape: BoxShape.circle,
                          ),
                          child: CustomText(
                            title: conv.unreadCount.toString(),
                            fontSize: 10.sp,
                            color: Colors.white,
                            weight: FontWeight.bold,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
