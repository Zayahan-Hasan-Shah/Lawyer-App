import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lawyer_app/core/constants/app_colors.dart';
import 'package:lawyer_app/features/lawyer/domain/entities/lawyer_case_entity.dart';
import 'package:lawyer_app/shared/widgets/custom_button.dart';
import 'package:lawyer_app/shared/widgets/custom_text.dart';
import 'package:sizer/sizer.dart';

class DisposedLawyerCasesTab extends StatelessWidget {
  final List<LawyerCaseEntity> cases;

  const DisposedLawyerCasesTab({super.key, required this.cases});

  @override
  Widget build(BuildContext context) {
    if (cases.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle_outline_rounded,
              size: 80,
              color: AppColors.kEmerald,
            ),
            SizedBox(height: 2.h),
            Text(
              'No disposed cases yet',
              style: TextStyle(
                color: AppColors.kTextPrimary,
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              'Completed matters will appear here',
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
          padding: EdgeInsets.only(bottom: 2.4.h),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.kSurface.withOpacity(0.92),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.kEmerald.withOpacity(0.15)),
            ),
            child: InkWell(
              onTap: () => _showCaseDetails(context, c),
              borderRadius: BorderRadius.circular(20),
              child: Padding(
                padding: EdgeInsets.all(4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.kEmerald.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Icon(
                            Icons.gavel_rounded,
                            size: 3.h,
                            color: AppColors.kEmerald,
                          ),
                        ),
                        SizedBox(width: 4.w),

                        Expanded(
                          child: CustomText(
                            title: c.category,
                            color: AppColors.kEmerald,
                            fontSize: 16.sp,
                            weight: FontWeight.w700,
                          ),
                        ),

                        // Optional: small icon depending on category
                        if (c.category.toLowerCase().contains('criminal'))
                          Icon(
                            Icons.warning_amber_rounded,
                            color: AppColors.kEmerald,
                            size: 3.h,
                          )
                        else if (c.category.toLowerCase().contains('civil'))
                          Icon(
                            Icons.balance_rounded,
                            color: AppColors.kEmerald,
                            size: 3.h,
                          )
                        else
                          Icon(
                            Icons.circle_rounded,
                            color: AppColors.kTextSecondary,
                            size: 20,
                          ),
                      ],
                    ),

                    SizedBox(height: 2.h),

                    // Main content column
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
                      title: '${c.client} • ${c.court}',
                      color: AppColors.kTextSecondary,
                      fontSize: 14.5.sp,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    SizedBox(height: 0.5.h),

                    CustomText(
                      title: 'Disposed: ${c.disposedDate != null ? _formatDateOnly(c.disposedDate!) : '-'}',
                      color: AppColors.kEmerald.withOpacity(0.9),
                      fontSize: 15.sp,
                      weight: FontWeight.w600,
                    ),

                    if (c.outcomeSummary != null) ...[
                      SizedBox(height: 0.5.h),
                      CustomText(
                        title: c.outcomeSummary!,
                        color: AppColors.kTextSecondary,
                        fontSize: 14.sp,
                        textHeight: 1.4,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  static String _formatDate(String? raw) {
    if (raw == null || raw.trim().isEmpty) return '-';
    try {
      final dt = DateTime.parse(raw).toLocal();
      return DateFormat('dd MMM yyyy  •  hh:mm a').format(dt);
    } catch (_) {
      return raw;
    }
  }

  static String _formatDateOnly(String raw) {
    try {
      final dt = DateTime.parse(raw).toLocal();
      return DateFormat('dd MMM yyyy').format(dt);
    } catch (_) {
      return raw;
    }
  }

  static TableRow _tableRow(
    String label,
    String value, {
    bool isHeader = false,
    Color? valueColor,
    int? maxLines = 3,
  }) {
    return TableRow(
      decoration: BoxDecoration(
        color: isHeader ? AppColors.kEmerald.withOpacity(0.12) : null,
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
            maxLines: maxLines,
            overflow: maxLines != null ? TextOverflow.ellipsis : null,
          ),
        ),
      ],
    );
  }

  void _showCaseDetails(BuildContext context, LawyerCaseEntity c) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (a) => DraggableScrollableSheet(
        initialChildSize: 0.85,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (_, ctrl) => Container(
          decoration: BoxDecoration(
            color: AppColors.kSurface.withOpacity(0.97),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            border: Border.all(color: AppColors.kEmerald.withOpacity(0.18)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.45),
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
                  color: AppColors.kEmerald.withOpacity(0.35),
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
                          columnWidths: const {
                            0: IntrinsicColumnWidth(),
                            1: FlexColumnWidth(),
                          },
                          children: [
                            _tableRow("Case ID", c.caseNo, isHeader: true),
                            _tableRow("Court", c.court),
                            _tableRow("Status", c.status),
                            _tableRow(
                              "Category",
                              c.category,
                              valueColor: c.category.toLowerCase().contains('criminal')
                                  ? Colors.redAccent
                                  : AppColors.kEmerald,
                            ),
                            _tableRow(
                              "Disposed Date",
                              _formatDate(c.disposedDate),
                              valueColor: AppColors.kEmerald,
                            ),
                            if (c.outcomeSummary != null)
                              _tableRow("Outcome", c.outcomeSummary!),
                            _tableRow("Advocate", (c.advocate != null && c.advocate!.trim().isNotEmpty) ? c.advocate! : 'Not Assigned'),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 3.h),

                    // ── Documents Section ──
                    CustomText(
                      title: "Documents",
                      fontSize: 17.sp,
                      weight: FontWeight.w700,
                      color: AppColors.kEmerald,
                    ),
                    SizedBox(height: 1.5.h),

                    c.documents.isEmpty
                        ? Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 2.h, horizontal: 4.w),
                            decoration: BoxDecoration(
                              color: AppColors.kInputBg.withOpacity(0.6),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                  color: AppColors.kEmerald
                                      .withOpacity(0.15)),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.description_rounded,
                                  color: AppColors.kEmerald
                                      .withOpacity(0.5),
                                  size: 22,
                                ),
                                SizedBox(width: 3.w),
                                Expanded(
                                  child: CustomText(
                                    title: "No documents uploaded",
                                    color: AppColors.kTextSecondary,
                                    fontSize: 14.sp,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Column(
                            children: c.documents.map((doc) {
                              return Padding(
                                padding: EdgeInsets.only(bottom: 1.2.h),
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
                              );
                            }).toList(),
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
                                vertical: 2.5.h, horizontal: 5.w),
                            decoration: BoxDecoration(
                              color: AppColors.kInputBg.withOpacity(0.6),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                  color: AppColors.kEmerald
                                      .withOpacity(0.15)),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.notes_rounded,
                                  color: AppColors.kEmerald
                                      .withOpacity(0.5),
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
                                margin: EdgeInsets.only(bottom: idx < c.notes.length - 1 ? 1.5.h : 0),
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
                                    columnWidths: const {
                                      0: IntrinsicColumnWidth(),
                                      1: FlexColumnWidth(),
                                    },
                                    children: [
                                      _tableRow("Note #${idx + 1}", note.createdBy ?? "System", isHeader: true),
                                      if (note.createdOn != null)
                                        _tableRow("Date", _formatDate(note.createdOn)),
                                      _tableRow("Note", note.notes, maxLines: null),
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
                      onPressed: () => Navigator.pop(context),
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
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
