import 'package:flutter_riverpod/legacy.dart';
import 'package:lawyer_app/core/network/api_exceptions.dart';
import 'package:lawyer_app/core/utils/storage/storage_service.dart';
import 'package:lawyer_app/di/injection_container.dart';
import 'package:lawyer_app/features/auth/domain/usecases/auth_usecases.dart';
import 'package:lawyer_app/features/auth/presentation/states/reset_password_state.dart';

class ResetPasswordController extends StateNotifier<ResetPasswordState> {
  final ResetPasswordUseCase _resetPasswordUseCase;

  ResetPasswordController({ResetPasswordUseCase? useCase})
      : _resetPasswordUseCase = useCase ?? sl<ResetPasswordUseCase>(),
        super(ResetPasswordStateInitial());

  Future<String> resetPassword(String newPassword) async {
    state = ResetPasswordStateLoading();
    try {
      final email = await StorageService.instance.getForgotEmail() ?? "";
      final responseData = await _resetPasswordUseCase.execute(email, newPassword);
      final String message = responseData['message'] ?? 'Password reset successfully';
      state = ResetPasswordStateSuccess(message);
      return message; // Return success message to satisfy isNotEmpty check
    } on ApiException catch (e) {
      state = ResetPasswordStateFailure(e.message);
      return "";
    } catch (e) {
      state = ResetPasswordStateFailure("Network error. Please try again.");
      return "";
    }
  }
}
