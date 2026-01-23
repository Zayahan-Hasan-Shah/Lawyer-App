import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lawyer_app/src/core/constants/app_colors.dart';
import 'package:lawyer_app/src/widgets/common_widgets/custom_text.dart';
import 'package:sizer/sizer.dart';

class LawyerCard extends StatelessWidget {
  final String? profileImage;
  final String? firstName;
  final String? lastName;
  final double? ratings;
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
  Widget build(BuildContext context) {
    // Safe name handling
    final displayName = [
      firstName?.trim() ?? '',
      lastName?.trim() ?? '',
    ].where((s) => s.isNotEmpty).join(' ');

    final safeName = displayName.isNotEmpty ? displayName : 'Lawyer';

    // Safe rating (0–5)
    final safeRating = (ratings ?? 0.0).clamp(0.0, 5.0);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOutCubic,
        margin: EdgeInsets.only(bottom: 2.h),
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: AppColors.kSurface.withOpacity(0.92),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppColors.kEmerald.withOpacity(0.18),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.35),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
            BoxShadow(
              color: AppColors.kEmerald.withOpacity(0.08),
              blurRadius: 30,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Row(
          children: [
            // Profile Image (with glassmorphic ring)
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.kEmerald.withOpacity(0.4),
                  width: 2.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.kEmerald.withOpacity(0.25),
                    blurRadius: 16,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: ClipOval(
                child: SizedBox(
                  width: 72,
                  height: 72,
                  child:
                      profileImage != null &&
                          profileImage!.trim().isNotEmpty &&
                          Uri.tryParse(profileImage!.trim())?.hasScheme == true
                      ? CachedNetworkImage(
                          imageUrl: profileImage!.trim(),
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            color: AppColors.kSurface,
                            child: Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color: AppColors.kEmerald.withOpacity(0.6),
                              ),
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            color: AppColors.kSurface,
                            child: const Icon(
                              Icons.person_rounded,
                              size: 40,
                              color: AppColors.kTextSecondary,
                            ),
                          ),
                        )
                      : Container(
                          color: AppColors.kSurface,
                          child: const Icon(
                            Icons.person_rounded,
                            size: 40,
                            color: AppColors.kTextSecondary,
                          ),
                        ),
                ),
              ),
            ),

            SizedBox(width: 5.w),

            // Name & rating
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    title: safeName,
                    fontSize: 18.sp,
                    weight: FontWeight.w700,
                    color: AppColors.kTextPrimary,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 0.6.h),
                  Row(
                    children: [
                      Icon(
                        Icons.star_rounded,
                        color: AppColors.kEmerald,
                        size: 20,
                      ),
                      SizedBox(width: 1.5.w),
                      CustomText(
                        title: safeRating.toStringAsFixed(1),
                        fontSize: 15.5.sp,
                        weight: FontWeight.w600,
                        color: AppColors.kEmerald,
                      ),
                      SizedBox(width: 1.w),
                      CustomText(
                        title: "• Available",
                        fontSize: 13.5.sp,
                        color: AppColors.kTextSecondary,
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
