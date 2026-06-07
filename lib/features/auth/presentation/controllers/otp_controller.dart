import 'package:flutter_riverpod/legacy.dart';
import 'package:lawyer_app/core/constants/app_keys.dart';
import 'package:lawyer_app/core/network/api_exceptions.dart';
import 'package:lawyer_app/core/utils/storage/storage_service.dart';
import 'package:lawyer_app/di/injection_container.dart';
import 'package:lawyer_app/features/auth/domain/usecases/auth_usecases.dart';
import 'package:lawyer_app/features/auth/presentation/states/otp_state.dart';

class OtpController extends StateNotifier<OtpState> {
  final OtpUseCase _otpUseCase;

  OtpController({OtpUseCase? useCase})
    : _otpUseCase = useCase ?? sl<OtpUseCase>(),
      super(OtpStateInitial());

  Future<String> verifyOtp(String otp) async {
    state = OtpStateLoading();
    try {
      final email =
          await StorageService.instance.read(AppKeys.forgotEmailKey) ?? "";
      final responseData = await _otpUseCase.execute(email, otp);
      final String message = responseData['message'] ?? 'OTP verified';
      state = OtpStateSuccess(message);
      return "";
    } on ApiException catch (e) {
      state = OtpStateFailure(e.message);
      return e.message;
    } catch (e) {
      state = OtpStateFailure("Network error. Please try again.");
      return "Network error";
    }
  }
}
