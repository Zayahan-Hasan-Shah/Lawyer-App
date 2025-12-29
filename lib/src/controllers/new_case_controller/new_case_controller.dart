import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:lawyer_app/src/states/new_case_state/new_case_state.dart';

class NewCaseController extends StateNotifier<NewCaseState> {
  NewCaseController() : super(NewCaseInitial());

  Future<void> submitApplication({
    required String category,
    required String method, // "upload" or "whatsapp"
    List<File>? document,
    required String appointmentType, // "video" or "walkin"
    DateTime? date,
    TimeOfDay? time,
  }) async {
    state = NewCaseLoading();

    // No API delay — instantly succeed (for now)
    // Remove Future.delayed completely

    try {
      log("=== NEW CASE SUBMISSION (MOCK SUCCESS) ===");
      log("Category: $category");
      log("Method: $method");
      log("Document: ${document ?? 'None'}");
      log("Appointment: $appointmentType");
      if (date != null && time != null) {
        log(
          "Date & Time: ${date.toString()} at ${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}",
        );
      }
      log("===========================================");

      // Simulate successful submission instantly
      state = NewCaseSuccess(
        "Your application has been submitted successfully! Our team will contact you shortly.",
      );
    } catch (e, stack) {
      log("NewCaseController → Unexpected error: $e\n$stack");
      state = NewCaseFailure("Something went wrong. Please try again.");
    }
  }
}
