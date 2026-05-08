import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lawyer_app/src/core/constants/app_assets.dart';
import 'package:lawyer_app/src/core/constants/app_colors.dart';
import 'package:lawyer_app/src/models/student_model/certification_model.dart';
import 'package:lawyer_app/src/providers/student_provider/certifications_provider/certification_provider.dart';
import 'package:lawyer_app/src/widgets/common_widgets/custom_appbar.dart';
import 'package:lawyer_app/src/widgets/common_widgets/custom_button.dart';
import 'package:lawyer_app/src/widgets/common_widgets/custom_text.dart';
import 'package:lawyer_app/src/widgets/common_widgets/failed_widget.dart';
import 'package:lawyer_app/src/widgets/common_widgets/loading_indicator.dart';
import 'package:lawyer_app/src/widgets/student_widgets/certification_widgets/certification_item_widget.dart';
import 'package:sizer/sizer.dart';

class CertificationScreen extends ConsumerStatefulWidget {
  const CertificationScreen({super.key});

  @override
  ConsumerState<CertificationScreen> createState() =>
      _CertificationScreenState();
}

class _CertificationScreenState extends ConsumerState<CertificationScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(certificationControllerProvider.notifier).getAllCertifications();
    });
  }

  @override
  Widget build(BuildContext context) {
    final certificationState = ref.watch(certificationControllerProvider);

    final availableCertifications = certificationState.when(
      initial: () => <CertificationModel>[],
      loading: () => <CertificationModel>[],
      failure: (error) => <CertificationModel>[],
      success: (data) => data.availableCertifications,
    );

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

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 3.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 2.h),
                  CustomText(
                    title: "Certifications",
                    color: AppColors.kTextPrimary,
                    fontSize: 26.sp,
                    weight: FontWeight.w800,
                  ),
                  SizedBox(height: 0.4.h),
                  CustomText(
                    title:
                        "Enhance your skills with professional certifications",
                    color: AppColors.kTextSecondary,
                    fontSize: 16.sp,
                    maxLines: 2,
                  ),
                  SizedBox(height: 3.h),
                ],
              ),
            ),

            Expanded(
              child: certificationState.when(
                initial: () => const SizedBox(),
                loading: () => LoadingIndicator(),
                failure: (error) => Center(
                  child: FailedWidget(
                    text: error,
                    icon: Icons.error_outline_rounded,
                  ),
                ),
                success: (data) => ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 2.w),
                  itemCount: data.availableCertifications.length,
                  itemBuilder: (context, index) {
                    final certification = data.availableCertifications[index];
                    return CertificationItemWidget(
                      certification: certification,
                      isCompleted: false,
                      onTap: () =>
                          _showCertificationDetails(context, certification),
                      onEnroll: () =>
                          _enrollInCertification(context, certification),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _enrollInCertification(
    BuildContext context,
    CertificationModel certification,
  ) {
    ref
        .read(certificationControllerProvider.notifier)
        .enrollInCertification(certification.id);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Successfully enrolled in "${certification.title}"'),
        backgroundColor: AppColors.kEmerald,
      ),
    );
  }

  void _showCertificationDetails(
    BuildContext context,
    CertificationModel certification,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.kSurface.withValues(alpha: 0.96),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: CustomText(
          title: certification.title,
          color: AppColors.kTextPrimary,
          fontSize: 20.sp,
          weight: FontWeight.w700,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              title: certification.description,
              color: AppColors.kTextSecondary,
              fontSize: 16.sp,
            ),
            SizedBox(height: 1.h),
            Row(
              children: [
                Icon(Icons.person, size: 6.w, color: AppColors.kEmerald),
                SizedBox(width: 1.w),
                CustomText(
                  title: 'Instructor: ${certification.instructor}',
                  color: AppColors.kTextSecondary,
                  fontSize: 15.sp,
                ),
              ],
            ),
            SizedBox(height: 0.5.h),
            Row(
              children: [
                Icon(Icons.schedule, size: 6.w, color: AppColors.kEmerald),
                SizedBox(width: 1.w),
                CustomText(
                  title: 'Duration: ${certification.duration}',
                  color: AppColors.kTextSecondary,
                  fontSize: 15.sp,
                ),
              ],
            ),
            SizedBox(height: 0.5.h),
            Row(
              children: [
                Icon(Icons.bar_chart, size: 6.w, color: AppColors.kEmerald),
                SizedBox(width: 1.w),
                CustomText(
                  title: 'Level: ${certification.level}',
                  color: AppColors.kTextSecondary,
                  fontSize: 15.sp,
                ),
              ],
            ),
            if (certification.skills.isNotEmpty) ...[
              SizedBox(height: 1.h),
              CustomText(
                title: 'Skills:',
                color: AppColors.kTextPrimary,
                fontSize: 15.sp,
                weight: FontWeight.w600,
              ),
              SizedBox(height: 0.5.h),
              Wrap(
                spacing: 1.w,
                runSpacing: 0.5.h,
                children: certification.skills
                    .map(
                      (skill) => Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 1.5.w,
                          vertical: 0.3.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.kEmerald.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: CustomText(
                          title: skill,
                          color: AppColors.kEmerald,
                          fontSize: 14.sp,
                        ),
                      ),
                    )
                    .toList(),
              ),
            ],
          ],
        ),
        actions: [
          CustomButton(
            text: "Close",
            onPressed: () => Navigator.pop(context),
            backgroundColor: AppColors.kEmeraldDark,
            textColor: Colors.white,
          ),
          CustomButton(
            text: "Enroll",
            onPressed: () {
              Navigator.pop(context);
              _enrollInCertification(context, certification);
            },
            backgroundColor: AppColors.kEmerald,
            textColor: Colors.white,
          ),
        ],
      ),
    );
  }
}
