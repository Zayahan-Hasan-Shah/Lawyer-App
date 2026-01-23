import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lawyer_app/src/core/constants/app_assets.dart';
import 'package:lawyer_app/src/core/constants/app_colors.dart';
import 'package:lawyer_app/src/providers/lawyer_provider/profile_provider/lawyer_profile_provider.dart';
import 'package:lawyer_app/src/widgets/common_widgets/custom_appbar.dart';
import 'package:lawyer_app/src/widgets/common_widgets/custom_text.dart';
import 'package:lawyer_app/src/widgets/lawyer_widgets/profile_widget/contact_card.dart';
import 'package:lawyer_app/src/widgets/lawyer_widgets/profile_widget/profile_stat_card.dart';
import 'package:sizer/sizer.dart';

class LawyerProfileScreen extends ConsumerStatefulWidget {
  const LawyerProfileScreen({super.key});

  @override
  ConsumerState<LawyerProfileScreen> createState() =>
      _LawyerProfileScreenState();
}

class _LawyerProfileScreenState extends ConsumerState<LawyerProfileScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(lawyerProfileProvider.notifier).loadProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(lawyerProfileProvider);

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF0D1117), Color(0xFF0A1F24), Color(0xFF08151A)],
          stops: [0.0, 0.6, 1.0],
        ),
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomAppbar(
              logoImage: AppAssets.logoImage,
              backgroundColor: Colors.transparent,
            ),
            Expanded(
              child: profileState.when(
                initial: () => const SizedBox.shrink(),
                loading: () => const Center(
                  child: CircularProgressIndicator(color: AppColors.kEmerald),
                ),
                failure: (error) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline_rounded,
                        size: 80,
                        color: Colors.redAccent,
                      ),
                      SizedBox(height: 2.h),
                      CustomText(
                        title: 'Failed to load profile',
                        color: AppColors.kTextPrimary,
                        fontSize: 18.sp,
                      ),
                      SizedBox(height: 1.h),
                      CustomText(
                        title: error,
                        color: Colors.redAccent,
                        fontSize: 14.sp,
                        alignText: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                success: (data) => SingleChildScrollView(
                  padding:
                      EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Profile Header Card (Glassmorphic)
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(5.w),
                    decoration: BoxDecoration(
                      color: AppColors.kSurface.withOpacity(0.88),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: AppColors.kEmerald.withOpacity(0.18),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.35),
                          blurRadius: 24,
                          offset: const Offset(0, 12),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Avatar with emerald ring
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.kEmerald,
                              width: 3,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.kEmerald.withOpacity(0.35),
                                blurRadius: 20,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: CircleAvatar(
                            radius: 10.h,
                            backgroundColor: AppColors.kSurface,
                            backgroundImage: AssetImage(data.profileImage),
                          ),
                        ),
                        SizedBox(height: 2.5.h),

                        CustomText(
                          title: data.fullName,
                          color: AppColors.kTextPrimary,
                          fontSize: 22.sp,
                          weight: FontWeight.w800,
                          alignText: TextAlign.center,
                        ),
                        SizedBox(height: 0.6.h),
                        CustomText(
                          title: data.title,
                          color: AppColors.kTextSecondary,
                          fontSize: 16.sp,
                          alignText: TextAlign.center,
                        ),
                        SizedBox(height: 1.5.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.location_on_rounded,
                              color: AppColors.kEmerald,
                              size: 20,
                            ),
                            SizedBox(width: 1.5.w),
                            CustomText(
                              title: data.location,
                              color: AppColors.kTextSecondary,
                              fontSize: 15.sp,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 3.h),

                  // Stats Grid
                  Row(
                    children: [
                      Expanded(
                        child: ProfileStatCard(
                          label: 'Years of Practice',
                          value: '${data.yearsOfPractice}+',
                          icon: Icons.calendar_month_rounded,
                        ),
                      ),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: ProfileStatCard(
                          label: 'Cases Handled',
                          value: '${data.casesHandled}+',
                          icon: Icons.gavel_rounded,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  Row(
                    children: [
                      Expanded(
                        child: ProfileStatCard(
                          label: 'Overall Win Rate',
                          value: '${(data.overallWinRate * 100).round()}%',
                          icon: Icons.trending_up_rounded,
                        ),
                      ),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: ProfileStatCard(
                          label: 'Active Matters',
                          value: '${data.activeMatters}',
                          icon: Icons.folder_open_rounded,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 4.h),

                  // Practice Areas
                  Align(
                    alignment: Alignment.centerLeft,
                    child: CustomText(
                      title: 'Practice Areas',
                      color: AppColors.kTextPrimary,
                      fontSize: 19.sp,
                      weight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 1.5.h),

                  Wrap(
                    spacing: 2.5.w,
                    runSpacing: 1.5.h,
                    children: data.practiceAreas
                        .map(
                          (area) => Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 4.w,
                              vertical: 1.h,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.kEmerald.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(
                                color: AppColors.kEmerald.withOpacity(0.4),
                              ),
                            ),
                            child: CustomText(
                              title: area,
                              color: AppColors.kEmerald,
                              fontSize: 14.5.sp,
                              weight: FontWeight.w600,
                            ),
                          ),
                        )
                        .toList(),
                  ),

                  SizedBox(height: 4.h),

                  // About Section
                  Align(
                    alignment: Alignment.centerLeft,
                    child: CustomText(
                      title: 'About',
                      color: AppColors.kTextPrimary,
                      fontSize: 19.sp,
                      weight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 1.2.h),

                  CustomText(
                    title: data.about,
                    color: AppColors.kTextSecondary,
                    fontSize: 15.sp,
                    textHeight: 1.5,
                  ),

                  SizedBox(height: 4.h),

                  // Contact & Availability
                  Align(
                    alignment: Alignment.centerLeft,
                    child: CustomText(
                      title: 'Contact & Availability',
                      color: AppColors.kTextPrimary,
                      fontSize: 19.sp,
                      weight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 2.h),

                  ContactCard(
                    icon: Icons.email_rounded,
                    label: 'Email',
                    value: data.email,
                  ),
                  SizedBox(height: 2.h),
                  ContactCard(
                    icon: Icons.phone_rounded,
                    label: 'Phone',
                    value: data.phone,
                  ),
                  SizedBox(height: 2.h),
                  ContactCard(
                    icon: Icons.schedule_rounded,
                    label: 'Office Hours',
                    value: data.officeHours,
                  ),

                  SizedBox(height: 6.h),
                ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
