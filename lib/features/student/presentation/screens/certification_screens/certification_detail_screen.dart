
import 'package:flutter/material.dart';
import 'package:lawyer_app/core/constants/app_colors.dart';
import 'package:lawyer_app/features/student/data/models/certification_model.dart';
import 'package:lawyer_app/shared/widgets/custom_button.dart';
import 'package:lawyer_app/shared/widgets/custom_text.dart';
import 'package:sizer/sizer.dart';

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
        color: AppColors.kBgDark,
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
                      AppColors.kSurface.withValues(alpha: 0.8),
                      AppColors.kSurfaceElevated.withValues(alpha: 0.6),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.kEmerald.withValues(alpha: 0.3),
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
                            color: AppColors.kEmerald.withValues(alpha: 0.2),
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
        color: AppColors.kSurface.withValues(alpha: 0.5),
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
        backgroundColor: AppColors.kSurface.withValues(alpha: 0.96),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
          CustomButton(
            onPressed: () {
              Navigator.pop(context);
              // Show success message
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Successfully enrolled in ${certification.title}',
                  ),
                  backgroundColor: AppColors.kEmerald,
                ),
              );
            },
            text: "Enrol",
            textColor: AppColors.kEmerald,
          ),
        ],
      ),
    );
  }
}

