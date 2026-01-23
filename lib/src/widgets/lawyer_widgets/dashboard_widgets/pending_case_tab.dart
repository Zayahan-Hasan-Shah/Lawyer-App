import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:lawyer_app/src/core/constants/app_colors.dart';
import 'package:lawyer_app/src/models/lawyer_model/case_model/lawyer_case_model.dart';
import 'package:lawyer_app/src/widgets/common_widgets/custom_text.dart';
import 'package:sizer/sizer.dart';

class PendingLawyerCasesTab extends StatelessWidget {
  final List<LawyerCaseModel> cases;

  const PendingLawyerCasesTab({super.key, required this.cases});

  @override
  Widget build(BuildContext context) {
    if (cases.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.hourglass_empty_rounded,
              size: 80,
              color: AppColors.kTextSecondary,
            ),
            SizedBox(height: 2.h),
            Text(
              'No pending cases',
              style: TextStyle(
                color: AppColors.kTextPrimary,
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              'New matters will appear here',
              style: TextStyle(
                color: AppColors.kTextSecondary,
                fontSize: 15.sp,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
      itemCount: cases.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, i) {
        final c = cases[i];

        return Padding(
          padding: EdgeInsets.only(bottom: 1.h),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.kEmerald.withOpacity(0.18),
                width: 1,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                child: Padding(
                  padding: EdgeInsets.all(2.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 6.h,
                            height: 6.h,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  AppColors.kEmerald,
                                  AppColors.kEmeraldDark,
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.kEmerald.withOpacity(0.35),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                            child: Center(
                              child: CustomText(
                                title: c.caseNo.split('/').last,
                                color: Colors.white,
                                fontSize: 15.sp,
                                weight: FontWeight.w800,
                              ),
                            ),
                          ),
                          SizedBox(width: 4.w),
                          Expanded(
                            child: CustomText(
                              title: c.title,
                              color: AppColors.kTextPrimary,
                              fontSize: 17.sp,
                              weight: FontWeight.w700,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 0.5.h),
                                CustomText(
                                  title: '${c.client} • ${c.court}',
                                  color: AppColors.kTextSecondary,
                                  fontSize: 16.sp,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 1.2.h),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 3.w,
                                    vertical: 0.8.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.kEmerald.withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        c.appointmentType == 'Video'
                                            ? Icons.videocam_rounded
                                            : Icons.meeting_room_rounded,
                                        size: 2.5.h,
                                        color: AppColors.kEmerald,
                                      ),
                                      SizedBox(width: 2.w),
                                      CustomText(
                                        title:
                                            '${c.appointmentType} • Next: ${c.hearingDate ?? '-'}',
                                        color: AppColors.kEmerald,
                                        fontSize: 14.sp,
                                        weight: FontWeight.w600,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 0.5.h),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton.icon(
                          onPressed: () => _showDocuments(context, c),
                          icon: Icon(
                            Icons.description_rounded,
                            color: AppColors.kEmerald,
                            size: 2.5.h,
                          ),
                          label: CustomText(
                            title: 'Documents (${c.documents.length})',
                            color: AppColors.kEmerald,
                            fontSize: 14.sp,
                            weight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // _showDocuments remains mostly the same, just update colors
  void _showDocuments(BuildContext context, LawyerCaseModel c) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => Container(
        decoration: BoxDecoration(
          color: AppColors.kSurface.withOpacity(0.95),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          border: Border.all(color: AppColors.kEmerald.withOpacity(0.18)),
        ),
        padding: EdgeInsets.fromLTRB(6.w, 3.h, 6.w, 5.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 12.w,
                height: 5,
                decoration: BoxDecoration(
                  color: AppColors.kEmerald.withOpacity(0.35),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 3.h),
            CustomText(
              title: 'Case Documents',
              color: AppColors.kTextPrimary,
              fontSize: 20.sp,
              weight: FontWeight.w700,
            ),
            SizedBox(height: 0.8.h),
            CustomText(
              title: '${c.caseNo} • ${c.title}',
              color: AppColors.kTextSecondary,
              fontSize: 16.sp,
            ),
            SizedBox(height: 3.h),
            ...c.documents.map(
              (doc) => Padding(
                padding: EdgeInsets.only(bottom: 1.6.h),
                child: Container(
                  padding: EdgeInsets.all(3.5.w),
                  decoration: BoxDecoration(
                    color: AppColors.kInputBg.withOpacity(0.85),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.kEmerald.withOpacity(0.2),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.insert_drive_file_rounded,
                        color: AppColors.kTextSecondary,
                        size: 24,
                      ),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: CustomText(
                          title: doc,
                          color: AppColors.kTextPrimary,
                          fontSize: 15.sp,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Icon(
                        Icons.visibility_rounded,
                        color: AppColors.kEmerald,
                        size: 22,
                      ),
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