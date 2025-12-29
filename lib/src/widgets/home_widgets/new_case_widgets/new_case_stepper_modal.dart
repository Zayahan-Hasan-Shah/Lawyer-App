import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lawyer_app/src/core/constants/app_colors.dart';
import 'package:lawyer_app/src/providers/client_provider/case_category_provider/case_category_provider.dart';
import 'package:lawyer_app/src/providers/new_case_provider/new_case_provider.dart';
import 'package:lawyer_app/src/states/category_state/category_state.dart';
import 'package:lawyer_app/src/widgets/common_widgets/custom_button.dart';
import 'package:lawyer_app/src/widgets/common_widgets/custom_dialog.dart';
import 'package:lawyer_app/src/widgets/common_widgets/custom_text.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:image_picker/image_picker.dart';
import 'package:table_calendar/table_calendar.dart';

class NewCaseStepperModal extends ConsumerStatefulWidget {
  const NewCaseStepperModal({super.key});

  @override
  ConsumerState<NewCaseStepperModal> createState() =>
      _NewCaseStepperModalState();
}

class _NewCaseStepperModalState extends ConsumerState<NewCaseStepperModal> {
  int currentStep = 0;
  String? selectedCategory;
  String? selectedMethod;
  List<File> selectedFiles = [];
  String? appointmentType;
  DateTime? selectedAppointmentDate;
  TimeOfDay? selectedAppointmentTime;

  final List<String> steps = [
    "Select Category",
    "Choose Method",
    "Upload / WhatsApp",
    "Appointment Type",
    "Review & Submit",
  ];

