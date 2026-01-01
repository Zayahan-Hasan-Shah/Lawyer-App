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

  Widget _reviewItem(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.5.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 35.w,
            child: CustomText(title: "$label:", color: AppColors.brightYellowColor, fontSize: 14.sp, weight: FontWeight.w600),
          ),
          Expanded(child: CustomText(title: value, color: AppColors.whiteColor, fontSize: 14.sp)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5.w),
      decoration: BoxDecoration(
        color: AppColors.inputBackgroundColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.brightYellowColor.withOpacity(0.2), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(gradient: AppColors.buttonGradientColor, shape: BoxShape.circle),
                child: Icon(Icons.assignment_outlined, color: AppColors.blackColor, size: 24.sp),
              ),
              SizedBox(width: 3.w),
              CustomText(title: "Review Your Application", fontSize: 18.sp, weight: FontWeight.bold, color: AppColors.whiteColor),
            ],
          ),
          SizedBox(height: 3.h),
          _reviewItem("Category", category ?? "Not selected"),
          _reviewItem("Method", method == "upload" ? "Document Upload" : "Continue via WhatsApp"),
          if (method == "upload") ...[
            _reviewItem("Documents Attached", files.isEmpty ? "No documents attached" : "${files.length} file(s)"),
            if (files.isNotEmpty)
              Padding(
                padding: EdgeInsets.only(left: 8.w, top: 1.h, bottom: 2.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: files.map((f) {
                    final name = f.path.split(RegExp(r'[/\\]')).last;
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 0.5.h),
                      child: Row(
                        children: [
                          Icon(Icons.insert_drive_file, size: 16.sp, color: AppColors.brightYellowColor),
                          SizedBox(width: 2.w),
                          Expanded(
                            child: CustomText(
                              title: name,
                              fontSize: 13.sp,
                              color: AppColors.whiteColor.withOpacity(0.85),
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
          _reviewItem("Appointment Type", appointmentType == "video" ? "Video Call (Paid)" : "Walk-in Appointment"),
          if (appointmentType == "walkin" && date != null && time != null)
            _reviewItem("Date & Time", "${DateFormat('dd MMM yyyy').format(date!)} at ${time!.format(context)}"),
          if (appointmentType == "video")
            Padding(
              padding: EdgeInsets.only(left: 8.w, top: 1.h),
              child: Row(
                children: [
                  Icon(Icons.info_outline, size: 16.sp, color: AppColors.brightYellowColor),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: CustomText(
                      title: "Payment required before call",
                      fontSize: 13.sp,
                      color: AppColors.lightDescriptionTextColor,
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