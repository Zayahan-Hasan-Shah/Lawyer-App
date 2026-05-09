import 'package:flutter_riverpod/legacy.dart';
import 'package:lawyer_app/features/student/presentation/controllers/certifications_controller/certification_controller.dart';
import 'package:lawyer_app/features/student/presentation/states/certification_states.dart';

final certificationControllerProvider =
    StateNotifierProvider<CertificationController, CertificationStates>((ref) {
  return CertificationController();
});

