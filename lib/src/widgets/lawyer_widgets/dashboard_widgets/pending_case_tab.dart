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
    final colorScheme = Theme.of(context).colorScheme;

    if (cases.isEmpty) {
      return Center(
        child: CustomText(
          title: 'No pending matters',
          fontSize: 18.sp,
          color: AppColors.lightDescriptionTextColor,
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(2.w),
      itemCount: cases.length,
      itemBuilder: (_, i) {
        final c = cases[i];

        return Container(
          margin: EdgeInsets.only(bottom: 2.h),
          decoration: BoxDecoration(
            color: colorScheme.surface.withOpacity(0.95),
            borderRadius: BorderRadius.circular(2.h),
            border: Border.all(color: colorScheme.primary.withOpacity(0.28)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.35),
                blurRadius: 18,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(2.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Left column: case number + category
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 8.h,
                          height: 8.h,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [
                                colorScheme.primary,
                                colorScheme.secondary,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: Center(
                            child: CustomText(
                              title: c.caseNo.split('/').last,
                              fontSize: 14.sp,
                              weight: FontWeight.bold,
                              color: colorScheme.onPrimary,
                            ),
                          ),
                        ),
                        SizedBox(height: 1.h),
                        Container(
                          // height: 4.2.h,
                          padding: EdgeInsets.symmetric(
                            horizontal: 3.w,
                            vertical: 1.w,
                          ),
                          decoration: BoxDecoration(
                            color: (c.category == 'Criminal'
                                    ? Colors.redAccent
                                    : Colors.tealAccent)
                                .withOpacity(0.18),
                            borderRadius: BorderRadius.circular(1.5.w),
                            border: Border.all(
                              color: c.category == 'Criminal'
                                  ? Colors.redAccent
                                  : Colors.tealAccent,
                            ),
                          ),
                          child: Center(
                            child: CustomText(
                              title: c.category,
                              color: c.category == 'Criminal'
                                  ? Colors.redAccent
                                  : Colors.tealAccent,
                              weight: FontWeight.bold,
                              fontSize: 15.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 3.w),
                    // Right column: case details and appointment
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            title: c.title,
                            fontSize: 16.sp,
                            weight: FontWeight.bold,
                            color: colorScheme.onSurface,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 0.5.h),
                          CustomText(
                            title: '${c.client} • ${c.court}',
                            color: AppColors.lightDescriptionTextColor,
                            fontSize: 14.sp,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 0.8.h),
                          Row(
                            children: [
                              Icon(
                                c.appointmentType == 'Video'
                                    ? Icons.videocam
                                    : Icons.meeting_room,
                                size: 24,
                                color: colorScheme.tertiary,
                              ),
                              SizedBox(width: 2.w),
                              Expanded(
                                child: CustomText(
                                  title:
                                      '${c.appointmentType} appointment • Next: ${c.hearingDate ?? '-'}',
                                  color: colorScheme.secondary,
                                  weight: FontWeight.w600,
                                  fontSize: 14.sp,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 1.2.h),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    onPressed: () => _showDocuments(context, c),
                    icon: const Icon(Icons.description, color: Colors.white70),
                    label: CustomText(
                      title: 'View Documents (${c.documents.length})',
                      color: colorScheme.primary,
                      fontSize: 14.sp,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showDocuments(BuildContext context, LawyerCaseModel c) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface.withOpacity(0.98),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: EdgeInsets.fromLTRB(6.w, 3.h, 6.w, 4.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 12.w,
                height: 4,
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .primary
                      .withOpacity(0.4),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 3.h),
            CustomText(
              title: 'Case Documents',
              fontSize: 18.sp,
              weight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            SizedBox(height: 1.h),
            CustomText(
              title: '${c.caseNo} • ${c.title}',
              fontSize: 14.sp,
              color: AppColors.lightDescriptionTextColor,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 2.h),
            ...c.documents.map(
              (doc) => Container(
                margin: EdgeInsets.only(bottom: 1.2.h),
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.4.h),
                decoration: BoxDecoration(
                  color: AppColors.inputBackgroundColor,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: AppColors.iconColor.withOpacity(0.25),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.insert_drive_file,
                      color: Colors.white70,
                      size: 22,
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: CustomText(
                        title: doc,
                        color: AppColors.whiteColor,
                        fontSize: 14.sp,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const Icon(
                      Icons.visibility,
                      color: AppColors.brightYellowColor,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}