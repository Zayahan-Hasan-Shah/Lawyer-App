import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lawyer_app/core/constants/app_colors.dart';
import 'package:lawyer_app/features/client/data/models/case_model/case_model.dart';
import 'package:lawyer_app/shared/widgets/custom_button.dart';
import 'package:lawyer_app/shared/widgets/custom_text.dart';
import 'package:sizer/sizer.dart';

class PendingCasesTab extends StatelessWidget {
  final List<CaseModel> cases;
  const PendingCasesTab({super.key, required this.cases});

  // ------------------------------------------------------------------
  // Helpers
  // ------------------------------------------------------------------

  /// Format ISO-8601 string to "dd MMM yyyy  •  hh:mm a"
  /// Returns "-" if null or unparsable.
  static String _formatDate(String? raw) {
    if (raw == null || raw.trim().isEmpty) return '-';
    try {
      final dt = DateTime.parse(raw).toLocal();
      return DateFormat('dd MMM yyyy  •  hh:mm a').format(dt);
    } catch (_) {
      return raw;
    }
  }

  /// Return just the year from an ISO-8601 string. Returns "-" if null.
  static String _yearOnly(String? raw) {
    if (raw == null || raw.trim().isEmpty) return '-';
    try {
      return DateTime.parse(raw).year.toString();
    } catch (_) {
      return raw;
    }
  }

