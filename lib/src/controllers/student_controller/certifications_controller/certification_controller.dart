import 'dart:developer';

import 'package:flutter_riverpod/legacy.dart';
import 'package:lawyer_app/src/core/mock_data/student_certifications_data.dart';
import 'package:lawyer_app/src/models/student_model/certification_model.dart';
import 'package:lawyer_app/src/states/student_states/certification_states.dart';

class CertificationController extends StateNotifier<CertificationStates> {
  CertificationController() : super(CertificationInitialState());

  Future<void> getAllCertifications() async {
    state = CertificationLoadingState();
    try {
      await Future.delayed(const Duration(seconds: 1));

      final response = mockStudentCertificationsData;
      if (response['status'] != 200) {
        state = CertificationFailureState(error: 'Failed to load certifications');
        return;
      }

      final data = response['data'] as Map<String, dynamic>;

      final completedList = (data['completed_certifications'] as List)
          .map((e) => CertificationModel.fromJson(e as Map<String, dynamic>))
          .toList();

      final availableList = (data['available_certifications'] as List)
          .map((e) => CertificationModel.fromJson(e as Map<String, dynamic>))
          .toList();

      final allCertifications = AllCertificationsResponse(
        completedCertifications: completedList,
        availableCertifications: availableList,
      );

      state = CertificationSuccessState(data: allCertifications);
    } catch (e, stack) {
      log('Get All Certifications → Error: $e\n$stack');
      state = CertificationFailureState(error: 'Unable to load certifications data');
    }
  }

  Future<void> enrollInCertification(String certificationId) async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));

      if (state is CertificationSuccessState) {
        final currentData = (state as CertificationSuccessState).data;
        final completedCertifications = List<CertificationModel>.from(currentData.completedCertifications);
        final availableCertifications = List<CertificationModel>.from(currentData.availableCertifications);

        final certificationToEnroll = availableCertifications.firstWhere(
          (certification) => certification.id == certificationId,
          orElse: () => throw Exception('Certification not found'),
        );

        // Move certification from available to completed (simulating enrollment completion)
        final enrolledCertification = CertificationModel(
          id: certificationToEnroll.id,
          title: certificationToEnroll.title,
          description: certificationToEnroll.description,
          startDate: certificationToEnroll.startDate,
          endDate: certificationToEnroll.endDate,
          certificateImage: certificationToEnroll.certificateImage,
          isCompleted: true,
          duration: certificationToEnroll.duration,
          instructor: certificationToEnroll.instructor,
          level: certificationToEnroll.level,
          skills: certificationToEnroll.skills,
        );

        availableCertifications.removeWhere((certification) => certification.id == certificationId);
        completedCertifications.add(enrolledCertification);

        final updatedData = AllCertificationsResponse(
          completedCertifications: completedCertifications,
          availableCertifications: availableCertifications,
        );

        state = CertificationSuccessState(data: updatedData);
      }
    } catch (e, stack) {
      log('Enroll in Certification → Error: $e\n$stack');
      state = CertificationFailureState(error: 'Failed to enroll in certification');
    }
  }

  Future<void> refreshCertifications() async {
    await getAllCertifications();
  }
}
