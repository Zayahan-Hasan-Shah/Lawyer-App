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
  void _showSnackBar(String message, {bool isError = true}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red.shade700 : Colors.green.shade700,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
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
        // 5MB limit
        validFiles.add(file);
      } else {
        _showSnackBar("Image '${xFile.name}' exceeds 5MB limit");
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
      allowedExtensions: [
        'pdf',
        'doc',
        'docx',
        'xls',
        'xlsx',
        'png',
        'jpg',
        'jpeg',
      ],
    );

    if (result == null) return;

    List<File> validFiles = [];
    for (var pf in result.files) {
      if (pf.path != null) {
        final file = File(pf.path!);
        if (file.lengthSync() <= 5 * 1024 * 1024) {
          validFiles.add(file);
        } else {
          _showSnackBar("${pf.name} exceeds 5MB limit");
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Upload area title
        CustomText(
          title: "Upload Case Documents",
          fontSize: 20.sp,
          weight: FontWeight.w700,
          color: AppColors.kTextPrimary,
        ),
        SizedBox(height: 0.8.h),
        CustomText(
          title: "Supported formats: PDF, Word, Excel, Images (Max 5MB each)",
          fontSize: 14.sp,
          color: AppColors.kTextSecondary,
        ),
        SizedBox(height: 3.h),

        // Upload drop zone / file list
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(5.w),
          decoration: BoxDecoration(
            color: AppColors.kSurface.withOpacity(0.92),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppColors.kEmerald.withOpacity(0.25),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: widget.selectedFiles.isEmpty
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.all(5.w),
                      decoration: BoxDecoration(
                        color: AppColors.kEmerald.withOpacity(0.12),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.cloud_upload_rounded,
                        size: 60,
                        color: AppColors.kEmerald,
                      ),
                    ),
                    SizedBox(height: 2.5.h),
                    CustomText(
                      title: "Drag & drop or tap to upload",
                      fontSize: 17.sp,
                      weight: FontWeight.w600,
                      color: AppColors.kTextPrimary,
                    ),
                    SizedBox(height: 1.h),
                    CustomText(
                      title: "PDF, DOC, XLS, PNG, JPG (Max 5MB per file)",
                      fontSize: 13.5.sp,
                      color: AppColors.kTextSecondary,
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
                    final isImage = [
                      '.png',
                      '.jpg',
                      '.jpeg',
                    ].any((ext) => fileName.toLowerCase().endsWith(ext));

                    return Container(
                      margin: EdgeInsets.only(bottom: 1.8.h),
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
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.kEmerald.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              isImage
                                  ? Icons.image_rounded
                                  : Icons.description_rounded,
                              color: AppColors.kEmerald,
                              size: 28,
                            ),
                          ),
                          SizedBox(width: 4.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText(
                                  title: fileName,
                                  fontSize: 15.sp,
                                  color: AppColors.kTextPrimary,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 0.4.h),
                                Text(
                                  "${(file.lengthSync() / 1024 / 1024).toStringAsFixed(1)} MB • ${isImage ? 'Image' : 'Document'}",
                                  style: TextStyle(
                                    color: AppColors.kTextSecondary,
                                    fontSize: 12.5.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.close_rounded,
                              color: Colors.redAccent,
                              size: 26,
                            ),
                            onPressed: () {
                              final newList = List<File>.from(
                                widget.selectedFiles,
                              )..removeAt(i);
                              widget.onFilesChanged(newList);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),

        SizedBox(height: 4.5.h),

        // Action Buttons
        Row(
          children: [
            Expanded(
              child: CustomButton(
                text: "Gallery",
                onPressed: _pickImageFromGallery,
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
            SizedBox(width: 3.w),
            Expanded(
              child: CustomButton(
                text: "Choose Files",
                onPressed: _pickFiles,
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

        if (widget.selectedFiles.isNotEmpty) ...[
          SizedBox(height: 4.h),
          SizedBox(
            width: double.infinity,
            height: 58,
            child: CustomButton(
              text: "Continue",
              onPressed: widget.onContinue,
              gradient: LinearGradient(
                colors: [AppColors.kEmerald, AppColors.kEmeraldDark],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              textColor: Colors.white,
              fontSize: 17.sp,
              fontWeight: FontWeight.w700,
              borderRadius: 16,
            ),
          ),
        ],
      ],
    );
  }
}
