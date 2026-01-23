import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lawyer_app/src/core/constants/app_colors.dart';
import 'package:lawyer_app/src/widgets/common_widgets/custom_text.dart';
import 'package:sizer/sizer.dart';

class ReviewStep extends StatelessWidget {
  final String? category;
  final String? method;
  final List<File> files;
  final String? appointmentType;
  final DateTime? date;
  final TimeOfDay? time;

  const ReviewStep({
    super.key,
    required this.category,
    required this.method,
    required this.files,
    required this.appointmentType,
    this.date,
    this.time,
  });

  Widget _reviewItem({
    required String label,
    required String value,
    Color? valueColor,
    Widget? trailing,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 38.w,
            child: CustomText(
              title: label,
              fontSize: 15.sp,
              weight: FontWeight.w600,
              color: AppColors.kTextSecondary,
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: CustomText(
                    title: value,
                    fontSize: 15.sp,
                    weight: FontWeight.w600,
                    color: valueColor ?? AppColors.kTextPrimary,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (trailing != null) trailing,
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final formattedDateTime = date != null && time != null
        ? "${DateFormat('dd MMM yyyy').format(date!)} at ${time!.format(context)}"
        : "Not selected";

    return Container(
      padding: EdgeInsets.all(2.5.w),
      decoration: BoxDecoration(
        color: AppColors.kSurface.withOpacity(0.92),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColors.kEmerald.withOpacity(0.18),
          width: 0.5.w,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.35),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
          BoxShadow(
            color: AppColors.kEmerald.withOpacity(0.08),
            blurRadius: 40,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.kEmerald.withOpacity(0.35),
                      AppColors.kEmeraldDark.withOpacity(0.15),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  Icons.assignment_turned_in_rounded,
                  color: Colors.white,
                  size: 4.h,
                ),
              ),
              SizedBox(width: 4.w),
              CustomText(
                title: "Review Your Application",
                fontSize: 18.sp,
                weight: FontWeight.w800,
                color: AppColors.kTextPrimary,
              ),
            ],
          ),

          SizedBox(height: 3.5.h),
          Divider(color: AppColors.kEmerald.withOpacity(0.15), height: 1),

          SizedBox(height: 3.h),

          // Review items
          _reviewItem(
            label: "Case Category",
            value: category ?? "Not selected",
            valueColor: category != null ? AppColors.kEmerald : null,
          ),

          _reviewItem(
            label: "Submission Method",
            value: method == "upload" ? "Document Upload" : "WhatsApp Chat",
            valueColor: method != null ? AppColors.kEmerald : null,
          ),

          if (method == "upload") ...[
            _reviewItem(
              label: "Documents Attached",
              value: files.isEmpty ? "No documents" : "${files.length} file(s)",
              valueColor: files.isNotEmpty ? AppColors.kEmerald : null,
            ),

            if (files.isNotEmpty)
              Padding(
                padding: EdgeInsets.only(left: 38.w, top: 0.8.h, bottom: 2.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: files.map((f) {
                    final name = f.path.split(RegExp(r'[/\\]')).last;
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 0.6.h),
                      child: Row(
                        children: [
                          Icon(
                            Icons.insert_drive_file_rounded,
                            size: 18,
                            color: AppColors.kEmerald,
                          ),
                          SizedBox(width: 2.5.w),
                          Expanded(
                            child: Text(
                              name,
                              style: TextStyle(
                                color: AppColors.kTextPrimary,
                                fontSize: 14.sp,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
          ],

          _reviewItem(
            label: "Appointment Type",
            value: appointmentType == "video"
                ? "Video Call (Paid)"
                : "Walk-in Appointment",
            valueColor: appointmentType != null ? AppColors.kEmerald : null,
          ),

          if (appointmentType == "walkin")
            _reviewItem(
              label: "Preferred Date & Time",
              value: formattedDateTime,
              valueColor: (date != null && time != null)
                  ? AppColors.kEmerald
                  : null,
            ),

          if (appointmentType == "video")
            Padding(
              padding: EdgeInsets.only(left: 38.w, top: 1.h),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    size: 20,
                    color: AppColors.kEmerald,
                  ),
                  SizedBox(width: 2.5.w),
                  Expanded(
                    child: CustomText(
                      title: "Payment required before scheduling video call",
                      fontSize: 13.8.sp,
                      color: AppColors.kTextSecondary,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}