import 'package:flutter_riverpod/legacy.dart';
import 'package:lawyer_app/src/controllers/student_controller/certifications_controller/certification_controller.dart';
import 'package:lawyer_app/src/states/student_states/certification_states.dart';

final certificationControllerProvider =
    StateNotifierProvider<CertificationController, CertificationStates>((ref) {
  return CertificationController();
});