  @override
  Widget build(BuildContext context) {
    final categoryState = ref.watch(caseCategoryProvider);

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.9,
      minChildSize: 0.6,
      maxChildSize: 0.95,
      builder: (context, scrollController) => Container(
        decoration: const BoxDecoration(
          color: AppColors.backgroundColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Column(
          children: [
            // Fixed Header (unchanged — perfect)
            Container(
              padding: EdgeInsets.fromLTRB(5.w, 2.h, 5.w, 2.h),
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 2.h),
                    width: 15.w,
                    height: 5,
                    decoration: BoxDecoration(
                      color: AppColors.pastelYellowColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  SizedBox(height: 2.h),
                  CustomText(
                    title: "New Case Application",
                    fontSize: 22.sp,
                    weight: FontWeight.bold,
                    color: AppColors.whiteColor,
                  ),
                  SizedBox(height: 1.h),
                  CustomText(
                    title: "Step ${currentStep + 1} of ${steps.length}",
                    color: AppColors.lightDescriptionTextColor,
                  ),
                  SizedBox(height: 2.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      steps.length,
                      (i) => Container(
                        margin: EdgeInsets.symmetric(horizontal: 1.w),
                        width: currentStep == i ? 12 : 8,
                        height: currentStep == i ? 12 : 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: currentStep >= i
                              ? AppColors.brightYellowColor
                              : AppColors.hintTextColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Scrollable Content
            Expanded(
              child: CustomScrollView(
                controller: scrollController,
                slivers: [
                  SliverPadding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 5.w,
                      vertical: 2.h,
                    ),
                    sliver: SliverToBoxAdapter(
                      child: _buildStepContent(categoryState),
                    ),
                  ),
                ],
              ),
            ),

            // Fixed Bottom Buttons
            Padding(
              padding: EdgeInsets.all(5.w),
              child: Row(
                children: [
                  if (currentStep > 0)
                    Expanded(
                      child: CustomButton(
                        text: "Back",
                        onPressed: () => setState(() => currentStep--),
                        backgroundColor: AppColors.inputBackgroundColor,
                        textColor: AppColors.whiteColor,
                      ),
                    ),
                  if (currentStep > 0) SizedBox(width: 3.w),
                  Expanded(
                    child: CustomButton(
                      text: currentStep == steps.length - 1 ? "Submit" : "Next",
                      onPressed: _canProceed() ? _nextStep : null,
                      gradient: AppColors.buttonGradientColor,
                      textColor: AppColors.blackColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepContent(CategoryState state) {
    switch (currentStep) {
      case 0:
        return _buildCategoryStep(state);
      case 1:
        return _buildMethodStep();
      case 2:
        return selectedMethod == "upload"
            ? _buildUploadStep()
            : _buildWhatsAppStep();
      case 3:
        return _buildAppointmentStep();
      case 4:
        return _buildReviewStep();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildCategoryStep(CategoryState state) {
    return state.when(
      loading: () => const Center(
        child: CircularProgressIndicator(color: AppColors.brightYellowColor),
      ),
      failure: (error) => Center(
        child: Text(error, style: const TextStyle(color: Colors.red)),
      ),
      success: (categories) => ListView.builder(
        itemCount: categories.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (_, i) {
          final cat = categories[i];
          final isSelected = selectedCategory == cat.category;
          return GestureDetector(
            onTap: () => setState(() => selectedCategory = cat.category),
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 1.h),
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.brightYellowColor.withOpacity(0.2)
                    : AppColors.inputBackgroundColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected
                      ? AppColors.brightYellowColor
                      : Colors.transparent,
                ),
              ),
              child: Row(
                children: [
                  Radio<String>(
                    value: cat.category,
                    groupValue: selectedCategory,
                    onChanged: (val) => setState(() => selectedCategory = val),
                    activeColor: AppColors.brightYellowColor,
                  ),
                  CustomText(
                    title: cat.category,
                    color: AppColors.whiteColor,
                    fontSize: 18.sp,
                  ),
                ],
              ),
            ),
          );
        },
      ),
      initial: () => const Center(
        child: Text(
          "Loading categories...",
          style: TextStyle(color: AppColors.lightDescriptionTextColor),
        ),
      ),
    );
  }

  Widget _buildMethodStep() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _methodCard("Upload Document", Icons.upload_file, "upload"),
        SizedBox(height: 3.h),
        _methodCard("Continue via WhatsApp", Icons.message, "whatsapp"),
      ],
    );
  }

  Widget _methodCard(String title, IconData icon, String value) {
    final isSelected = selectedMethod == value;
    return GestureDetector(
      onTap: () => setState(() => selectedMethod = value),
      child: Container(
        padding: EdgeInsets.all(5.w),
        decoration: BoxDecoration(
          gradient: isSelected ? AppColors.buttonGradientColor : null,
          color: isSelected ? null : AppColors.inputBackgroundColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppColors.brightYellowColor.withOpacity(0.5),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 40,
              color: isSelected
                  ? AppColors.blackColor
                  : AppColors.brightYellowColor,
            ),
            SizedBox(width: 4.w),
            CustomText(
              title: title,
              color: isSelected ? AppColors.blackColor : AppColors.whiteColor,
              fontSize: 18.sp,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUploadStep() {
    return Column(
      // Removed SingleChildScrollView — parent handles scrolling
      children: [
        if (selectedFiles.isEmpty)
          const Icon(
            Icons.description_outlined,
            size: 80,
            color: AppColors.hintTextColor,
          )
        else
          Container(
            constraints: BoxConstraints(maxHeight: 40.h), // Prevents overflow
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: AppColors.inputBackgroundColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: ListView.builder(
              shrinkWrap: true, // Important!
              physics:
                  const NeverScrollableScrollPhysics(), // Disable inner scroll
              itemCount: selectedFiles.length,
              itemBuilder: (context, index) {
                final file = selectedFiles[index];
                final fileName = file.path.split(RegExp(r'[/\\]')).last;
                final isImage = [
                  '.png',
                  '.jpg',
                  '.jpeg',
                ].any((ext) => fileName.toLowerCase().endsWith(ext));
                return ListTile(
                  leading: Icon(
                    isImage ? Icons.image : Icons.description,
                    color: AppColors.brightYellowColor,
                  ),
                  title: CustomText(
                    title: fileName,
                    fontSize: 14.sp,
                    color: AppColors.whiteColor,
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.remove_circle, color: Colors.red[400]),
                    onPressed: () =>
                        setState(() => selectedFiles.removeAt(index)),
                  ),
                );
              },
            ),
          ),

        SizedBox(height: 4.h),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CustomButton(
              text: "From Gallery",
              onPressed: _pickImageFromGallery,
              gradient: AppColors.buttonGradientColor,
              textColor: AppColors.blackColor,
              width: 40.w,
            ),
            CustomButton(
              text: "Pick Files",
              onPressed: _pickFiles,
              gradient: AppColors.buttonGradientColor,
              textColor: AppColors.blackColor,
              width: 40.w,
            ),
          ],
        ),

        SizedBox(height: 2.h),
        CustomText(
          title: "Supported: Images, PDF, Word, Excel (Max 5MB each)",
          fontSize: 12.sp,
          color: AppColors.lightDescriptionTextColor,
          alignText: TextAlign.center,
        ),
      ],
    );
  }

  Future<void> _pickImageFromGallery() async {
    final picker = ImagePicker();
    final picked = await picker.pickMultiImage();
    if (picked.isNotEmpty) {
      for (var xFile in picked) {
        final file = File(xFile.path);
        if (await file.length() <= 5 * 1024 * 1024) {
          setState(() => selectedFiles.add(file));
        } else {
          _showSnackBar("Image ${xFile.name} exceeds 5MB");
        }
      }
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

    if (result != null) {
      for (var platformFile in result.files) {
        if (platformFile.path != null) {
          final file = File(platformFile.path!);
          if (file.lengthSync() <= 5 * 1024 * 1024) {
            setState(() => selectedFiles.add(file));
          } else {
            _showSnackBar("${platformFile.name} exceeds 5MB");
          }
        }
      }
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  Widget _buildWhatsAppStep() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.message_rounded,
            size: 80,
            color: AppColors.brightYellowColor,
          ),
          SizedBox(height: 3.h),
          CustomText(
            title: "Continue case filing via WhatsApp",
            color: AppColors.whiteColor,
            fontSize: 18.sp,
            alignText: TextAlign.center,
          ),
          SizedBox(height: 2.h),
          CustomText(
            title: "Our team will guide you personally",
            color: AppColors.lightDescriptionTextColor,
            fontSize: 15.sp,
          ),
          SizedBox(height: 5.h),
          CustomButton(
            text: "Chat on WhatsApp",
            onPressed: () {
              _showSnackBar(
                "After you complete the form and tap Submit, we will open WhatsApp automatically.",
              );
            },
            gradient: AppColors.buttonGradientColor,
            textColor: AppColors.blackColor,
            fontSize: 18.sp,
          ),
        ],
      ),
    );
  }

  Widget _buildAppointmentStep() {
    return Column(
      children: [
        _appointmentCard("Video Call Appointment", Icons.videocam, "video"),
        SizedBox(height: 3.h),
        _appointmentCard("Walk-in Appointment", Icons.location_on, "walkin"),
        if (appointmentType == "walkin") ...[
          SizedBox(height: 3.h),
          _buildDateTimePicker(),
        ],
      ],
    );
  }

  Widget _appointmentCard(String title, IconData icon, String value) {
    final isSelected = appointmentType == value;
    return GestureDetector(
      onTap: () => setState(() => appointmentType = value),
      child: Container(
        padding: EdgeInsets.all(5.w),
        margin: EdgeInsets.symmetric(vertical: 1.h),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.brightYellowColor.withOpacity(0.2)
              : AppColors.inputBackgroundColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? AppColors.brightYellowColor
                : Colors.transparent,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 40,
              color: isSelected
                  ? AppColors.brightYellowColor
                  : AppColors.iconColor,
            ),
            SizedBox(width: 4.w),
            Expanded(
              child: CustomText(title: title, color: AppColors.whiteColor),
            ),
            if (value == "video")
              Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text("Paid", style: TextStyle(color: Colors.white)),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateTimePicker() {
    return Column(
      children: [
        Container(
          constraints: BoxConstraints(maxHeight: 48.h), // Responsive safety
          decoration: BoxDecoration(
            color: AppColors.inputBackgroundColor,
            borderRadius: BorderRadius.circular(16),
          ),
          padding: EdgeInsets.all(4.w),
          child: TableCalendar(
            // ... your calendar config (unchanged)
            firstDay: DateTime.now(),
            lastDay: DateTime.now().add(const Duration(days: 90)),
            focusedDay: selectedAppointmentDate ?? DateTime.now(),
            calendarFormat: CalendarFormat.month,
            availableCalendarFormats: const {CalendarFormat.month: 'Month'},
            selectedDayPredicate: (day) =>
                isSameDay(selectedAppointmentDate, day),
            enabledDayPredicate: (day) =>
                day.weekday != DateTime.saturday &&
                day.weekday != DateTime.sunday,
            onDaySelected: (selectedDay, focusedDay) {
              setState(() => selectedAppointmentDate = selectedDay);
            },
            headerStyle: HeaderStyle(
              titleCentered: true,
              formatButtonVisible: false,
              titleTextStyle: TextStyle(
                color: AppColors.whiteColor,
                fontSize: 18.sp,
              ),
              leftChevronIcon: Icon(
                Icons.chevron_left,
                color: AppColors.brightYellowColor,
              ),
              rightChevronIcon: Icon(
                Icons.chevron_right,
                color: AppColors.brightYellowColor,
              ),
            ),
            calendarStyle: CalendarStyle(
              selectedDecoration: BoxDecoration(
                color: AppColors.brightYellowColor,
                shape: BoxShape.circle,
              ),
              todayDecoration: BoxDecoration(
                color: AppColors.brightYellowColor.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              weekendTextStyle: TextStyle(color: Colors.red[300]),
              disabledTextStyle: TextStyle(color: Colors.grey[600]),
              defaultTextStyle: const TextStyle(color: Colors.white),
            ),
          ),
        ),

        SizedBox(height: 3.h),

        if (selectedAppointmentDate != null)
          Card(
            color: AppColors.inputBackgroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(
                horizontal: 5.w,
                vertical: 1.h,
              ),
              title: Text(
                selectedAppointmentTime == null
                    ? "Select Time (8:00 AM - 5:00 PM)"
                    : "Selected: ${selectedAppointmentTime!.format(context)}",
                style: TextStyle(color: AppColors.whiteColor, fontSize: 16.sp),
              ),
              trailing: Icon(
                Icons.access_time,
                color: AppColors.brightYellowColor,
              ),
              onTap: _pickRestrictedTime,
            ),
          ),
      ],
    );
  }

  Future<void> _pickRestrictedTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedAppointmentTime ?? TimeOfDay(hour: 9, minute: 0),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            primaryColor: AppColors.brightYellowColor,
            colorScheme: ColorScheme.dark(primary: AppColors.brightYellowColor),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      final hour = picked.hour;
      if (hour >= 8 && hour < 17) {
        setState(() => selectedAppointmentTime = picked);
      } else {
        _showSnackBar("Please select time between 8:00 AM and 5:00 PM");
      }
    }
  }

  Widget _buildReviewStep() {
    return Column(
      // Removed SingleChildScrollView
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _reviewItem("Category", selectedCategory ?? "Not selected"),
        _reviewItem(
          "Method",
          selectedMethod == "upload"
              ? "Document Upload"
              : "Continue via WhatsApp",
        ),

        if (selectedMethod == "upload" && selectedFiles.isNotEmpty) ...[
          _reviewItem("Documents Attached", "${selectedFiles.length} file(s)"),
          Padding(
            padding: EdgeInsets.only(left: 8.w, top: 1.h, bottom: 2.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: selectedFiles.map((file) {
                final fileName = file.path.split(RegExp(r'[/\\]')).last;
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 0.5.h),
                  child: Row(
                    children: [
                      Icon(
                        Icons.insert_drive_file,
                        size: 18.sp,
                        color: AppColors.brightYellowColor,
                      ),
                      SizedBox(width: 2.w),
                      Expanded(
                        child: CustomText(
                          title: fileName,
                          fontSize: 14.sp,
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

        if (selectedMethod == "upload" && selectedFiles.isEmpty)
          _reviewItem("Documents", "No documents attached"),

        _reviewItem(
          "Appointment Type",
          appointmentType == "video"
              ? "Video Call (Paid)"
              : "Walk-in Appointment",
        ),

        if (appointmentType == "walkin" &&
            selectedAppointmentDate != null &&
            selectedAppointmentTime != null)
          _reviewItem(
            "Date & Time",
            "${DateFormat('dd MMM yyyy').format(selectedAppointmentDate!)} at ${selectedAppointmentTime!.format(context)}",
          ),

        if (appointmentType == "video")
          Padding(
            padding: EdgeInsets.only(left: 30.w, top: 1.h),
            child: CustomText(
              title: "Payment required before call",
              fontSize: 13.sp,
              color: AppColors.lightDescriptionTextColor,
            ),
          ),

        SizedBox(height: 5.h),
        CustomButton(
          text: "Submit Application",
          onPressed: _submitApplication,
          gradient: AppColors.buttonGradientColor,
          textColor: AppColors.blackColor,
          width: double.infinity,
        ),
      ],
    );
  }

  Widget _reviewItem(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 30.w,
            child: CustomText(
              title: "$label:",
              color: AppColors.lightDescriptionTextColor,
            ),
          ),
          Expanded(
            child: CustomText(title: value, color: AppColors.whiteColor),
          ),
        ],
      ),
    );
  }

  bool _canProceed() {
    switch (currentStep) {
      case 0:
        return selectedCategory != null;
      case 1:
        return selectedMethod != null;
      case 2:
        return selectedMethod == "whatsapp" || selectedFiles.isNotEmpty;
      case 3:
        return appointmentType != null &&
            (appointmentType == "video" ||
                (selectedAppointmentDate != null &&
                    selectedAppointmentTime != null));
      default:
        return true;
    }
  }

  void _nextStep() {
    if (currentStep < steps.length - 1) {
      setState(() => currentStep++);
    } else {
      _submitApplication();
    }
  }

  void _submitApplication() async {
    if (mounted) context.pop();

    // Small delay for better UX
    await Future.delayed(const Duration(milliseconds: 400));

    try {
      await ref
          .read(newCaseProvider.notifier)
          .submitApplication(
            category: selectedCategory!,
            method: selectedMethod!,
            document: selectedFiles, // ← plural!
            appointmentType: appointmentType!,
            date: selectedAppointmentDate,
            time: selectedAppointmentTime,
          );

      if (selectedMethod == "whatsapp") {
        await _openWhatsAppChat();
      }

      if (!mounted) return;

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => CustomDialog(
          title: "Success!",
          description:
              "Your application has been submitted successfully! Our team will contact you shortly.",
          buttonText: "Great!",
          icon: Icons.check_circle,
          buttonGradient: AppColors.buttonGradientColor.colors,
          onPressed: () => context.pop(),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => CustomDialog(
          title: "Submission Failed",
          description: e.toString(),
          buttonText: "OK",
          icon: Icons.error_outline,
          buttonGradient: const [Color(0xFFFF6B6B), Color(0xFFC0392B)],
          onPressed: () => context.pop(),
        ),
      );
    }
  }

  Future<void> _openWhatsAppChat() async {
    final String phoneNumber = "923327699137";
    final String message = Uri.encodeComponent(
      "Hello, I want to file a new case regarding $selectedCategory matter. Please guide me.",
    );
    final Uri url = Uri.parse("https://wa.me/$phoneNumber?text=$message");

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      _showSnackBar(
        "WhatsApp is not installed on your device. Please install WhatsApp to continue via WhatsApp, or choose another submission method.",
      );
    }
  }
}
