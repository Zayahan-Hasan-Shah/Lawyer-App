import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lawyer_app/src/core/constants/app_colors.dart';
import 'package:lawyer_app/src/models/lawyer_model/lawyer_model.dart';
import 'package:lawyer_app/src/widgets/common_widgets/custom_appbar.dart';
import 'package:lawyer_app/src/widgets/common_widgets/custom_button.dart';
import 'package:lawyer_app/src/widgets/common_widgets/custom_text.dart';
import 'package:sizer/sizer.dart';

class LawyerProfileScreen extends StatelessWidget {
  final LawyerModel lawyer;

  const LawyerProfileScreen({super.key, required this.lawyer});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CustomAppbar(
        isBack: true,
        title: '${lawyer.firstName} ${lawyer.lastName}',
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0D1117), Color(0xFF0A1F24), Color(0xFF08151A)],
            stops: [0.0, 0.6, 1.0],
          ),
        ),
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              // Sliver App Bar with blurred background image
              // SliverAppBar(
              //   // expandedHeight: 40.h,
              //   floating: false,
              //   pinned: true,
              //   backgroundColor: Colors.transparent,
              //   elevation: 0,
              //   flexibleSpace: FlexibleSpaceBar(
              //     background: Stack(
              //       fit: StackFit.expand,
              //       children: [
              //         CachedNetworkImage(
              //           imageUrl: lawyer.profilePhoto,
              //           fit: BoxFit.cover,
              //           placeholder: (context, url) => Container(
              //             color: AppColors.kSurface,
              //             child: Center(
              //               child: CircularProgressIndicator(
              //                 color: AppColors.kEmerald,
              //                 strokeWidth: 3,
              //               ),
              //             ),
              //           ),
              //           errorWidget: (context, url, error) => Container(
              //             color: AppColors.kSurface,
              //             child: Icon(Icons.person_rounded, size: 80, color: AppColors.kTextSecondary),
              //           ),
              //         ),
              //         BackdropFilter(
              //           filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              //           child: Container(
              //             decoration: BoxDecoration(
              //               gradient: LinearGradient(
              //                 begin: Alignment.topCenter,
              //                 end: Alignment.bottomCenter,
              //                 colors: [
              //                   Colors.transparent,
              //                   AppColors.kBgDark.withOpacity(0.7),
              //                   AppColors.kBgDark.withOpacity(0.95),
              //                 ],
              //               ),
              //             ),
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),

              // Overlapping avatar + info
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
                  child: Column(
                    children: [
                      // Avatar overlapping the header
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.kEmerald,
                            width: 4,
                          ),
                        ),
                        child: ClipOval(
                          child: SizedBox(
                            width: 22.h,
                            height: 22.h,
                            child: CachedNetworkImage(
                              imageUrl: lawyer.profilePhoto,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(
                                color: AppColors.kSurface,
                                child: Center(
                                  child: CircularProgressIndicator(
                                    color: AppColors.kEmerald,
                                  ),
                                ),
                              ),
                              errorWidget: (context, url, error) => Container(
                                color: AppColors.kSurface,
                                child: Icon(
                                  Icons.person_rounded,
                                  size: 80,
                                  color: AppColors.kTextSecondary,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 2.h),

                      // Name & rating
                      CustomText(
                        title: '${lawyer.firstName} ${lawyer.lastName}',
                        fontSize: 26.sp,
                        weight: FontWeight.w800,
                        color: AppColors.kTextPrimary,
                        alignText: TextAlign.center,
                      ),
                      SizedBox(height: 0.5.h),
                      CustomText(
                        title: lawyer.email,
                        fontSize: 16.sp,
                        color: AppColors.kTextPrimary,
                        alignText: TextAlign.center,
                      ),
                      SizedBox(height: 0.5.h),
                      CustomText(
                        title: lawyer.phone,
                        fontSize: 16.sp,
                        color: AppColors.kTextPrimary,
                        alignText: TextAlign.center,
                      ),
                      SizedBox(height: 0.5.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.star_rounded,
                            color: AppColors.kEmerald,
                            size: 22,
                          ),
                          SizedBox(width: 1.5.w),
                          CustomText(
                            title: '${lawyer.rating.toStringAsFixed(1)}',
                            fontSize: 18.sp,
                            weight: FontWeight.w700,
                            color: AppColors.kEmerald,
                          ),
                          SizedBox(width: 1.w),
                          CustomText(
                            title: '(${lawyer.reviews} reviews)',
                            fontSize: 14.sp,
                            color: AppColors.kTextSecondary,
                          ),
                        ],
                      ),

                      SizedBox(height: 1.h),
                      CustomText(
                        title: lawyer.category,
                        fontSize: 16.sp,
                        color: AppColors.kEmerald,
                        weight: FontWeight.w600,
                      ),

                      SizedBox(height: 4.h),

                      // Biography & Description
                      _buildSection('Biography', lawyer.biography),
                      SizedBox(height: 3.h),
                      _buildSection('Description', lawyer.description),

                      SizedBox(height: 5.h),

                      // Book Now Button
                      SizedBox(
                        width: double.infinity,
                        height: 58,
                        child: CustomButton(
                          text: 'Book Consultation',
                          onPressed: () {
                            // TODO: Navigate to booking flow
                          },
                          gradient: LinearGradient(
                            colors: [
                              AppColors.kEmerald,
                              AppColors.kEmeraldDark,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          textColor: Colors.white,
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w700,
                          borderRadius: 16,
                        ),
                      ),

                      SizedBox(height: 6.h),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          title: title,
          fontSize: 19.sp,
          weight: FontWeight.w700,
          color: AppColors.kTextPrimary,
        ),
        SizedBox(height: 1.2.h),
        Container(
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: AppColors.kSurface.withOpacity(0.88),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.kEmerald.withOpacity(0.15)),
          ),
          child: CustomText(
            title: content,
            fontSize: 15.sp,
            color: AppColors.kTextSecondary,
            textHeight: 1.5,
          ),
        ),
      ],
    );
  }
}
