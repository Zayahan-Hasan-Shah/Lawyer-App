import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lawyer_app/src/core/constants/app_colors.dart';
import 'package:lawyer_app/src/providers/client_provider/case_category_provider/case_category_provider.dart';
import 'package:lawyer_app/src/providers/new_case_provider/new_case_provider.dart';
import 'package:lawyer_app/src/widgets/common_widgets/custom_button.dart';
import 'package:lawyer_app/src/widgets/common_widgets/custom_dialog.dart';
import 'package:lawyer_app/src/widgets/home_widgets/new_case_widgets/appointment_step.dart';
import 'package:lawyer_app/src/widgets/home_widgets/new_case_widgets/category_step.dart';
import 'package:lawyer_app/src/widgets/home_widgets/new_case_widgets/drag_handle.dart';
import 'package:lawyer_app/src/widgets/home_widgets/new_case_widgets/method_step.dart';
import 'package:lawyer_app/src/widgets/home_widgets/new_case_widgets/review_step.dart';
import 'package:lawyer_app/src/widgets/home_widgets/new_case_widgets/stepper_header.dart';
import 'package:lawyer_app/src/widgets/home_widgets/new_case_widgets/upload_step.dart';
import 'package:lawyer_app/src/widgets/home_widgets/new_case_widgets/whatsapp_step.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

class NewCaseStepperModal extends ConsumerStatefulWidget {
  const NewCaseStepperModal({super.key});

  @override
  ConsumerState<NewCaseStepperModal> createState() =>
      _NewCaseStepperModalState();
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
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
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
            Future.delayed(const Duration(milliseconds: 300), _goToNext);
          },
        );
      case 1:
        return MethodStep(
          selectedMethod: selectedMethod,
          onMethodSelected: (m) {
            setState(() => selectedMethod = m);
            Future.delayed(const Duration(milliseconds: 300), _goToNext);
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
        // WhatsApp step auto-advances
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) _goToNext();
        });
        return const WhatsAppStep();
      case 3:
        return AppointmentStep(
          appointmentType: appointmentType,
          selectedDate: selectedAppointmentDate,
          selectedTime: selectedAppointmentTime,
          onTypeChanged: (type) => setState(() => appointmentType = type),
          onDateChanged: (date) =>
              setState(() => selectedAppointmentDate = date),
          onTimeChanged: (time) =>
              setState(() => selectedAppointmentTime = time),
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
      await ref
          .read(newCaseProvider.notifier)
          .submitApplication(
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
          title: "Success!",
          description: appointmentType == "video"
              ? "Your video appointment application has been submitted! We'll send you payment details and schedule your call shortly."
              : "Your application has been submitted successfully! Our team will contact you shortly.",
          buttonText: "Great!",
          icon: Icons.check_circle,
          buttonGradient: AppColors.buttonGradientColor.colors,
          onPressed: () {
            // Close dialog, then bottom sheet
            Navigator.of(context).pop(); // close dialog
            Navigator.of(context).pop(); // close bottom sheet
          },
        ),
      );
    } catch (e) {
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
      if (!mounted) return;
      // error dialog as you already have
    }
    // context.pop();
    // await Future.delayed(const Duration(milliseconds: 400));

    // try {
    //   await ref.read(newCaseProvider.notifier).submitApplication(
    //         category: selectedCategory!,
    //         method: selectedMethod!,
    //         document: selectedFiles,
    //         appointmentType: appointmentType!,
    //         date: selectedAppointmentDate,
    //         time: selectedAppointmentTime,
    //       );

    //   if (selectedMethod == "whatsapp") await _openWhatsAppChat();

    //   if (!mounted) return;

    //   showDialog(
    //     context: context,
    //     barrierDismissible: false,
    //     builder: (_) => CustomDialog(
    //       title: "Success!",
    //       description: appointmentType == "video"
    //           ? "Your video appointment application has been submitted! We'll send you payment details and schedule your call shortly."
    //           : "Your application has been submitted successfully! Our team will contact you shortly.",
    //       buttonText: "Great!",
    //       icon: Icons.check_circle,
    //       buttonGradient: AppColors.buttonGradientColor.colors,
    //       onPressed: () => context.pop(),
    //     ),
    //   );
    // } catch (e) {
    //   if (!mounted) return;
    //   showDialog(
    //     context: context,
    //     barrierDismissible: false,
    //     builder: (_) => CustomDialog(
    //       title: "Submission Failed",
    //       description: e.toString(),
    //       buttonText: "OK",
    //       icon: Icons.error_outline,
    //       buttonGradient: const [Color(0xFFFF6B6B), Color(0xFFC0392B)],
    //       onPressed: () => context.pop(),
    //     ),
    //   );
    // }
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
      initialChildSize: 0.9,
      minChildSize: 0.6,
      maxChildSize: 0.95,
      builder: (_, scrollController) => Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.backgroundColor,
              AppColors.backgroundColor.withOpacity(0.95),
            ],
          ),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          boxShadow: [
            BoxShadow(
              color: AppColors.brightYellowColor.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
              child: Column(
                children: [
                  const DragHandle(),
                  StepperHeader(
                    currentStep: currentStep,
                    steps: steps,
                    onBackPressed: currentStep > 0 ? _goBack : null,
                  ),
                ],
              ),
            ),
            Expanded(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 5.w,
                      vertical: 2.h,
                    ),
                    child: _currentStepContent(),
                  ),
                ),
              ),
            ),
            if (currentStep == steps.length - 1)
              Padding(
                padding: EdgeInsets.all(5.w),
                child: CustomButton(
                  text: "Submit Application",
                  onPressed: _submitApplication,
                  gradient: AppColors.buttonGradientColor,
                  textColor: AppColors.blackColor,
                  fontSize: 18.sp,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
