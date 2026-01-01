import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lawyer_app/src/core/constants/app_colors.dart';
import 'package:lawyer_app/src/widgets/common_widgets/custom_button.dart';
import 'package:lawyer_app/src/widgets/common_widgets/custom_text.dart';
import 'package:sizer/sizer.dart';

class UploadStep extends StatefulWidget {
  final List<File> selectedFiles;
  final ValueChanged<List<File>> onFilesChanged;
  final VoidCallback onContinue;

  const UploadStep({
    super.key,
    required this.selectedFiles,
    required this.onFilesChanged,
    required this.onContinue,
  });

  @override
  State<UploadStep> createState() => _UploadStepState();
}

class _UploadStepState extends State<UploadStep> {
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red[700]),
    );
  }

  Future<void> _pickImageFromGallery() async {
    final picker = ImagePicker();
    final picked = await picker.pickMultiImage();
    if (picked.isEmpty) return;

    List<File> validFiles = [];
    for (var xFile in picked) {
      final file = File(xFile.path);
      if (await file.length() <= 5 * 1024 * 1024) {
        validFiles.add(file);
      } else {
        _showSnackBar("Image ${xFile.name} exceeds 5MB");
      }
    }
    if (validFiles.isNotEmpty) {
      widget.onFilesChanged([...widget.selectedFiles, ...validFiles]);
    }
  }

  Future<void> _pickFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx', 'xls', 'xlsx', 'png', 'jpg', 'jpeg'],
    );

    if (result == null) return;

    List<File> validFiles = [];
    for (var pf in result.files) {
      if (pf.path != null) {
        final file = File(pf.path!);
        if (file.lengthSync() <= 5 * 1024 * 1024) {
          validFiles.add(file);
        } else {
          _showSnackBar("${pf.name} exceeds 5MB");
        }
      }
    }
    if (validFiles.isNotEmpty) {
      widget.onFilesChanged([...widget.selectedFiles, ...validFiles]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Upload area / file list
        Container(
          padding: EdgeInsets.all(5.w),
          decoration: BoxDecoration(
            color: AppColors.inputBackgroundColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.brightYellowColor.withOpacity(0.2), width: 1.5),
          ),
          child: widget.selectedFiles.isEmpty
              ? Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(6.w),
                      decoration: BoxDecoration(color: AppColors.brightYellowColor.withOpacity(0.1), shape: BoxShape.circle),
                      child: Icon(Icons.cloud_upload_outlined, size: 60.sp, color: AppColors.brightYellowColor),
                    ),
                    SizedBox(height: 2.h),
                    CustomText(title: "Upload your documents", fontSize: 18.sp, weight: FontWeight.w600, color: AppColors.whiteColor),
                    SizedBox(height: 1.h),
                    CustomText(
                      title: "Images, PDF, Word, Excel (Max 5MB each)",
                      fontSize: 12.sp,
                      color: AppColors.lightDescriptionTextColor,
                      alignText: TextAlign.center,
                    ),
                  ],
                )
              : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: widget.selectedFiles.length,
                  itemBuilder: (_, i) {
                    final file = widget.selectedFiles[i];
                    final fileName = file.path.split(RegExp(r'[/\\]')).last;
                    final isImage = ['.png', '.jpg', '.jpeg'].any((ext) => fileName.toLowerCase().endsWith(ext));
                    return Container(
                      margin: EdgeInsets.only(bottom: 2.h),
                      padding: EdgeInsets.all(3.w),
                      decoration: BoxDecoration(color: AppColors.backgroundColor, borderRadius: BorderRadius.circular(12)),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(2.w),
                            decoration: BoxDecoration(color: AppColors.brightYellowColor.withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
                            child: Icon(isImage ? Icons.image : Icons.description, color: AppColors.brightYellowColor, size: 24.sp),
                          ),
                          SizedBox(width: 3.w),
                          Expanded(child: CustomText(title: fileName, fontSize: 14.sp, color: AppColors.whiteColor, maxLines: 2, overflow: TextOverflow.ellipsis)),
                          IconButton(
                            icon: Icon(Icons.close, color: Colors.red[400]),
                            onPressed: () {
                              final newList = List<File>.from(widget.selectedFiles)..removeAt(i);
                              widget.onFilesChanged(newList);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),
        SizedBox(height: 4.h),
        Row(
          children: [
            Expanded(
              child: CustomButton(
                text: "Gallery",
                onPressed: _pickImageFromGallery,
                gradient: AppColors.buttonGradientColor,
                textColor: AppColors.blackColor,
                fontSize: 16.sp,
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: CustomButton(
                text: "Files",
                onPressed: _pickFiles,
                backgroundColor: AppColors.inputBackgroundColor,
                textColor: AppColors.whiteColor,
                fontSize: 16.sp,
              ),
            ),
          ],
        ),
        if (widget.selectedFiles.isNotEmpty) ...[
          SizedBox(height: 3.h),
          CustomButton(
            text: "Continue",
            onPressed: widget.onContinue,
            gradient: AppColors.buttonGradientColor,
            textColor: AppColors.blackColor,
            fontSize: 18.sp,
          ),
        ],
      ],
    );
  }
}