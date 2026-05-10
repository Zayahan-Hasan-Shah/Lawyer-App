import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lawyer_app/core/constants/app_colors.dart';
import 'package:lawyer_app/shared/widgets/custom_text.dart';
import 'package:sizer/sizer.dart';

class VideoCallScreen extends StatelessWidget {
  const VideoCallScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Background - Other person's video (Mock)
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: NetworkImage('https://i.pravatar.cc/600?u=u1'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          
          // My video (Small overlay)
          Positioned(
            top: 6.h,
            right: 4.w,
            child: Container(
              width: 30.w,
              height: 20.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.kGold, width: 2),
                image: const DecorationImage(
                  image: NetworkImage('https://i.pravatar.cc/150?u=me'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          // Top Controls
          Positioned(
            top: 6.h,
            left: 4.w,
            child: CircleAvatar(
              backgroundColor: Colors.black45,
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
                onPressed: () => context.pop(),
              ),
            ),
          ),

          // Bottom Controls
          Positioned(
            bottom: 6.h,
            left: 0,
            right: 0,
            child: Column(
              children: [
                CustomText(
                  title: "Zayahan Hasan",
                  fontSize: 18.sp,
                  weight: FontWeight.bold,
                  color: Colors.white,
                ),
                CustomText(
                  title: "12:45",
                  fontSize: 14.sp,
                  color: Colors.white70,
                ),
                SizedBox(height: 4.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildCallAction(Icons.mic_off_rounded, Colors.white24, () {}),
                    _buildCallAction(Icons.call_end_rounded, Colors.redAccent, () => context.pop()),
                    _buildCallAction(Icons.videocam_off_rounded, Colors.white24, () {}),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCallAction(IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 30),
      ),
    );
  }
}