  // ------------------------------------------------------------------
  // Bottom-sheet detail
  // ------------------------------------------------------------------
  void _showCaseDetails(BuildContext context, CaseModel c) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (a) => DraggableScrollableSheet(
        initialChildSize: 0.75,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (_, ctrl) => Container(
          decoration: BoxDecoration(
            color: AppColors.kSurface.withValues(alpha: 0.97),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            border: Border.all(
              color: AppColors.kEmerald.withValues(alpha: 0.18),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.45),
                blurRadius: 32,
                offset: const Offset(0, -8),
              ),
            ],
          ),
          padding: EdgeInsets.fromLTRB(6.w, 1.5.h, 6.w, 4.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag handle
              Container(
                width: 12.w,
                height: 5,
                decoration: BoxDecoration(
                  color: AppColors.kEmerald.withValues(alpha: 0.35),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              SizedBox(height: 2.5.h),

              Expanded(
                child: ListView(
                  controller: ctrl,
                  children: [
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
                      fontSize: 15.sp,
                      color: AppColors.kTextSecondary,
                    ),

                    if (c.lawyerName != null &&
                        c.lawyerName != 'Not Assigned') ...[
                      SizedBox(height: 0.5.h),
                      Row(
                        children: [
                          const Icon(
                            Icons.gavel_rounded,
                            color: AppColors.kGold,
                            size: 18,
                          ),
                          SizedBox(width: 2.w),
                          Expanded(
                            child: CustomText(
                              title:
                                  "Lawyer: ${c.lawyerName}${c.lawyerId != null ? ' (${c.lawyerId})' : ''}",
                              fontSize: 14.sp,
                              weight: FontWeight.w600,
                              color: AppColors.kGoldLight,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                    SizedBox(height: 3.h),

                    // ── Case Details Section ──
                    CustomText(
                      title: "Case Details",
                      fontSize: 17.sp,
                      weight: FontWeight.w700,
                      color: AppColors.kEmerald,
                    ),
                    SizedBox(height: 1.5.h),

                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.kInputBg.withValues(alpha: 0.85),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppColors.kEmerald.withValues(alpha: 0.2),
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Table(
                          border: TableBorder.all(
                            color: AppColors.kEmerald.withValues(alpha: 0.12),
                            width: 1,
                          ),
                          columnWidths: const {
                            0: IntrinsicColumnWidth(),
                            1: FlexColumnWidth(),
                          },
                          children: [
                            _tableRow("Case ID", c.caseNo, isHeader: true),
                            _tableRow("Court", c.court),
                            _tableRow("Status", c.status),
                            _tableRow(
                              "Appointment",
                              _formatDate(c.hearingDate),
                              valueColor: AppColors.kEmerald,
                            ),
                            if (c.nextHearing != null)
                              _tableRow(
                                "Next Hearing",
                                _formatDate(c.nextHearing),
                                valueColor: AppColors.kGold,
                              ),
                            _tableRow(
                              "Category",
                              c.category,
                              valueColor:
                                  c.category.toLowerCase().contains('criminal')
                                  ? Colors.redAccent
                                  : AppColors.kEmerald,
                            ),
                            if (c.submissionMethod != null)
                              _tableRow("Submission", c.submissionMethod!),
                            if (c.appointmentType != null)
                              _tableRow("Appt. Type", c.appointmentType!),
                            _tableRow("Advocate", (c.advocate != null && c.advocate!.trim().isNotEmpty) ? c.advocate! : 'Not Assigned'),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 3.h),

                    // ── Notes Section ──
                    CustomText(
                      title: "Notes",
                      fontSize: 17.sp,
                      weight: FontWeight.w700,
                      color: AppColors.kEmerald,
                    ),
                    SizedBox(height: 1.5.h),

                    c.notes.isEmpty
                        ? Container(
                            padding: EdgeInsets.symmetric(
                              vertical: 2.5.h,
                              horizontal: 5.w,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.kInputBg.withValues(alpha: 0.6),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: AppColors.kEmerald.withValues(
                                  alpha: 0.15,
                                ),
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.notes_rounded,
                                  color: AppColors.kEmerald.withValues(
                                    alpha: 0.5,
                                  ),
                                  size: 22,
                                ),
                                SizedBox(width: 3.w),
                                Expanded(
                                  child: CustomText(
                                    title: "No notes added yet",
                                    color: AppColors.kTextSecondary,
                                    fontSize: 14.sp,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Column(
                            children: c.notes.asMap().entries.map((entry) {
                              final idx = entry.key;
                              final note = entry.value;
                              return Container(
                                margin: EdgeInsets.only(
                                  bottom: idx < c.notes.length - 1 ? 1.5.h : 0,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.kInputBg.withValues(
                                    alpha: 0.85,
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: AppColors.kEmerald.withValues(
                                      alpha: 0.2,
                                    ),
                                  ),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: Table(
                                    border: TableBorder.all(
                                      color: AppColors.kEmerald.withValues(
                                        alpha: 0.12,
                                      ),
                                      width: 1,
                                    ),
                                    columnWidths: const {
                                      0: IntrinsicColumnWidth(),
                                      1: FlexColumnWidth(),
                                    },
                                    children: [
                                      _tableRow(
                                        "Note #${idx + 1}",
                                        'Created By: ${note.createdBy ?? "System"}',
                                        isHeader: true,
                                      ),
                                      if (note.createdOn != null)
                                        _tableRow(
                                          "Date",
                                          _formatDate(note.createdOn),
                                        ),
                                      _tableRow("Note", note.notes),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          ),

                    SizedBox(height: 4.h),

                    // Close Button
                    CustomButton(
                      text: "Close",
                      onPressed: () => context.pop(),
                      gradient: const LinearGradient(
                        colors: [AppColors.kEmerald, AppColors.kEmeraldDark],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      textColor: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      borderRadius: 16,
                    ),
                  ],
                ),
              ),
            ],
          ),
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
        color: isHeader ? AppColors.kEmerald.withValues(alpha: 0.12) : null,
      ),
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.4.h),
          child: CustomText(
            title: label,
            color: isHeader ? AppColors.kEmerald : AppColors.kTextSecondary,
            weight: isHeader ? FontWeight.w700 : FontWeight.w500,
            fontSize: 13.sp,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.4.h),
          child: CustomText(
            title: value,
            color: valueColor ?? AppColors.kTextPrimary,
            weight: FontWeight.w600,
            fontSize: 13.sp,
            maxLines: 3,
          ),
        ),
      ],
    );
  }

  // ------------------------------------------------------------------
  // Build
  // ------------------------------------------------------------------
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
              color: AppColors.kEmerald.withValues(alpha: 0.6),
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

        // Year shown on badge from hearing date
        final yearLabel = _yearOnly(c.hearingDate);

        // Short label for the hearing chip
        final hearingLabel = c.hearingDate != null
            ? DateFormat('dd MMM yyyy').format(
                DateTime.tryParse(c.hearingDate!)?.toLocal() ?? DateTime.now(),
              )
            : 'TBD';

        return Padding(
          padding: EdgeInsets.only(bottom: 2.2.h),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.kSurface.withValues(alpha: 0.92),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.kEmerald.withValues(alpha: 0.18),
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.35),
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
                        // Year badge
                        Container(
                          width: 6.h,
                          height: 6.h,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
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
                                color: AppColors.kEmerald.withValues(
                                  alpha: 0.35,
                                ),
                                blurRadius: 16,
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              yearLabel,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13.sp,
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
                                fontSize: 14.sp,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 1.h),

                              // Hearing date chip
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 3.w,
                                  vertical: 0.7.h,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.kEmerald.withValues(
                                    alpha: 0.12,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.access_time_rounded,
                                      size: 2.h,
                                      color: AppColors.kEmerald,
                                    ),
                                    SizedBox(width: 1.5.w),
                                    Text(
                                      "Next: $hearingLabel",
                                      style: TextStyle(
                                        color: AppColors.kEmerald,
                                        fontSize: 12.5.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
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
                                    .withValues(alpha: 0.15),
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
                            fontSize: 13.sp,
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
