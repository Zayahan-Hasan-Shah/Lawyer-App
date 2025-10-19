import 'package:flutter_riverpod/legacy.dart';
import 'package:lawyer_app/src/controllers/auth_controller/otp_controller.dart';
import 'package:lawyer_app/src/states/auth_states/otp_state.dart';

final otpProvider = StateNotifierProvider<OtpController, OtpState>(
  (ref) => OtpController(),
);
