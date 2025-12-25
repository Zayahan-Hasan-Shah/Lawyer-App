import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lawyer_app/src/core/constants/app_colors.dart';
import 'package:lawyer_app/src/widgets/common_widgets/custom_button.dart';
import 'package:lawyer_app/src/widgets/common_widgets/custom_text.dart';
import 'package:sizer/sizer.dart';

class PendingCasesTab extends StatelessWidget {
  PendingCasesTab({super.key});

  final List<Map<String, String>> cases = [
    {
      "caseNo": "CR-245/2024",
      "title": "State vs Rajesh Kumar",
      "court": "Delhi High Court",
      "status": "Next Hearing Scheduled",
      "hearingDate": "12 Dec 2025",
      "client": "Rajesh Kumar",
    },
    {
      "caseNo": "CIVIL-112/2023",
      "title": "Property Dispute - Sharma vs Verma",
      "court": "Supreme Court of India",
      "status": "Evidence Stage",
      "hearingDate": "28 Jan 2026",
      "client": "Amit Sharma",
    },
    {
      "caseNo": "FAM-89/2025",
      "title": "Divorce Petition",
      "court": "Family Court, Mumbai",
      "status": "Mediation in Progress",
      "hearingDate": "05 Dec 2025",
      "client": "Priya Singh",
    },
  ];

  void _showCaseDetails(BuildContext context, Map<String, String> c) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        decoration: const BoxDecoration(
          color: AppColors.backgroundColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        padding: EdgeInsets.fromLTRB(6.w, 4.h, 6.w, 8.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 12.w,
                height: 5,
                decoration: BoxDecoration(
                  color: AppColors.pastelYellowColor,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              c["title"]!,
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.whiteColor,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              "Client: ${c["client"]}",
              style: TextStyle(
                fontSize: 15.sp,
                color: AppColors.lightDescriptionTextColor,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              "Case Details",
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.brightYellowColor,
              ),
            ),
            SizedBox(height: 2.h),
            Container(
              decoration: BoxDecoration(
                color: AppColors.inputBackgroundColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Table(
                border: TableBorder.all(
                  color: AppColors.hintTextColor.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(16),
                ),
                children: [
                  _row("Case Number", c["caseNo"]!, isHeader: true),
                  _row("Court Name", c["court"]!),
                  _row("Status", c["status"]!),
                  _row(
                    "Next Hearing",
                    c["hearingDate"]!,
                    valueColor: AppColors.brightYellowColor,
                  ),
                ],
              ),
            ),
            SizedBox(height: 5.h),
            CustomButton(
              text: "Close",
              onPressed: () => context.pop(),
              gradient: AppColors.buttonGradientColor,
              width: double.infinity,
              fontSize: 18.sp,
            ),
          ],
        ),
      ),
    );
  }

  static TableRow _row(
    String label,
    String value, {
    bool isHeader = false,
    Color? valueColor,
  }) {
    return TableRow(
      decoration: BoxDecoration(
        color: isHeader ? AppColors.iconColor.withOpacity(0.2) : null,
      ),
      children: [
        Padding(
          padding: EdgeInsets.all(4.w),
          child: CustomText(
            title: label,
            fontSize: 16.sp,
            color: isHeader
                ? AppColors.brightYellowColor
                : AppColors.lightDescriptionTextColor,
          ),
        ),
        Padding(
          padding: EdgeInsets.all(4.w),
          child: CustomText(
            title: value,
            fontSize: 16.sp,
            color: isHeader
                ? AppColors.brightYellowColor
                : AppColors.lightDescriptionTextColor,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (cases.isEmpty) {
      return Center(
        child: Text(
          "No pending cases",
          style: TextStyle(
            fontSize: 18.sp,
            color: AppColors.lightDescriptionTextColor,
          ),
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(5.w),
      itemCount: cases.length,
      itemBuilder: (_, i) {
        final c = cases[i];
        return Container(
          margin: EdgeInsets.only(bottom: 2.5.h),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.inputBackgroundColor,
                AppColors.inputBackgroundColor.withOpacity(0.8),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.iconColor.withOpacity(0.3)),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () => _showCaseDetails(context, c),
            child: Padding(
              padding: EdgeInsets.all(5.w),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: AppColors.buttonGradientColor,
                    ),
                    child: Center(
                      child: CustomText(
                        title: c["caseNo"]!.split("/").last,
                        fontSize: 14.sp,
                        weight: FontWeight.bold,
                        color: AppColors.blackColor,
                      ),
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          title: c["title"]!,
                          fontSize: 16.sp,
                          weight: FontWeight.bold,
                          color: AppColors.whiteColor,
                          maxWords: 4,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 0.5.h),
                        CustomText(
                          title: c["court"]!,
                          color: AppColors.lightDescriptionTextColor,
                          fontSize: 15.sp,
                        ),
                        SizedBox(height: 1.h),
                        Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              size: 18,
                              color: AppColors.iconColor,
                            ),
                            SizedBox(width: 2.w),
                            CustomText(
                              title: "Next: ${c["hearingDate"]}",
                              color: AppColors.brightYellowColor,
                              weight: FontWeight.w600,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 3.w,
                      vertical: 1.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.caseTypeBackgroundColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: AppColors.caseTypeBackgroundColor,
                      ),
                    ),
                    child: CustomText(
                      title: c["status"]!.split(" ").first,
                      color: AppColors.brightYellowColor,
                      weight: FontWeight.bold,
                      fontSize: 14.sp,
                    ),
                  ),
                ],
              ),
            ),
          ),  
        );
      },
    );
  }
}
