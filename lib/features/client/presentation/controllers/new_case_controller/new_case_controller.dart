import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:lawyer_app/di/injection_container.dart';
import 'package:lawyer_app/features/client/domain/repositories/client_repository.dart';
import 'package:lawyer_app/features/client/domain/usecases/client_usecases.dart';
import 'package:lawyer_app/features/client/presentation/states/new_case_state/new_case_state.dart';
import 'package:lawyer_app/services/notification_services/notification_service.dart';

class NewCaseController extends StateNotifier<NewCaseState> {
  final CreateCaseUseCase _createCaseUseCase;

  NewCaseController({CreateCaseUseCase? createCaseUseCase})
      : _createCaseUseCase = createCaseUseCase ?? sl<CreateCaseUseCase>(),
        super(NewCaseInitial());

  Future<void> submitApplication({
    required String category,
    required String method, // "upload" or "whatsapp"
    List<File>? document,
    required String appointmentType, // "video" or "walkin"
    DateTime? date,
    TimeOfDay? time,
  }) async {
    log('NewCaseController.submitApplication() called');
    state = NewCaseLoading();

    try {
      String caseType = category.trim();
      if (caseType.toLowerCase() == "civil") {
        caseType = "Civili";
      }

      String submissionMethod = (method.toLowerCase() == "upload" || method.toLowerCase() == "uploaddocument")
          ? "UploadDocument"
          : "WhatsApp";

      String appointmentTypeVal = (appointmentType.toLowerCase() == "video" || appointmentType.toLowerCase() == "videocall")
          ? "VideoCall"
          : "WalkIn";

      DateTime appointmentDate = DateTime.now();
      if (date != null) {
        if (time != null) {
          appointmentDate = DateTime(date.year, date.month, date.day, time.hour, time.minute);
        } else {
          appointmentDate = date;
        }
      }

      File? uploadFile;
      if (document != null && document.isNotEmpty) {
        uploadFile = document.first;
      } else {
        final tempDir = Directory.systemTemp;
        final tempFile = File('${tempDir.path}/whatsapp_case_request.txt');
        await tempFile.writeAsString("WhatsApp Case Submission request for category: $category");
        uploadFile = tempFile;
      }

      log("=== NEW CASE SUBMISSION (API CALL) ===");
      log("Category / CaseType: $caseType");
      log("Method / SubmissionMethod: $submissionMethod");
      log("Document / File: ${uploadFile.path}");
      log("Appointment / Appointment_Type: $appointmentTypeVal");
      log("AppointmentDate: ${appointmentDate.toIso8601String()}");
      log("======================================");

      final params = CreateCaseParams(
        caseType: caseType,
        appointmentType: appointmentTypeVal,
        appointmentDate: appointmentDate.toIso8601String(),
        submissionMethod: submissionMethod,
        filePath: uploadFile.path,
      );

      await _createCaseUseCase.execute(params);

      state = NewCaseSuccess(
        "Your application has been submitted successfully! Our team will contact you shortly.",
      );

      try {
        log('Attempting to show application submitted notification');
        await NotificationService().showApplicationSubmittedNotification();
        log('NotificationService.showApplicationSubmittedNotification() completed');
      } catch (e, stack) {
        log('NotificationService error: $e\n$stack');
      }
    } catch (e, stack) {
      log("NewCaseController → Unexpected error: $e\n$stack");
      state = NewCaseFailure("Something went wrong: $e");
    }
  }
}
