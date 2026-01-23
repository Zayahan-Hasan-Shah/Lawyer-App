import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lawyer_app/src/core/constants/app_colors.dart';
import 'package:lawyer_app/src/models/client_model/case_model/case_model.dart';
import 'package:lawyer_app/src/widgets/common_widgets/custom_button.dart';
import 'package:lawyer_app/src/widgets/common_widgets/custom_text.dart';
import 'package:sizer/sizer.dart';

class PendingCasesTab extends StatelessWidget {
  final List<CaseModel> cases;
  const PendingCasesTab({super.key, required this.cases});

  void _showCaseDetails(BuildContext context, CaseModel c) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (a) => Container(
        decoration: BoxDecoration(
          color: AppColors.kSurface.withOpacity(0.94),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          border: Border.all(color: AppColors.kEmerald.withOpacity(0.18)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              blurRadius: 32,
              offset: const Offset(0, -8),
            ),
          ],
        ),
        padding: EdgeInsets.fromLTRB(6.w, 3.h, 6.w, 6.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Drag handle
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
            SizedBox(height: 3.5.h),

            // Title
            CustomText(
              title: c.title,
              fontSize: 21.sp,
              weight: FontWeight.w800,
              color: AppColors.kTextPrimary,
              maxLines: 2,
            ),
            SizedBox(height: 0.5.h),

            CustomText(
              title: "Client: ${c.client}",
              fontSize: 16.sp,
              color: AppColors.kTextSecondary,
            ),
            SizedBox(height: 3.h),

            // Case Details Section
            CustomText(
              title: "Case Details",
              fontSize: 18.sp,
              weight: FontWeight.w700,
              color: AppColors.kEmerald,
            ),
            SizedBox(height: 1.5.h),

            Container(
              decoration: BoxDecoration(
                color: AppColors.kInputBg.withOpacity(0.85),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.kEmerald.withOpacity(0.2)),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Table(
                  border: TableBorder.all(
                    color: AppColors.kEmerald.withOpacity(0.12),
                    width: 1,
                  ),
                  children: [
                    _tableRow("Case Number", c.caseNo, isHeader: true),
                    _tableRow("Court Name", c.court),
                    _tableRow("Status", c.status),
                    _tableRow(
                      "Next Hearing",
                      c.hearingDate ?? "-",
                      valueColor: AppColors.kEmerald,
                    ),
                    _tableRow(
                      "Category",
                      c.category,
                      valueColor: c.category.toLowerCase().contains('criminal')
                          ? Colors.redAccent
                          : AppColors.kEmerald,
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 5.h),

            // Close Button
            SizedBox(
              width: double.infinity,
              child: CustomButton(
                text: "Close",
                onPressed: () => context.pop(),
                gradient: LinearGradient(
                  colors: [AppColors.kEmerald, AppColors.kEmeraldDark],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                textColor: Colors.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                borderRadius: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  static TableRow _tableRow(
    String label,
    String value, {
    bool isHeader = false,
    Color? valueColor,
  }) {
    return TableRow(
      decoration: BoxDecoration(
        color: isHeader ? AppColors.kEmerald.withOpacity(0.12) : null,
      ),
      children: [
        Padding(
          padding: EdgeInsets.all(4.w),
          child: CustomText(
            title: label,
            color: isHeader ? AppColors.kEmerald : AppColors.kTextSecondary,
            weight: isHeader ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
        Padding(
          padding: EdgeInsets.all(4.w),
          child: CustomText(
            title: value,
            color: valueColor ?? AppColors.kTextPrimary,
            weight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

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
              color: AppColors.kEmerald.withOpacity(0.6),
            ),
            SizedBox(height: 2.5.h),
            CustomText(
              title: 'No pending cases',
              color: AppColors.kTextPrimary,
              fontSize: 20.sp,
              weight: FontWeight.w700,
            ),
            SizedBox(height: 1.2.h),
            CustomText(
              title: 'New matters assigned to you will appear here',
              color: AppColors.kTextSecondary,
              fontSize: 15.sp,
              alignText: TextAlign.center,
              maxLines: 2,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
      itemCount: cases.length,
      itemBuilder: (ctx, i) {
        final c = cases[i];

        return Padding(
          padding: EdgeInsets.only(bottom: 2.2.h),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.kSurface.withOpacity(0.92),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.kEmerald.withOpacity(0.18),
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.35),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                child: InkWell(
                  onTap: () => _showCaseDetails(context, c),
                  borderRadius: BorderRadius.circular(20),
                  child: Padding(
                    padding: EdgeInsets.all(4.w),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Case badge
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
                                blurRadius: 16,
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              c.caseNo.split('/').last,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 4.w),

                        // Main content
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                title: c.title,
                                color: AppColors.kTextPrimary,
                                fontSize: 17.sp,
                                weight: FontWeight.w700,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 0.5.h),

                              CustomText(
                                title: c.court,
                                color: AppColors.kTextSecondary,
                                fontSize: 14.5.sp,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 1.h),

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
                                      Icons.access_time_rounded,
                                      size: 2.h,
                                      color: AppColors.kEmerald,
                                    ),
                                    SizedBox(width: 2.w),
                                    CustomText(
                                      title: "Next: ${c.hearingDate ?? '-'}",
                                      color: AppColors.kEmerald,
                                      fontSize: 13.8.sp,
                                      weight: FontWeight.w600,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(width: 3.w),

                        // Category badge
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 3.w,
                            vertical: 1.h,
                          ),
                          decoration: BoxDecoration(
                            color:
                                (c.category.toLowerCase().contains('criminal')
                                        ? Colors.redAccent
                                        : AppColors.kEmerald)
                                    .withOpacity(0.15),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color:
                                  c.category.toLowerCase().contains('criminal')
                                  ? Colors.redAccent
                                  : AppColors.kEmerald,
                            ),
                          ),
                          child: CustomText(
                            title: c.category,
                            color: c.category.toLowerCase().contains('criminal')
                                ? Colors.redAccent
                                : AppColors.kEmerald,
                            fontSize: 14.sp,
                            weight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
