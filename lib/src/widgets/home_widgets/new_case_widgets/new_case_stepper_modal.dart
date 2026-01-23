import 'dart:developer';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lawyer_app/src/core/constants/app_colors.dart';
import 'package:lawyer_app/src/providers/client_provider/case_category_provider/case_category_provider.dart';
import 'package:lawyer_app/src/providers/client_provider/new_case_provider/new_case_provider.dart';
import 'package:lawyer_app/src/widgets/common_widgets/custom_button.dart';
import 'package:lawyer_app/src/widgets/common_widgets/custom_dialog.dart';
import 'package:lawyer_app/src/widgets/home_widgets/new_case_widgets/appointment_step.dart';
import 'package:lawyer_app/src/widgets/home_widgets/new_case_widgets/category_step.dart';
import 'package:lawyer_app/src/widgets/home_widgets/new_case_widgets/drag_handle.dart';
import 'package:lawyer_app/src/widgets/home_widgets/new_case_widgets/method_step.dart';
import 'package:lawyer_app/src/widgets/home_widgets/new_case_widgets/review_step.dart';
import 'package:lawyer_app/src/widgets/home_widgets/new_case_widgets/upload_step.dart';
import 'package:lawyer_app/src/widgets/home_widgets/new_case_widgets/whatsapp_step.dart';
import 'package:lawyer_app/src/widgets/home_widgets/new_case_widgets/stepper_header.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

class NewCaseStepperModal extends ConsumerStatefulWidget {
  const NewCaseStepperModal({super.key});

  @override
  ConsumerState<NewCaseStepperModal> createState() => _NewCaseStepperModalState();
}

