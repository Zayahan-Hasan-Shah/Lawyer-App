import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lawyer_app/src/core/constants/app_assets.dart';
import 'package:lawyer_app/src/core/constants/app_colors.dart';
import 'package:lawyer_app/src/providers/lawyer_provider/profile_provider/lawyer_profile_provider.dart';
import 'package:lawyer_app/src/widgets/common_widgets/custom_appbar.dart';
import 'package:lawyer_app/src/widgets/common_widgets/custom_client_drawer.dart';
import 'package:lawyer_app/src/widgets/common_widgets/custom_text.dart';
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

    return Scaffold(
      appBar: CustomAppbar(isDrawwer: true, logoImage: AppAssets.logoImage),
      drawer: CustomClientDrawer(),
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: profileState.when(
          initial: () => const SizedBox.shrink(),
          loading: () => const Center(
            child: CircularProgressIndicator(
              color: AppColors.brightYellowColor,
            ),
          ),
          failure: (error) => Center(
            child: CustomText(
              title: error,
              fontSize: 14.sp,
              color: Colors.redAccent,
            ),
          ),
          success: (data) => SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    color: AppColors.inputBackgroundColor,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppColors.iconColor.withOpacity(0.25),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 10.h,
                        height: 10.h,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: AppColors.buttonGradientColor,
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Image.asset(
                          data.profileImage,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              title: data.fullName,
                              fontSize: 20.sp,
                              weight: FontWeight.bold,
                              color: AppColors.whiteColor,
                            ),
                            SizedBox(height: 0.5.h),
                            CustomText(
                              title: data.title,
                              fontSize: 16.sp,
                              color: AppColors.lightDescriptionTextColor,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 1.h),
                            Row(
                              children: [
                                const Icon(
                                  Icons.location_on,
                                  color: AppColors.brightYellowColor,
                                  size: 18,
                                ),
                                SizedBox(width: 1.w),
                                CustomText(
                                  title: data.location,
                                  fontSize: 14.sp,
                                  color: AppColors.lightDescriptionTextColor,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 2.h),
                Row(
                  children: [
                    ProfileStatCard(
                      label: 'Years of Practice',
                      value: '${data.yearsOfPractice}+',
                      icon: Icons.calendar_month,
                    ),
                    SizedBox(width: 3.w),
                    ProfileStatCard(
                      label: 'Cases Handled',
                      value: '${data.casesHandled}+',
                      icon: Icons.gavel,
                    ),
                  ],
                ),
                SizedBox(height: 1.5.h),
                Row(
                  children: [
                    ProfileStatCard(
                      label: 'Overall Win Rate',
                      value: '${(data.overallWinRate * 100).round()}%',
                      icon: Icons.trending_up,
                    ),
                    SizedBox(width: 3.w),
                    ProfileStatCard(
                      label: 'Active Matters',
                      value: '${data.activeMatters}',
                      icon: Icons.folder_open,
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
                CustomText(
                  title: 'Practice Areas',
                  fontSize: 18.sp,
                  weight: FontWeight.w600,
                  color: AppColors.whiteColor,
                ),
                SizedBox(height: 1.5.h),
                Wrap(
                  spacing: 2.w,
                  runSpacing: 1.h,
                  children: data.practiceAreas
                      .map((area) => _Chip(area))
                      .toList(),
                ),
                SizedBox(height: 3.h),
                CustomText(
                  title: 'About',
                  fontSize: 18.sp,
                  weight: FontWeight.w600,
                  color: AppColors.whiteColor,
                ),
                SizedBox(height: 1.h),
                CustomText(
                  title: data.about,
                  fontSize: 16.sp,
                  color: AppColors.lightDescriptionTextColor,
                  maxLines: 6,
                ),
                SizedBox(height: 2.h),
                CustomText(
                  title: 'Contact & Availability',
                  fontSize: 18.sp,
                  weight: FontWeight.w600,
                  color: AppColors.whiteColor,
                ),
                SizedBox(height: 1.5.h),
                _ContactRow(
                  icon: Icons.email_outlined,
                  label: 'Email',
                  value: data.email,
                ),
                _ContactRow(
                  icon: Icons.phone_outlined,
                  label: 'Phone',
                  value: data.phone,
                ),
                _ContactRow(
                  icon: Icons.schedule,
                  label: 'Office Hours',
                  value: data.officeHours,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  const _Chip(this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.8.h),
      decoration: BoxDecoration(
        color: AppColors.inputBackgroundColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.iconColor.withOpacity(0.2)),
      ),
      child: CustomText(
        title: label,
        fontSize: 16.sp,
        color: AppColors.whiteColor,
      ),
    );
  }
}

class _ContactRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _ContactRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 1.5.h),
      child: Row(
        children: [
          Container(
            width: 6.h,
            height: 7.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.iconColor.withOpacity(0.18),
            ),
            child: Icon(icon, size: 3.h, color: AppColors.brightYellowColor),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  title: label,
                  fontSize: 16.sp,
                  color: AppColors.lightDescriptionTextColor,
                ),
                SizedBox(height: 0.2.h),
                CustomText(
                  title: value,
                  fontSize: 14.sp,
                  color: AppColors.whiteColor,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
