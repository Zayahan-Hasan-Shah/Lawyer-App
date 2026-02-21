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
import 'package:lawyer_app/src/widgets/student_widgets/certification_item_widget.dart';
import 'package:lawyer_app/src/widgets/student_widgets/empty_state_widget.dart';
import 'package:sizer/sizer.dart';

class CertificationScreen extends ConsumerStatefulWidget {
  const CertificationScreen({super.key});

  @override
  ConsumerState<CertificationScreen> createState() => _CertificationScreenState();
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
          colors: [
            Color(0xFF0D1117),
            Color(0xFF0A1F24),
            Color(0xFF08151A),
          ],
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
              padding: EdgeInsets.symmetric(horizontal: 6.w),
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
                    title: "Enhance your skills with professional certifications",
                    color: AppColors.kTextSecondary,
                    fontSize: 15.sp,
                  ),
                  SizedBox(height: 3.h),
                ],
              ),
            ),

            Expanded(
              child: certificationState.when(
                initial: () => const SizedBox(),
                loading: () => Center(
                  child: CircularProgressIndicator(
                    color: AppColors.kEmerald,
                    strokeWidth: 4,
                  ),
                ),
                failure: (error) => Center(
                  child: FailedWidget(
                    text: error,
                    icon: Icons.error_outline_rounded,
                  ),
                ),
                success: (data) => ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 6.w),
                  itemCount: data.availableCertifications.length,
                  itemBuilder: (context, index) {
                    final certification = data.availableCertifications[index];
                    return CertificationItemWidget(
                      certification: certification,
                      isCompleted: false,
                      onTap: () => _showCertificationDetails(context, certification),
                      onEnroll: () => _enrollInCertification(context, certification),
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

  void _enrollInCertification(BuildContext context, CertificationModel certification) {
    ref.read(certificationControllerProvider.notifier).enrollInCertification(certification.id);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Successfully enrolled in "${certification.title}"'),
        backgroundColor: AppColors.kEmerald,
      ),
    );
  }

  void _showCertificationDetails(BuildContext context, CertificationModel certification) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.kSurface.withOpacity(0.96),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(
          certification.title,
          style: TextStyle(
            color: AppColors.kTextPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              certification.description,
              style: TextStyle(color: AppColors.kTextSecondary),
            ),
            SizedBox(height: 1.h),
            Row(
              children: [
                Icon(Icons.person, size: 16, color: AppColors.kEmerald),
                SizedBox(width: 1.w),
                Text(
                  'Instructor: ${certification.instructor}',
                  style: TextStyle(color: AppColors.kTextSecondary),
                ),
              ],
            ),
            SizedBox(height: 0.5.h),
            Row(
              children: [
                Icon(Icons.schedule, size: 16, color: AppColors.kEmerald),
                SizedBox(width: 1.w),
                Text(
                  'Duration: ${certification.duration}',
                  style: TextStyle(color: AppColors.kTextSecondary),
                ),
              ],
            ),
            SizedBox(height: 0.5.h),
            Row(
              children: [
                Icon(Icons.bar_chart, size: 16, color: AppColors.kEmerald),
                SizedBox(width: 1.w),
                Text(
                  'Level: ${certification.level}',
                  style: TextStyle(color: AppColors.kTextSecondary),
                ),
              ],
            ),
            if (certification.skills.isNotEmpty) ...[
              SizedBox(height: 1.h),
              Text(
                'Skills:',
                style: TextStyle(
                  color: AppColors.kTextPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 0.5.h),
              Wrap(
                spacing: 1.w,
                runSpacing: 0.5.h,
                children: certification.skills.map((skill) => Container(
                  padding: EdgeInsets.symmetric(horizontal: 1.5.w, vertical: 0.3.h),
                  decoration: BoxDecoration(
                    color: AppColors.kEmerald.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    skill,
                    style: TextStyle(
                      color: AppColors.kEmerald,
                      fontSize: 12,
                    ),
                  ),
                )).toList(),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Close',
              style: TextStyle(color: AppColors.kTextSecondary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCertificationCard(CertificationModel certification) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.kSurface.withOpacity(0.8),
            AppColors.kSurfaceElevated.withOpacity(0.6),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.kEmerald.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CertificationDetailScreen(certification: certification),
              ),
            );
          },
          child: Padding(
            padding: EdgeInsets.all(4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(2.w),
                      decoration: BoxDecoration(
                        color: AppColors.kEmerald.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.school,
                        color: AppColors.kEmerald,
                        size: 6.w,
                      ),
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: CustomText(
                        title: certification.title,
                        fontSize: 16.sp,
                        weight: FontWeight.w600,
                        color: AppColors.kTextPrimary,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
                CustomText(
                  title: certification.description,
                  fontSize: 14.sp,
                  color: AppColors.kTextSecondary,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 2.h),
                Row(
                  children: [
                    Icon(Icons.schedule, size: 14, color: AppColors.kEmerald),
                    SizedBox(width: 1.w),
                    CustomText(
                      title: certification.duration,
                      fontSize: 12.sp,
                      color: AppColors.kTextSecondary,
                    ),
                    SizedBox(width: 4.w),
                    Icon(Icons.calendar_today, size: 14, color: AppColors.kEmerald),
                    SizedBox(width: 1.w),
                    CustomText(
                      title: "${certification.startDate} - ${certification.endDate}",
                      fontSize: 12.sp,
                      color: AppColors.kTextSecondary,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CertificationDetailScreen extends StatelessWidget {
  final CertificationModel certification;

  const CertificationDetailScreen({super.key, required this.certification});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kBgDark,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: AppColors.kTextPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          certification.title,
          style: TextStyle(
            color: AppColors.kTextPrimary,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0D1117),
              Color(0xFF0A1F24),
              Color(0xFF08151A),
            ],
            stops: [0.0, 0.6, 1.0],
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(6.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.kSurface.withOpacity(0.8),
                      AppColors.kSurfaceElevated.withOpacity(0.6),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.kEmerald.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(3.w),
                          decoration: BoxDecoration(
                            color: AppColors.kEmerald.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.school,
                            color: AppColors.kEmerald,
                            size: 8.w,
                          ),
                        ),
                        SizedBox(width: 3.w),
                        Expanded(
                          child: CustomText(
                            title: certification.title,
                            fontSize: 20.sp,
                            weight: FontWeight.w700,
                            color: AppColors.kTextPrimary,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 3.h),
                    CustomText(
                      title: "Description",
                      fontSize: 16.sp,
                      weight: FontWeight.w600,
                      color: AppColors.kTextPrimary,
                    ),
                    SizedBox(height: 1.h),
                    CustomText(
                      title: certification.description,
                      fontSize: 14.sp,
                      color: AppColors.kTextSecondary,
                    ),
                    SizedBox(height: 3.h),
                    Row(
                      children: [
                        Expanded(
                          child: _buildDetailItem(
                            "Duration",
                            certification.duration,
                            Icons.schedule,
                          ),
                        ),
                        SizedBox(width: 3.w),
                        Expanded(
                          child: _buildDetailItem(
                            "Start Date",
                            certification.startDate,
                            Icons.calendar_today,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 2.h),
                    _buildDetailItem(
                      "End Date",
                      certification.endDate,
                      Icons.event,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 4.h),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(4.w),
                child: ElevatedButton(
                  onPressed: () {
                    // Show enrollment confirmation
                    _showEnrollmentDialog(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.kEmerald,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    "Enroll Now",
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailItem(String label, String value, IconData icon) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppColors.kSurface.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: AppColors.kEmerald),
              SizedBox(width: 1.w),
              CustomText(
                title: label,
                fontSize: 12.sp,
                color: AppColors.kTextSecondary,
              ),
            ],
          ),
          SizedBox(height: 0.5.h),
          CustomText(
            title: value,
            fontSize: 14.sp,
            weight: FontWeight.w600,
            color: AppColors.kTextPrimary,
          ),
        ],
      ),
    );
  }

  void _showEnrollmentDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.kSurface.withOpacity(0.96),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(
          'Enroll in Certification',
          style: TextStyle(
            color: AppColors.kTextPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        content: Text(
          'Are you sure you want to enroll in ${certification.title}?',
          style: TextStyle(color: AppColors.kTextSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: AppColors.kTextSecondary),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Show success message
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Successfully enrolled in ${certification.title}'),
                  backgroundColor: AppColors.kEmerald,
                ),
              );
            },
            child: Text(
              'Enroll',
              style: TextStyle(color: AppColors.kEmerald),
            ),
          ),
        ],
      ),
    );
  }
}
