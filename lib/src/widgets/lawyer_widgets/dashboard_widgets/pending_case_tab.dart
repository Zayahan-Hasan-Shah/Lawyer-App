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
        final probabilityPercent = (c.winProbability * 100).round();
        final isHighChance = probabilityPercent >= 70;

        return Container(
          margin: EdgeInsets.only(bottom: 2.h),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.inputBackgroundColor,
                AppColors.inputBackgroundColor.withOpacity(0.8),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(2.h),
            border: Border.all(color: AppColors.iconColor.withOpacity(0.3)),
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
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: AppColors.buttonGradientColor,
                          ),
                          child: Center(
                            child: CustomText(
                              title: c.caseNo.split('/').last,
                              fontSize: 14.sp,
                              weight: FontWeight.bold,
                              color: AppColors.blackColor,
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
                                    : Colors.blueAccent)
                                .withOpacity(0.2),
                            borderRadius: BorderRadius.circular(1.5.w),
                            border: Border.all(
                              color: c.category == 'Criminal'
                                  ? Colors.redAccent
                                  : Colors.blueAccent,
                            ),
                          ),
                          child: Center(
                            child: CustomText(
                              title: c.category,
                              color: c.category == 'Criminal'
                                  ? Colors.redAccent
                                  : Colors.blueAccent,
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
                            color: AppColors.whiteColor,
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
                                color: AppColors.iconColor,
                              ),
                              SizedBox(width: 2.w),
                              Expanded(
                                child: CustomText(
                                  title:
                                      '${c.appointmentType} appointment • Next: ${c.hearingDate ?? '-'}',
                                  color: AppColors.brightYellowColor,
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
                SizedBox(height: 1.8.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Container(
                        height: 4.2.h,
                        padding: EdgeInsets.symmetric(
                          horizontal: 3.w,
                        ),
                        decoration: BoxDecoration(
                          color: ((probabilityPercent < 50
                                      ? Colors.redAccent
                                      : isHighChance
                                          ? Colors.greenAccent
                                          : Colors.orangeAccent)
                                  .withOpacity(0.16)),
                          borderRadius: BorderRadius.circular(2.w),
                          border: Border.all(
                            color: probabilityPercent < 50
                                ? Colors.redAccent
                                : isHighChance
                                    ? Colors.greenAccent
                                    : Colors.orangeAccent,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomText(
                              title: 'Win Probability',
                              color: AppColors.lightDescriptionTextColor,
                              fontSize: 14.sp,
                            ),
                            CustomText(
                              title: '$probabilityPercent%',
                              color: probabilityPercent < 50
                                  ? Colors.redAccent
                                  : isHighChance
                                      ? Colors.greenAccent
                                      : Colors.orangeAccent,
                              weight: FontWeight.bold,
                              fontSize: 14.sp,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 1.h),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    onPressed: () => _showDocuments(context, c),
                    icon: const Icon(Icons.description, color: Colors.white70),
                    label: CustomText(
                      title: 'View Documents (${c.documents.length})',
                      color: AppColors.whiteColor,
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
        decoration: const BoxDecoration(
          color: AppColors.backgroundColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
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
                  color: AppColors.pastelYellowColor,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 3.h),
            CustomText(
              title: 'Case Documents',
              fontSize: 18.sp,
              weight: FontWeight.bold,
              color: AppColors.whiteColor,
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