class _NewCaseStepperModalState extends ConsumerState<NewCaseStepperModal>
    with SingleTickerProviderStateMixin {
  int currentStep = 0;

  String? selectedCategory;
  String? selectedMethod;
  List<File> selectedFiles = [];
  String? appointmentType;
  DateTime? selectedAppointmentDate;
  TimeOfDay? selectedAppointmentTime;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final List<String> steps = [
    "Select Category",
    "Choose Method",
    "Upload / WhatsApp",
    "Appointment Type",
    "Review & Submit",
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 420),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOutCubic),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _goToNext() {
    if (currentStep < steps.length - 1) {
      _animationController.reset();
      setState(() => currentStep++);
      _animationController.forward();
    }
  }

  void _goBack() {
    if (currentStep > 0) {
      _animationController.reset();
      setState(() => currentStep--);
      _animationController.forward();
    }
  }

  Widget _currentStepContent() {
    switch (currentStep) {
      case 0:
        return CategoryStep(
          state: ref.watch(caseCategoryProvider),
          selectedCategory: selectedCategory,
          onCategorySelected: (cat) {
            setState(() => selectedCategory = cat);
            Future.delayed(const Duration(milliseconds: 320), _goToNext);
          },
        );
      case 1:
        return MethodStep(
          selectedMethod: selectedMethod,
          onMethodSelected: (m) {
            setState(() => selectedMethod = m);
            Future.delayed(const Duration(milliseconds: 320), _goToNext);
          },
        );
      case 2:
        if (selectedMethod == "upload") {
          return UploadStep(
            selectedFiles: selectedFiles,
            onFilesChanged: (files) => setState(() => selectedFiles = files),
            onContinue: _goToNext,
          );
        }
        // WhatsApp auto-advances
        Future.delayed(const Duration(milliseconds: 600), () {
          if (mounted) _goToNext();
        });
        return const WhatsAppStep();
      case 3:
        return AppointmentStep(
          appointmentType: appointmentType,
          selectedDate: selectedAppointmentDate,
          selectedTime: selectedAppointmentTime,
          onTypeChanged: (type) => setState(() => appointmentType = type),
          onDateChanged: (date) => setState(() => selectedAppointmentDate = date),
          onTimeChanged: (time) => setState(() => selectedAppointmentTime = time),
          onConfirm: _goToNext,
        );
      case 4:
        return ReviewStep(
          category: selectedCategory,
          method: selectedMethod,
          files: selectedFiles,
          appointmentType: appointmentType,
          date: selectedAppointmentDate,
          time: selectedAppointmentTime,
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Future<void> _submitApplication() async {
    try {
      await ref.read(newCaseProvider.notifier).submitApplication(
            category: selectedCategory!,
            method: selectedMethod!,
            document: selectedFiles,
            appointmentType: appointmentType!,
            date: selectedAppointmentDate,
            time: selectedAppointmentTime,
          );

      if (selectedMethod == "whatsapp") await _openWhatsAppChat();

      if (!mounted) return;

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => CustomDialog(
          title: "Application Submitted!",
          description: appointmentType == "video"
              ? "Your video consultation request has been received. We'll send payment details and schedule your session shortly."
              : "Your case application has been successfully submitted. Our team will reach out soon.",
          buttonText: "Done",
          icon: Icons.check_circle_rounded,
          buttonGradient: const [Color(0xFF10B981), Color(0xFF059669)],
          onPressed: () {
            Navigator.pop(context); // close dialog
            Navigator.pop(context); // close bottom sheet
          },
        ),
      );
    } catch (e) {
      log("Submission error: $e");
      if (!mounted) return;

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => CustomDialog(
          title: "Submission Failed",
          description: e.toString().replaceAll('Exception: ', ''),
          buttonText: "OK",
          icon: Icons.error_outline_rounded,
          buttonGradient: const [Color(0xFFFF6B6B), Color(0xFFC0392B)],
          onPressed: () => Navigator.pop(context),
        ),
      );
    }
  }

  Future<void> _openWhatsAppChat() async {
    const phone = "923327699137";
    final message = Uri.encodeComponent(
      "Hello, I want to file a new case regarding $selectedCategory matter. Please guide me.",
    );
    final uri = Uri.parse("https://wa.me/$phone?text=$message");
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.92,
      minChildSize: 0.65,
      maxChildSize: 0.96,
      builder: (_, scrollController) => Container(
        decoration: BoxDecoration(
          color: AppColors.kSurface.withOpacity(0.94),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          border: Border.all(color: AppColors.kEmerald.withOpacity(0.18), width: 1.4),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.45),
              blurRadius: 40,
              offset: const Offset(0, -12),
            ),
            BoxShadow(
              color: AppColors.kEmerald.withOpacity(0.08),
              blurRadius: 60,
              spreadRadius: 4,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Column(
              children: [
                // Header Section
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.5.h),
                  decoration: BoxDecoration(
                    color: AppColors.kSurface.withOpacity(0.85),
                    border: Border(
                      bottom: BorderSide(
                        color: AppColors.kEmerald.withOpacity(0.15),
                        width: 1.2,
                      ),
                    ),
                  ),
                  child: Column(
                    children: [
                      const DragHandle(),
                      SizedBox(height: 1.8.h),
                      StepperHeader(
                        currentStep: currentStep,
                        steps: steps,
                        onBackPressed: currentStep > 0 ? _goBack : null,
                      ),
                    ],
                  ),
                ),

                // Content
                Expanded(
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: SingleChildScrollView(
                      controller: scrollController,
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
                      child: _currentStepContent(),
                    ),
                  ),
                ),

                // Submit Button (only on last step)
                if (currentStep == steps.length - 1)
                  Container(
                    padding: EdgeInsets.fromLTRB(6.w, 2.h, 6.w, 5.h),
                    decoration: BoxDecoration(
                      color: AppColors.kSurface.withOpacity(0.88),
                      border: Border(
                        top: BorderSide(
                          color: AppColors.kEmerald.withOpacity(0.15),
                          width: 1.2,
                        ),
                      ),
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      height: 58,
                      child: CustomButton(
                        text: "Submit Case Application",
                        onPressed: _submitApplication,
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
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}