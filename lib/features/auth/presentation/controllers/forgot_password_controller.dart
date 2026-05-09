import 'package:flutter_riverpod/legacy.dart';
import 'package:lawyer_app/core/network/api_exceptions.dart';
import 'package:lawyer_app/di/injection_container.dart';
import 'package:lawyer_app/features/auth/domain/usecases/auth_usecases.dart';
import 'package:lawyer_app/features/auth/presentation/states/forogot_password_State.dart';

class ForgotPasswordController extends StateNotifier<ForgotPasswordState> {
  final ForgotPasswordUseCase _forgotPasswordUseCase;

  ForgotPasswordController({ForgotPasswordUseCase? useCase})
      : _forgotPasswordUseCase = useCase ?? sl<ForgotPasswordUseCase>(),
        super(ForgotPasswordInitial());

  Future<String> forgotPassword({required String email}) async {
    state = ForgotPasswordLoading();
    try {
      final responseData = await _forgotPasswordUseCase.execute(email);
      final String message = responseData['message'] ?? 'Code sent';
      state = ForgotPasswordSuccess(message);
      return "";
    } on ApiException catch (e) {
      state = ForgotPasswordFailure(e.message);
      return e.message;
    } catch (e) {
      state = ForgotPasswordFailure("Network error. Please try again.");
      return "Network error. Please try again.";
    }
  }
}
