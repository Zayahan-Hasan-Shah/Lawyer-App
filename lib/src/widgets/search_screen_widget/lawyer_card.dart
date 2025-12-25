import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lawyer_app/src/core/constants/app_colors.dart';
import 'package:lawyer_app/src/widgets/common_widgets/custom_text.dart';
import 'package:sizer/sizer.dart';

class LawyerCard extends ConsumerWidget {
  final String? profileImage; // nullable
  final String? firstName; // nullable
  final String? lastName; // nullable
  final double? ratings; // nullable
  final VoidCallback onTap;

  const LawyerCard({
    super.key,
    this.profileImage,
    this.firstName,
    this.lastName,
    this.ratings,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Safe defaults
    final String displayName = [
      firstName?.trim(),
      lastName?.trim(),
    ].where((s) => s != null && s.isNotEmpty).join(' ');

    final String safeName = displayName.isNotEmpty
        ? displayName
        : 'Unknown Lawyer';

    final double safeRating = (ratings ?? 0.0).clamp(0.0, 5.0);

    Widget imageWidget;

    if (profileImage == null ||
        profileImage!.trim().isEmpty ||
        !Uri.tryParse(profileImage!.trim())!.hasScheme) {
      imageWidget = Container(
        width: 60,
        height: 60,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey,
        ),
        child: const Icon(Icons.person, size: 32, color: Colors.white70),
      );
    } else {
      imageWidget = CachedNetworkImage(
        imageUrl: profileImage!.trim(),
        width: 60,
        height: 60,
        fit: BoxFit.cover,
        placeholder: (context, url) => const Center(
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: Colors.white54,
          ),
        ),
        errorWidget: (context, url, error) => Container(
          width: 60,
          height: 60,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.grey,
          ),
          child: const Icon(Icons.person, size: 32, color: Colors.white70),
        ),
      );
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white, width: 1.5),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(12),
        margin: EdgeInsets.only(bottom: 1.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                // Profile Image (safe)
                ClipOval(child: imageWidget),
                SizedBox(width: 2.w),
                // Name (safe)
                CustomText(
                  title: safeName,
                  color: Colors.white,
                  fontSize: 18.sp,
                ),
              ],
            ),
            // Rating (safe)
            Row(
              children: [
                CustomText(
                  title: safeRating.toStringAsFixed(1),
                  color: Colors.white,
                  fontSize: 18.sp,
                ),
                const SizedBox(width: 4),
                Icon(Icons.star, color: AppColors.iconColor, size: 20.sp),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
