import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:lawyer_app/src/core/constants/app_colors.dart';
import 'package:lawyer_app/src/models/student_model/internship_model/internship_model.dart';
import 'package:lawyer_app/src/widgets/common_widgets/custom_button.dart';
import 'package:lawyer_app/src/widgets/common_widgets/custom_text.dart';
import 'package:sizer/sizer.dart';

class InternshipDetailScreen extends StatefulWidget {
  final InternshipModel internship;

  const InternshipDetailScreen({super.key, required this.internship});

  @override
  State<InternshipDetailScreen> createState() => _InternshipDetailScreenState();
}

class _InternshipDetailScreenState extends State<InternshipDetailScreen> {
  String? _cvFilePath;

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
          widget.internship.title,
          style: TextStyle(
            color: AppColors.kTextPrimary,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0D1117),
              Color(0xFF0A1F24),
              Color(0xFF08151A),
            ],
            stops: [0.0, 0.6, 1.0],
          ),
        ),
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
                            Icons.business_center,
                            color: AppColors.kEmerald,
                            size: 8.w,
                          ),
                        ),
                        SizedBox(width: 3.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                title: widget.internship.title,
                                fontSize: 20.sp,
                                weight: FontWeight.w700,
                                color: AppColors.kTextPrimary,
                              ),
                              CustomText(
                                title: widget.internship.company,
                                fontSize: 16.sp,
                                weight: FontWeight.w600,
                                color: AppColors.kEmerald,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 3.h),
                    _buildDetailRow("Location", widget.internship.location, Icons.location_on),
                    _buildDetailRow("Duration", widget.internship.duration, Icons.schedule),
                    _buildDetailRow("Stipend", widget.internship.stipend, Icons.attach_money),
                    _buildDetailRow("Posted Date", widget.internship.postedDate, Icons.calendar_today),
                  ],
                ),
              ),
              SizedBox(height: 3.h),

              // Description
              _buildSectionCard("Description", Icons.description, [
                CustomText(
                  title: widget.internship.description,
                  fontSize: 14.sp,
                  color: AppColors.kTextSecondary,
                ),
              ]),
              SizedBox(height: 2.h),

              // Requirements
              _buildSectionCard("Requirements", Icons.list, [
                ...widget.internship.requirements.map((requirement) => Padding(
                  padding: EdgeInsets.only(bottom: 1.h),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.check_circle_outline,
                        color: AppColors.kEmerald,
                        size: 16,
                      ),
                      SizedBox(width: 2.w),
                      Expanded(
                        child: CustomText(
                          title: requirement,
                          fontSize: 14.sp,
                          color: AppColors.kTextSecondary,
                        ),
                      ),
                    ],
                  ),
                )),
              ]),
              SizedBox(height: 3.h),

              // CV Upload Section
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
                    color: AppColors.kEmerald.withValues(alpha:0.3),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.upload_file, color: AppColors.kEmerald, size: 6.w),
                        SizedBox(width: 2.w),
                        CustomText(
                          title: "Upload CV",
                          fontSize: 16.sp,
                          weight: FontWeight.w600,
                          color: AppColors.kTextPrimary,
                        ),
                      ],
                    ),
                    SizedBox(height: 2.h),
                    if (_cvFilePath != null) ...[
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(3.w),
                        decoration: BoxDecoration(
                          color: AppColors.kEmerald.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.kEmerald.withValues(alpha: 0.3)),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.description, color: AppColors.kEmerald, size: 20),
                            SizedBox(width: 2.w),
                            Expanded(
                              child: CustomText(
                                title: _cvFilePath!.split('/').last,
                                fontSize: 12.sp,
                                color: AppColors.kTextPrimary,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  _cvFilePath = null;
                                });
                              },
                              icon: Icon(Icons.close, color: Colors.redAccent, size: 20),
                            ),
                          ],
                        ),
                      ),
                    ] else ...[
                      CustomButton(
                        text: "Choose CV File",
                        onPressed: _pickCVFile,
                        fontSize: 14.sp,
                        textColor: Colors.white,
                        backgroundColor: AppColors.kEmerald,
                      ),
                    ],
                  ],
                ),
              ),
              SizedBox(height: 3.h),

              // Apply Button
              Container(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _cvFilePath != null ? _applyForInternship : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _cvFilePath != null ? AppColors.kEmerald : Colors.grey,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    "Apply for Internship",
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 5.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, IconData icon) {
    return Padding(
      padding: EdgeInsets.only(bottom: 1.5.h),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppColors.kEmerald),
          SizedBox(width: 2.w),
          CustomText(
            title: "$label:",
            fontSize: 14.sp,
            color: AppColors.kTextSecondary,
            weight: FontWeight.w500,
          ),
          SizedBox(width: 2.w),
          Expanded(
            child: CustomText(
              title: value,
              fontSize: 14.sp,
              weight: FontWeight.w600,
              color: AppColors.kTextPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard(String title, IconData icon, List<Widget> children) {
    return Container(
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
              Icon(icon, color: AppColors.kEmerald, size: 6.w),
              SizedBox(width: 2.w),
              CustomText(
                title: title,
                fontSize: 16.sp,
                weight: FontWeight.w600,
                color: AppColors.kTextPrimary,
              ),
            ],
          ),
          SizedBox(height: 2.h),
          ...children,
        ],
      ),
    );
  }

  Future<void> _pickCVFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx'],
      );

      if (result != null && result.files.single.path != null) {
        setState(() {
          _cvFilePath = result.files.single.path;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error picking file: $e'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  void _applyForInternship() {
    // Show confirmation dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.kSurface.withOpacity(0.96),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(
          'Apply for Internship',
          style: TextStyle(
            color: AppColors.kTextPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        content: Text(
          'Are you sure you want to apply for ${widget.internship.title} at ${widget.internship.company}?',
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
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Show success message
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Application submitted successfully!'),
                  backgroundColor: AppColors.kEmerald,
                ),
              );
              // Navigate back
              Navigator.pop(context);
            },
            child: Text(
              'Apply',
              style: TextStyle(color: AppColors.kEmerald),
            ),
          ),
        ],
      ),
    );
  }
}
