import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lawyer_app/core/constants/app_colors.dart';
import 'package:lawyer_app/shared/widgets/custom_text.dart';
import 'package:sizer/sizer.dart';


class ChatDetailScreen extends ConsumerStatefulWidget {
  final String chatId;
  const ChatDetailScreen({super.key, required this.chatId});

  @override
  ConsumerState<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends ConsumerState<ChatDetailScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kBgDark,
      appBar: _buildAppBar(context),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              reverse: true, // Latest messages at the bottom
              itemCount: 10, // Mock count
              itemBuilder: (context, index) {
                final isMe = index % 2 == 0;
                return _buildChatBubble(
                  isMe: isMe,
                  message: isMe 
                      ? "This is a sent message from me." 
                      : "This is a received message from the other person.",
                  time: "10:30 AM",
                );
              },
            ),
          ),
          _buildInputArea(),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.kSurface.withOpacity(0.5),
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.kTextPrimary),
        onPressed: () => context.pop(),
      ),
      title: Row(
        children: [
          CircleAvatar(
            radius: 2.h,
            backgroundImage: const NetworkImage('https://i.pravatar.cc/150?u=u1'),
          ),
          SizedBox(width: 3.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                title: "Zayahan Hasan",
                fontSize: 16.sp,
                weight: FontWeight.w700,
                color: AppColors.kTextPrimary,
              ),
              CustomText(
                title: "Online",
                fontSize: 12.sp,
                color: Colors.greenAccent,
              ),
            ],
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.videocam_rounded, color: AppColors.kEmerald),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.call_rounded, color: AppColors.kEmerald),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildChatBubble({required bool isMe, required String message, required String time}) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(bottom: 2.h, left: isMe ? 20.w : 0, right: isMe ? 0 : 20.w),
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
        decoration: BoxDecoration(
          color: isMe ? AppColors.kEmerald : AppColors.kSurface,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20),
            topRight: const Radius.circular(20),
            bottomLeft: Radius.circular(isMe ? 20 : 0),
            bottomRight: Radius.circular(isMe ? 0 : 20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            CustomText(
              title: message,
              fontSize: 14.sp,
              color: isMe ? Colors.white : AppColors.kTextPrimary,
            ),
            SizedBox(height: 0.5.h),
            CustomText(
              title: time,
              fontSize: 10.sp,
              color: isMe ? Colors.white70 : AppColors.kTextSecondary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
      decoration: BoxDecoration(
        color: AppColors.kSurface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.add_circle_outline_rounded, color: AppColors.kEmerald, size: 30),
              onPressed: _showAttachmentOptions,
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                decoration: BoxDecoration(
                  color: AppColors.kBgDark.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: AppColors.kEmerald.withOpacity(0.3)),
                ),
                child: TextField(
                  controller: _messageController,
                  style: const TextStyle(color: AppColors.kTextPrimary),
                  decoration: const InputDecoration(
                    hintText: "Type a message...",
                    hintStyle: TextStyle(color: AppColors.kTextSecondary),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            SizedBox(width: 2.w),
            GestureDetector(
              onTap: () {
                if (_messageController.text.isNotEmpty) {
                  _messageController.clear();
                }
              },
              child: CircleAvatar(
                radius: 2.5.h,
                backgroundColor: AppColors.kEmerald,
                child: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAttachmentOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.all(5.w),
        decoration: BoxDecoration(
          color: AppColors.kSurface,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomText(
              title: "Sent Attachments",
              fontSize: 18.sp,
              weight: FontWeight.w700,
              color: AppColors.kTextPrimary,
            ),
            SizedBox(height: 3.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildAttachmentItem(Icons.image_rounded, "Gallery", Colors.purple),
                _buildAttachmentItem(Icons.camera_alt_rounded, "Camera", Colors.red),
                _buildAttachmentItem(Icons.insert_drive_file_rounded, "Document", Colors.blue),
                _buildAttachmentItem(Icons.person_rounded, "Contact", Colors.orange),
              ],
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  Widget _buildAttachmentItem(IconData icon, String label, Color color) {
    return Column(
      children: [
        CircleAvatar(
          radius: 3.5.h,
          backgroundColor: color.withOpacity(0.15),
          child: Icon(icon, color: color, size: 3.h),
        ),
        SizedBox(height: 1.h),
        CustomText(
          title: label,
          fontSize: 12.sp,
          color: AppColors.kTextSecondary,
        ),
      ],
    );
  }
}
